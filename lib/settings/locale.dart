import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Locale defaultLocale = const Locale("en", "US");

List<Locale> supportedLocales = const [
  Locale('en', 'US'),
  Locale('it', 'IT'),
];

List<LocalizationsDelegate> localizationsDelegate = const [
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

