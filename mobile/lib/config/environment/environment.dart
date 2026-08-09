enum AppEnv {
  development,
  staging,
  production;

  static AppEnv fromString(String value) {
    switch (value.toLowerCase()) {
      case 'staging':
        return AppEnv.staging;
      case 'production':
        return AppEnv.production;
      case 'development':
      default:
        return AppEnv.development;
    }
  }
}

class Environment {
  static String get envName => const String.fromEnvironment(
        'APP_ENV',
        defaultValue: 'development',
      );

  static AppEnv get currentEnv => AppEnv.fromString(envName);

  static String get apiBaseUrl => const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://localhost:3000/api/v1',
      );

  static String get supabaseUrl => const String.fromEnvironment(
        'SUPABASE_URL',
        defaultValue: 'https://qnexcdrdvdxdggllanre.supabase.co',
      );

  static String get supabaseAnonKey => const String.fromEnvironment(
        'SUPABASE_ANON_KEY',
        defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFuZXhjZHJkdmR4ZGdnbGxhbnJlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODYxOTY4NzYsImV4cCI6MjEwMTc3Mjg3Nn0.IQKmJomuYDzL1IWa3seyOPj17DQGHZFvMakqBrTL-6I',
      );

  static String get supabasePublishableKey => const String.fromEnvironment(
        'SUPABASE_PUBLISHABLE_KEY',
        defaultValue: 'sb_publishable_QCG3jmV4MiNhoaoH12sErQ_nOeLJIPn',
      );

  static bool get isDevelopment => currentEnv == AppEnv.development;
  static bool get isStaging => currentEnv == AppEnv.staging;
  static bool get isProduction => currentEnv == AppEnv.production;
}