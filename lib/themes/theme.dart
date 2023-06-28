import 'package:flutter/material.dart';

import 'typography.dart';
import 'colors.dart';

ThemeData getTheme({required bool darkTheme, required int fontSize}){
  return darkTheme
      ? ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Montserrat',
        colorScheme: appColorsDark,
        textTheme: getDarkTextTheme(fontSize),
        buttonTheme: ButtonThemeData(
          colorScheme: appColorsLight,
        ),
      )

      : ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Montserrat',
        colorScheme: appColorsLight,
        textTheme: getLightTextTheme(fontSize),
        buttonTheme: ButtonThemeData(
          colorScheme: appColorsLight,
        ),
      );
}