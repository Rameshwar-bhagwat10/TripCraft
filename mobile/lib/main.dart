import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'app/app_bootstrap.dart';

void main() async {
  await bootstrapApplication();
  runApp(
    const ProviderScope(
      child: TripCraftApp(),
    ),
  );
}
