import 'package:flutter/material.dart';

import 'colors.dart';


class AppInputs {

  static const TextStyle fontText = TextStyle(
    fontSize: 14,
  );

  static final OutlineInputBorder _customBorder =  OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        width: .8,
        color: AppColors.gray
      )
    );

  static InputDecorationTheme get customInputForm => InputDecorationTheme(
        hintStyle: fontText.copyWith(color: AppColors.hintText),
        labelStyle: fontText.copyWith(color: AppColors.black),
        filled: true,
        fillColor: AppColors.input,
        border: _customBorder,
        enabledBorder: _customBorder,
        focusedBorder: _customBorder,
        focusedErrorBorder: _customBorder,
        contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 16)

      );


}
