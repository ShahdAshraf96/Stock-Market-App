import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppThemeManager {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.white,
    textTheme: ThemeData().textTheme.apply(
      bodyColor: Colors.black,
      displayColor: Colors.black
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white,
      centerTitle: true,
    )
  );
  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.dark,
    textTheme: ThemeData().textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.dark,
      centerTitle: true,
    )
  );
}
