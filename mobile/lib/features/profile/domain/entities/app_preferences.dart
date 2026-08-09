/// Language Model for Application Preferences in TripCraft.
class Language {
  final String code;
  final String name;
  final String nativeName;

  const Language({
    required this.code,
    required this.name,
    required this.nativeName,
  });

  static const List<Language> supportedLanguages = [
    Language(code: 'en', name: 'English', nativeName: 'English'),
    Language(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी'),
    Language(code: 'mr', name: 'Marathi', nativeName: 'मराठी'),
    Language(code: 'es', name: 'Spanish', nativeName: 'Español'),
    Language(code: 'fr', name: 'French', nativeName: 'Français'),
    Language(code: 'de', name: 'German', nativeName: 'Deutsch'),
  ];

  static Language fromCode(String code) {
    return supportedLanguages.firstWhere(
      (lang) => lang.code.toLowerCase() == code.toLowerCase(),
      orElse: () => supportedLanguages.first,
    );
  }
}

/// Currency Model for Application Preferences in TripCraft.
class Currency {
  final String code;
  final String symbol;
  final String name;

  const Currency({
    required this.code,
    required this.symbol,
    required this.name,
  });

  static const List<Currency> supportedCurrencies = [
    Currency(code: 'USD', symbol: '\$', name: 'US Dollar'),
    Currency(code: 'INR', symbol: '₹', name: 'Indian Rupee'),
    Currency(code: 'EUR', symbol: '€', name: 'Euro'),
    Currency(code: 'GBP', symbol: '£', name: 'British Pound'),
    Currency(code: 'AUD', symbol: 'A\$', name: 'Australian Dollar'),
    Currency(code: 'CAD', symbol: 'C\$', name: 'Canadian Dollar'),
    Currency(code: 'JPY', symbol: '¥', name: 'Japanese Yen'),
  ];

  static Currency fromCode(String code) {
    return supportedCurrencies.firstWhere(
      (c) => c.code.toUpperCase() == code.toUpperCase(),
      orElse: () => supportedCurrencies.first,
    );
  }
}
