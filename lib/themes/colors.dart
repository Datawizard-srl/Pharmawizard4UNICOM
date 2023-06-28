import 'package:flutter/material.dart';

final ColorScheme appColorsLight = ColorScheme.fromSwatch().copyWith(
  brightness: Brightness.light,
  primary: const Color(0xffff8400),
  background: const Color(0xffffefd7),
  secondary: const Color(0xffff9e35),
  shadow: const Color(0x1111110a),
  outline: const Color(0xff555555),
  onBackground: Colors.black,
  onSurfaceVariant: Colors.blueAccent,
);

final ColorScheme appColorsDark = ColorScheme.fromSwatch().copyWith(
  brightness: Brightness.dark,
  primary: const Color(0xff033a41),
  background: const Color(0xff575c5d),
  secondary: const Color(0xff647b7e),
  shadow: const Color(0x11FFFF00),
  onBackground: Colors.white,
  onSurfaceVariant: const Color(0xffff9e35),
);

const Color dividerColor = Color(0x94a2a266);