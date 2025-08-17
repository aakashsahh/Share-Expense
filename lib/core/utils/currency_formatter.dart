import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat.currency(
    symbol: 'Rs ',
    decimalDigits: 2,
  );

  static String format(double amount) {
    // If amount is a whole number (e.g., 1000.00), show without decimals
    if (amount % 1 == 0) {
      return 'Rs ${NumberFormat('#,##0').format(amount)}';
    }
    // Otherwise, show with 2 decimal places
    return _formatter.format(amount);
  }

  static String formatWithoutSymbol(double amount) {
    if (amount % 1 == 0) {
      return NumberFormat('#,##0').format(amount);
    }
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
