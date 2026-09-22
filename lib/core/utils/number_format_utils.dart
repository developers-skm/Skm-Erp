/// Formats an integer with thousands separators (e.g. 42850 -> "42,850").
///
/// A small local helper is used instead of `intl` to avoid an extra
/// dependency for a single formatting need in Phase 1.
String formatThousands(int value) {
  final str = value.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < str.length; i++) {
    final posFromEnd = str.length - i;
    buffer.write(str[i]);
    if (posFromEnd > 1 && posFromEnd % 3 == 1) buffer.write(',');
  }
  return value < 0 ? '-$buffer' : buffer.toString();
}
