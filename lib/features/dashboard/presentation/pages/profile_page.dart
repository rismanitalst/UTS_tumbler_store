import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tumbler_store/features/auth/presentation/providers/auth_provider.dart';
import 'package:tumbler_store/core/routes/app_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const _pink = Color(0xFFE8829A);
  static const _pinkLight = Color(0xFFFDE8EE);
  static const _bg = Color(0xFFFFF0F5);
  static const _textPrimary = Color(0xFF2D2D2D);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.firebaseUser;
    final name = user?.displayName ?? 'User';
    final email = user?.email ?? '-';
    final createdAt = user?.metadata.creationTime;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF4A7B9), Color(0xFFFFCDD2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Profil Saya',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _pink.withValues(alpha: 0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        name.isNotEmpty
                          ? name
                              .trim()
                              .split(' ')
                              .take(2)
                              .map((e) => e[0].toUpperCase())
                              .join()
                          : 'U',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: _pink,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Akun',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: _textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _InfoCard(
                      icon: Icons.person_outline_rounded,
                      label: 'Nama',
                      value: name,
                    ),
                    const SizedBox(height: 10),
                    _InfoCard(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: email,
                    ),
                    const SizedBox(height: 10),
                    _InfoCard(
                      icon: Icons.verified_outlined,
                      label: 'Status Email',
                      value: user?.emailVerified == true
                          ? 'Terverifikasi'
                          : 'Belum Terverifikasi',
                      valueColor: user?.emailVerified == true
                          ? Colors.green
                          : Colors.orange,
                    ),
                    const SizedBox(height: 10),
                    _InfoCard(
                      icon: Icons.shield_outlined,
                      label: 'Role',
                      value: 'User',
                    ),
                    if (createdAt != null) ...[
                      const SizedBox(height: 10),
                      _InfoCard(
                        icon: Icons.calendar_today_outlined,
                        label: 'Bergabung Sejak',
                        value:
                            '${createdAt.day}/${createdAt.month}/${createdAt.year}',
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Lainnya',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: _textPrimary,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () async {
                          final auth = context.read<AuthProvider>();
                          await auth.logout();
                          if (!context.mounted) return;
                          Navigator.pushReplacementNamed(context, AppRouter.login);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pink.withValues(alpha: 0.06),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _pinkLight,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.logout_rounded,
                                  color: _pink,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _pink,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: Color(0xFF9E9E9E),
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  static const _pink = Color(0xFFE8829A);
  static const _pinkLight = Color(0xFFFDE8EE);
  static const _textPrimary = Color(0xFF2D2D2D);
  static const _textSecondary = Color(0xFF9E9E9E);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _pinkLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: _pink, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: _textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? _textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}