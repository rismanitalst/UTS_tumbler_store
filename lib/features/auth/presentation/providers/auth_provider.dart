import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tumbler_store/core/services/dio_client.dart';
import 'package:tumbler_store/core/services/secure_storage.dart';
import 'package:tumbler_store/core/constants/api_constants.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  emailNotVerified,
  error,
}

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthStatus _status = AuthStatus.initial;
  User? _firebaseUser;
  String? _backendToken;
  String? _errorMessage;

  // ─── Getters ─────────────────────────────────────────────
  AuthStatus get status => _status;
  User? get firebaseUser => _firebaseUser;
  String? get backendToken => _backendToken;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == AuthStatus.loading;

  // ─── REGISTER ────────────────────────────────────────────
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _setLoading();

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _firebaseUser = credential.user;

      await _firebaseUser?.updateDisplayName(name);
      await _firebaseUser?.sendEmailVerification();

      _status = AuthStatus.emailNotVerified;
      notifyListeners();

      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e.code));
      return false;
    }
  }

  // ─── CHECK EMAIL VERIFIED (Polling) ──────────────────────
  Future<bool> checkEmailVerified() async {
    try {
      await _firebaseUser?.reload();
      _firebaseUser = _auth.currentUser;

      if (_firebaseUser?.emailVerified ?? false) {
        return await _verifyTokenToBackend();
      }

      return false;
    } catch (e) {
      _setError('Gagal cek verifikasi email');
      return false;
    }
  }

  // ─── VERIFY TOKEN KE BACKEND ─────────────────────────────
  Future<bool> _verifyTokenToBackend() async {
    try {
      await _firebaseUser?.reload();
      _firebaseUser = _auth.currentUser;

      final firebaseToken = await _firebaseUser?.getIdToken(true);

      print('TOKEN: $firebaseToken');

      final response = await DioClient.instance.post(
        ApiConstants.verifyToken,
        data: {
          'firebase_token': firebaseToken,
        },
      );

      final data = response.data['data'] as Map<String, dynamic>;
      final backendToken = data['access_token'] as String;

      await SecureStorageService.saveToken(backendToken);

      _backendToken = backendToken;
      _status = AuthStatus.authenticated;
      notifyListeners();

      return true;
    } catch (e) {
      print('VERIFY ERROR: $e');
      _setError('Gagal verifikasi ke server');
      return false;
    }
  }

  // ─── LOGIN EMAIL ─────────────────────────────────────────
  Future<bool> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading();

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _firebaseUser = credential.user;

      if (!(_firebaseUser?.emailVerified ?? false)) {
        _status = AuthStatus.emailNotVerified;
        notifyListeners();
        return false;
      }

      return await _verifyTokenToBackend();
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e.code));
      return false;
    }
  }

  // ─── LOGIN GOOGLE ────────────────────────────────────────
  Future<bool> loginWithGoogle() async {
    try {
      _setLoading();

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _setError('Login Google dibatalkan');
        return false;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(credential);
      _firebaseUser = userCred.user;

      return await _verifyTokenToBackend();
    } catch (e) {
      _setError('Gagal login Google');
      return false;
    }
  }

  // ─── RESEND EMAIL ────────────────────────────────────────
  Future<void> resendVerificationEmail() async {
    await _firebaseUser?.sendEmailVerification();
  }

  // ─── LOGOUT ──────────────────────────────────────────────
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await SecureStorageService.clearAll();

    _firebaseUser = null;
    _backendToken = null;
    _status = AuthStatus.unauthenticated;

    notifyListeners();
  }

  // ─── HELPERS ─────────────────────────────────────────────
  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
    notifyListeners();
  }

  String _mapFirebaseError(String code) => switch (code) {
        'email-already-in-use' => 'Email sudah terdaftar.',
        'user-not-found' => 'Akun tidak ditemukan.',
        'wrong-password' => 'Password salah.',
        'invalid-email' => 'Format email tidak valid.',
        'weak-password' => 'Password terlalu lemah.',
        'network-request-failed' => 'Tidak ada koneksi internet.',
        _ => 'Terjadi kesalahan.',
      };
}