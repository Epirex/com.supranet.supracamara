import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_editors/screens/login_screen.dart';
import 'package:video_editors/themes/colors.dart';
import 'package:video_editors/themes/themes.dart';
import 'package:google_fonts/google_fonts.dart';

import 'initial_bindings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeApp themeApp = ThemeApp();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.appColor1,
        //backgroundColor: AppColors.appColor1,
        textSelectionTheme: const TextSelectionThemeData(
            cursorColor: AppColors.black,
            selectionHandleColor: AppColors.white),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        inputDecorationTheme: themeApp.customInputForm,
        textTheme: themeApp.textTheme,
        elevatedButtonTheme: themeApp.buttonTheme,
        iconButtonTheme: themeApp.iconButtonTheme,
        fontFamily: GoogleFonts.roboto().fontFamily,
      ),
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();
        final data = MediaQuery.of(context);
        final smallestSize = min(data.size.width, data.size.height);
        final textScaleFactor = min(smallestSize / 375, 1.0);
        return MediaQuery(
          data: data.copyWith(
            textScaleFactor: textScaleFactor,
          ),
          child: child,
        );
      },
      title: 'Tennis 360',
      home: const LoginScreen(),
      initialBinding: InitialBindings(),
    );
  }
}
