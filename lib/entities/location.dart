import 'dart:ui';

class Location {
  late final int id;
  //late final int code;
  late final String name;
  late final String langCode;

  Location({
    required this.id,
    //required this.code,
    required this.name,
    required this.langCode,
  });

  Location.fromMap(Map<String, dynamic> locationMap) {
    id = locationMap['id'];
    //code = locationMap['code'];
    name = locationMap['name'];
    langCode = locationMap['langCode'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      //'code': code,
      'name': name,
      'langCode': langCode
    };
  }

  @override
  String toString() {
    return '(id: $id, name: $name, langCode: $langCode)';
  }

  @override
  bool operator == (Object other) =>
      identical(this, other) || other is Location
          && runtimeType == other.runtimeType
          && id == other.id
          && langCode == other.langCode;

  @override
  int get hashCode => id.hashCode;

  static Locale localeFromStringSeparator(String localeString, String separator) {
    List<String> lan = localeString.split(separator);
    if (lan.length > 1) return Locale(lan[0], lan[1]);
    return Locale(lan[0]);
  }

  static Locale localeFromString(String localeString) {
    return localeFromStringSeparator(localeString, "_");
  }
}
