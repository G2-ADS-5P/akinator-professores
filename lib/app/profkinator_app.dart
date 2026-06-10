import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../pages/home_page.dart';

class ProfkinatorApp extends StatelessWidget {
  const ProfkinatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profkinator ADS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
      ),
      home: const HomePage(),
    );
  }
}
