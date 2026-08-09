import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/environment/environment.dart';
import '../core/logging/app_logger.dart';

Future<void> bootstrapApplication() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    AppLogger.info("App bootstrapping started (Current Env: ${Environment.envName})...");

    // Initialize Supabase Client
    AppLogger.info("Initializing Supabase Client...");
    await Supabase.initialize(
      url: Environment.supabaseUrl,
      publishableKey: Environment.supabaseAnonKey,
    );
    AppLogger.info("Supabase initialized successfully.");
    
    AppLogger.info("App bootstrapping complete.");
  } catch (error, stack) {
    AppLogger.error("Fatal error during bootstrap sequence", error, stack);
    rethrow;
  }
}