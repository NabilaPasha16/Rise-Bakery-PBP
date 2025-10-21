import 'package:intl/intl.dart';

/// Format number to Indonesian Rupiah string. Uses no decimal places.
String formatRupiah(num value) {
  final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  return formatter.format(value);
}
