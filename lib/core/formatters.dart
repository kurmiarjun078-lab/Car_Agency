/// Formats a price. For ₹ the grouping follows the Figma exactly
/// (e.g. 7500000 -> ₹75,00,000 and 11200000 -> ₹112,00,000).
String formatPrice(int value, {String symbol = '₹'}) {
  final s = value.toString();
  if (symbol == '₹') return '$symbol${_indian(s)}';
  return '$symbol${_western(s)}';
}

String _indian(String s) {
  if (s.length <= 3) return s;
  final last3 = s.substring(s.length - 3);
  final rest = s.substring(0, s.length - 3);
  if (rest.length <= 2) return '$rest,$last3';
  final lakh = rest.substring(rest.length - 2);
  final head = rest.substring(0, rest.length - 2);
  return '$head,$lakh,$last3';
}

String _western(String s) {
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return b.toString();
}

const List<String> _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String formatDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';
