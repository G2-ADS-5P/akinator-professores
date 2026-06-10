import 'package:flutter/material.dart';

/// Paleta de cores do Profkinator ADS.
class AppColors {
  static const primary = Color(0xFF5A189A);
  static const secondary = Color(0xFF7B2CBF);
  static const accent = Color(0xFF9D4EDD);
  static const gold = Color(0xFFFFD166);
  static const background = Color(0xFFF8F7FC);
  static const card = Colors.white;
  static const text = Color(0xFF222222);
  static const muted = Color(0xFF777777);
  static const success = Color(0xFF2D6A4F);
  static const danger = Color(0xFFB00020);

  /// Degradê usado nos fundos das telas.
  static const gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF3C096C), Color(0xFF5A189A), Color(0xFF7B2CBF)],
  );
}
