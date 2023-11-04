/// Archivo para exportar todos los themes de la aplicacion
///

import 'package:flutter/material.dart';
import 'package:video_editors/themes/tiles.dart';


import 'buttons.dart';
import 'inputs.dart';


class ThemeApp {

  TextTheme get textTheme => TextTheme(
    displayLarge: AppTitles.displayLarge,
    displayMedium: AppTitles.displayMedium,
    displaySmall: AppTitles.displaySmall,
    titleLarge: AppTitles.titleLarge,
    titleMedium: AppTitles.titleMedium,
    titleSmall: AppTitles.titleSmall,
  );
  InputDecorationTheme get customInputForm => AppInputs.customInputForm;
  ElevatedButtonThemeData get buttonTheme => ElevatedButtonThemeData(
    style: AppCustomButtons.elevatedButton
  );
  IconButtonThemeData get iconButtonTheme => IconButtonThemeData(
    style: AppCustomButtons.iconButton
  );
}