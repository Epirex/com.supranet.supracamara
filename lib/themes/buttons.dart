
import 'package:flutter/material.dart';

import 'colors.dart';


class AppCustomButtons {

  static ButtonStyle get elevatedButton {
    return ButtonStyle(
      textStyle: MaterialStateProperty.all(const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold
      )),
      elevation: MaterialStateProperty.all(0),
      foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        return AppColors.white; // Regular color
      }),
      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 8,vertical: 14)),
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        return AppColors.appColor1; // Regular color
      }),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      )),
    );
  }
  static ButtonStyle get iconButton {
    return ButtonStyle(
      textStyle: MaterialStateProperty.all(const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold
      )),
      elevation: MaterialStateProperty.all(0),
      foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if(states.contains(MaterialState.disabled)) {
          return AppColors.hintText;
        }
          return AppColors.white; // Regular color
      }),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      )),
    );
  }
}