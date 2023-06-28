import 'dart:ui';
import 'package:universal_io/io.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class LocaleUtils {
  static Locale deviceLocale(){
    return localeFromStringSeparator(Platform.localeName, '-');
  }

  static Locale localeFromStringSeparator(String localeString, String separator) {
    List<String> lan = localeString.split(separator);
    if (lan.length > 1) return Locale(lan[0], lan[1]);
    return Locale(lan[0]);
  }

  static Locale localeFromString(String localeString) {
    return localeFromStringSeparator(localeString, "_");
  }

  static AppLocalizations translate(context){
    return AppLocalizations.of(context)!;
  }
}