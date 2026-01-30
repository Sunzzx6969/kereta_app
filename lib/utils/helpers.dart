import 'package:intl/intl.dart';

class AppHelpers {
  /// Format angka menjadi Rupiah (Contoh: 50000 -> Rp 50.000)
  static String formatRupiah(num number) {
    return NumberFormat.currency(
      locale: 'id_ID', 
      symbol: 'Rp ', 
      decimalDigits: 0
    ).format(number);
  }

  /// Format tanggal (Contoh: 2026-01-29 -> 29 Januari 2026)
  static String formatDate(String date) {
    if (date.isEmpty) return "-";
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd MMMM yyyy', 'id_ID').format(dateTime);
  }
}