import 'package:flutter/material.dart';

import 'app_colors.dart';

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.secondaryColor,
  // scaffoldBackgroundColor: Color(0xffFECC00),
  // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
  fontFamily: 'lato',
  primaryTextTheme: const TextTheme(
    bodySmall: TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 20,
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primaryColor,
    iconTheme: IconThemeData(color: Colors.white),
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontFamily: 'montserrat',
      color: Colors.white,
      fontSize: 20,
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.transparent),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      fixedSize: const Size(double.infinity, 50),
      backgroundColor: AppColors.goldColor,
      foregroundColor: Colors.black,
      textStyle: const TextStyle(
        fontFamily: 'lato',
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
);
