import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat.currency(
    symbol: 'Rs ',
    decimalDigits: 2,
  );

  static String format(double amount) {
    return _formatter.format(amount);
  }

  static String formatWithoutSymbol(double amount) {
    return NumberFormat('#,##0.00').format(amount);
  }

  static double parse(String amount) {
    try {
      return double.parse(amount.replaceAll(',', ''));
    } catch (e) {
      return 0.0;
    }
  }
}
