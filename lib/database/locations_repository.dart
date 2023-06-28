import 'package:unicom_patient/entities/location.dart';
import 'package:unicom_patient/utilities/locale_utils.dart';

class LocationsRepository {
  static List<Location> _availableLocations = [];
  static Location? _deviceLocation;

  static Location? getDeviceLocation(){return _deviceLocation;}

  static List<Location> get availableLocations {
    return _availableLocations;
  }

  static Future<void> init() async {
    await fetchLocations();
    _deviceLocation = await getByLangCode(LocaleUtils.deviceLocale().toString());
  }

  static Future<void> fetchLocations() async {
    _availableLocations = [];
    _availableLocations.add(Location(id: 0, name: "English", langCode: "en_EN"));
    _availableLocations.add(Location(id: 1, name: "Italiano", langCode: "it_IT"));
  }

  static Future<Location?> getByLangCode(String langCode) async {
    for (Location l in _availableLocations){
      if (l.langCode == langCode) return l;
    }
    return null;
  }
}
