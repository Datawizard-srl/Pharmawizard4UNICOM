import 'package:flutter/material.dart';

ButtonStyle baseButtonStyle = const ButtonStyle(
  shape: null,
  textStyle: null,
  side: null,
  alignment: null,
  animationDuration: null,
  backgroundColor: null,
  elevation: null,
  enableFeedback: null,
  fixedSize: null,
  foregroundColor: null,
  maximumSize: null,
  minimumSize: null,
  mouseCursor: null,
  overlayColor: null,
  padding: null,
  shadowColor: null,
  splashFactory: null,
  surfaceTintColor: null,
  tapTargetSize: null,
  visualDensity: null,
);

ButtonStyle primaryButtonStyle = baseButtonStyle.copyWith(
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      )
  ),
);