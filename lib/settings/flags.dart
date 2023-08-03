import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

Map<String, String> flagsIcons = {
  "Republic of Estonia": "ee",
  "Kingdom of Sweden": "se",
  "Italian Republic": "it",
  "Hellenic Republic": "gr",
  "United States of America": "us"
};

Widget getFlag(String country, {double height=20, double width=30}){
  String? countryCode = flagsIcons[country];
  if (countryCode == null){
    return const Icon(Icons.question_mark, size: 10);
  }
  return CountryFlags.flag(countryCode, height: height, width: width);
}