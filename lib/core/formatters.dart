/// Formats a price. ₹ uses Indian grouping (7500000 -> ₹75,00,000,
/// 11200000 -> ₹1,12,00,000).
String formatPrice(int value, {String symbol = '₹'}) {
  final s = value.toString();
  if (symbol == '₹') return '$symbol${_indian(s)}';
  return '$symbol${_western(s)}';
}

String _indian(String s) {
  if (s.length <= 3) return s;
  final last3 = s.substring(s.length - 3);
  var rest = s.substring(0, s.length - 3);
  final parts = <String>[];
  while (rest.length > 2) {
    parts.insert(0, rest.substring(rest.length - 2));
    rest = rest.substring(0, rest.length - 2);
  }
  if (rest.isNotEmpty) parts.insert(0, rest);
  return '${parts.join(',')},$last3';
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

/// Short money label for dashboards: ₹2.45 Cr, ₹7.50 L, ₹4,500.
String formatCompactPrice(int value, {String symbol = '₹'}) {
  if (value >= 10000000) return '$symbol${(value / 10000000).toStringAsFixed(2)} Cr';
  if (value >= 100000) return '$symbol${(value / 100000).toStringAsFixed(2)} L';
  return formatPrice(value, symbol: symbol);
}
