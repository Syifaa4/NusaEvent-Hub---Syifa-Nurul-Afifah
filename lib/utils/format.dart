const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
];

String formatRupiah(int value) {
  if (value == 0) return 'Gratis';
  final s = value.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (m) => '.',
      );
  return 'Rp$s';
}

String formatDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

String formatDateRange(DateTime a, DateTime b) {
  if (a.year == b.year && a.month == b.month && a.day == b.day) {
    return formatDate(a);
  }
  return '${a.day}–${formatDate(b)}';
}
