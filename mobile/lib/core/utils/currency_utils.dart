class CurrencyUtils {
  static String formatWithSymbol(double value, String symbol) {
    return '$symbol${value.toStringAsFixed(2)}';
  }
}