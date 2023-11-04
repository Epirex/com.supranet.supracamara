/// Archivo que contiene todos los títulos
///

import 'package:flutter/material.dart';

import 'colors.dart';

class AppTitles {

  static const Color _defaultColorTitle =AppColors.white; 

  AppTitles();

  static TextStyle get textBase => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: _defaultColorTitle
  );

  static TextStyle get displayLarge => textBase.copyWith(
    fontSize: 36,
  );

  static TextStyle get displayMedium => textBase.copyWith(
    fontSize: 32,
  );

  static TextStyle get displaySmall => textBase.copyWith(
    fontSize: 20,
  );

  static TextStyle get titleLarge => textBase.copyWith(
    fontSize: 18,
  );

  static TextStyle get titleMedium => textBase.copyWith(
    fontSize: 16,
  );

  static TextStyle get titleSmall => textBase.copyWith(
    fontSize: 14,
  );

}
