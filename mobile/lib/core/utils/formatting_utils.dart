class FormattingUtils {
  static String formatCurrency(double amount, [String symbol = r'$']) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }
}