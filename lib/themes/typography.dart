import 'package:flutter/material.dart';

import 'colors.dart';

// displayLarge, displayMedium, displaySmall
// headlineLarge, headlineMedium, headlineSmall
// titleLarge, titleMedium, titleSmall
// bodyLarge, bodyMedium, bodySmall
// labelLarge, labelMedium, labelSmall

double fontSizeStep = 3;

TextTheme? getLightTextTheme(int fontSize){
  assert (fontSize >= -1 && fontSize <= 1);

  return TextTheme(
    bodySmall: TextStyle(
      fontSize: 12 + fontSizeStep * fontSize,
      fontWeight: FontWeight.w500,
      color: appColorsLight.onBackground,
    ),

    bodyMedium: TextStyle(
      fontSize: 17 + fontSizeStep * fontSize,
      fontWeight: FontWeight.w400,
      color: appColorsLight.onBackground,
    ),

    headlineLarge: TextStyle(
      fontSize: 48 + fontSizeStep * fontSize,
      fontWeight: FontWeight.w600,
      color: appColorsLight.onBackground,
    ),

    headlineMedium: TextStyle(
      fontSize: 16 + fontSizeStep * fontSize,
      fontWeight: FontWeight.w700,
      color: appColorsLight.onBackground,
    ),

    // AppBar title
    headlineSmall: TextStyle(
      fontSize: 16 + fontSizeStep * fontSize,
      fontWeight: FontWeight.w700,
      color: appColorsLight.onBackground,
    ),
  );
}

TextTheme getDarkTextTheme(int fontSize){
  assert (fontSize >= -1 && fontSize <= 1);

  return TextTheme(
    bodySmall: TextStyle(
      fontSize: 12 + fontSizeStep * fontSize,
      fontWeight: FontWeight.w500,
      color: appColorsDark.onBackground,
    ),

    bodyMedium: TextStyle(
      fontSize: 17 + fontSizeStep * fontSize,
      fontWeight: FontWeight.w400,
      color: appColorsDark.onBackground,
    ),

    headlineLarge: TextStyle(
      fontSize: 48 + fontSizeStep * fontSize,
      fontWeight: FontWeight.w600,
      color: appColorsDark.onBackground,
    ),

    headlineMedium: TextStyle(
      fontSize: 16 + fontSizeStep * fontSize,
      fontWeight: FontWeight.w700,
      color: appColorsDark.onBackground,
    ),

    // AppBar title
    headlineSmall: TextStyle(
      fontSize: 16 + fontSizeStep * fontSize,
      fontWeight: FontWeight.w700,
      color: appColorsDark.onBackground,
    ),
  );
}