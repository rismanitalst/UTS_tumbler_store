extension NumberExtension on num {
  String toRupiah() {
    return 'Rp ${toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (m) => '${m[0]}.',
    )}';
  }
}