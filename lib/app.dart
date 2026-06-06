import 'package:flutter/material.dart';
import 'config/routes/app_router.dart';
import 'core/theme/app_theme.dart';

class SmartPhysioApp extends StatelessWidget {
  const SmartPhysioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Smart Physio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
