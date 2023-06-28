import 'package:flutter/cupertino.dart';
import 'package:unicom_patient/entities/test_entities/medication.dart';
import 'package:unicom_patient/utilities/locale_utils.dart';

import '../location.dart';

class UserInfo extends ChangeNotifier {
  String? _name = 'Anonymous';
  Location? _location;
  bool _languageSelected = false;
  bool _darkMode = false;
  int _fontSize = 0;
  Locale locale = LocaleUtils.deviceLocale();

  List<Medication>? _medicationsList = [];
  Map<String, List<Medication>>? _correlated = {};

  UserInfo();

  UserInfo.compiled({
    String? name,
    Location? selectedLocation,
    List<Medication>? medicationsList,
    Map<String, List<Medication>>? correlated,
    bool languageSelected = false,
    bool darkMode = false,
    int fontSize = 0,
  }) {
   _name = name;
   _location = selectedLocation;
   _correlated = correlated;
   _medicationsList = medicationsList;
   _languageSelected = languageSelected;
   _darkMode = darkMode;
   _fontSize = fontSize;
   locale = LocaleUtils.localeFromString(_location!.langCode);
  }

  set name(String? name) {_name = name; notifyListeners();}
  set medicationsList(List<Medication>? value) {_medicationsList = value; notifyListeners();}
  set languageSelected(bool value) {_languageSelected = value; notifyListeners();}
  set darkMode(bool value) {_darkMode = value; notifyListeners();}
  set fontSize(int value) {_fontSize = value; notifyListeners();}
  set selectedLocation(Location? selectedLocation) {
    _location = selectedLocation;
    locale = LocaleUtils.localeFromString(_location!.langCode);
    notifyListeners();
  }

  String? get name => _name;
  Location? get selectedLocation => _location;
  bool get languageSelected => _languageSelected;
  bool get darkMode => _darkMode;
  int get fontSize => _fontSize;
  List<Medication>? get medicationsList => _medicationsList;
  Map<String, List<Medication>>? get correlated => _correlated;

  List<Medication>? getCorrelatedOf(String medicationId) {
    return _correlated?[medicationId];
  }

  UserInfo.fromMap(Map<String, dynamic> userInfoMap) {
    if (userInfoMap['languageSelected'] != null) {_languageSelected = userInfoMap['languageSelected'];}
    if (userInfoMap['darkMode'] != null){_darkMode = userInfoMap['darkMode'];}
    if (userInfoMap['fontSize'] != null){_fontSize = userInfoMap['fontSize'];}
    if (userInfoMap['name'] != null) {_name = userInfoMap['name'];}
    if (userInfoMap['selectedLocation'] != null) {
      _location = Location.fromMap(userInfoMap['selectedLocation']);
      locale = LocaleUtils.localeFromString(_location!.langCode);
    }

    if (userInfoMap['medicationsList'] != null) {
      for (Map<String, dynamic> medicationMap in userInfoMap['medicationsList']) {
        _medicationsList!.add(Medication.fromMap(medicationMap));
      }
    }

    List<Medication> newCorrelated;
    if (userInfoMap['correlated'] != null) {
      userInfoMap['correlated'].forEach((id, medicationMaps){
        // TODO check id in medicationList
        newCorrelated = [];
        for (Map<String, dynamic> medicationMap in medicationMaps) {
          newCorrelated.add(Medication.fromMap(medicationMap));
        }
        _correlated![id] = newCorrelated;
      });
    }
  }

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> newMedicationList = [];
    for(Medication m in _medicationsList!){
      newMedicationList.add(m.toMap());
    }

    Map<String, List<Map<String, dynamic>>> newCorrelated = {};
    List<Map<String, dynamic>> newCorrelatedList;
    _correlated?.forEach((id, correlatedList){
      // TODO check id in medicationList
      newCorrelatedList = [];
      for (Medication m in correlatedList) {
        newCorrelatedList.add(m.toMap());
      }
      newCorrelated[id] = newCorrelatedList;
    });

    return {
      'name': _name,
      'selectedLocation': _location?.toMap(),
      'medicationsList': newMedicationList,
      'correlated': newCorrelated,
      'languageSelected': _languageSelected,
      'darkMode': _darkMode,
      'fontSize': _fontSize,
    };
  }

  void addMedications(List<Medication> medications) {
    for (Medication m in medications) {
      if(!_medicationsList!.contains(m)){
        _medicationsList!.add(m);
      }
    }
    notifyListeners();
  }

  void removeMedications(List<Medication> medications) {
    for (Medication m in medications) {
      _medicationsList?.remove(m);
      _correlated?.remove(m.id);
    }
    notifyListeners();
  }

  void removeCorrelated(String medicationId, List<Medication> medications){
    _correlated?[medicationId]?.removeWhere( (item) => medications.contains(item) );
    notifyListeners();
  }

  void addCorrelated(String medicationId, List<Medication> correlated) {
    if(medicationsList!.where((element) => element.id == medicationId).isEmpty){
      throw AssertionError('$medicationId is not in medication list');
    }
    List<Medication> medicationCorrelated = _correlated![medicationId] ?? <Medication>[];
    _correlated![medicationId] = medicationCorrelated..addAll(correlated);
    _correlated![medicationId]!.toSet().toList(); // remove duplicates
    notifyListeners();
  }

  bool hasMedication(Medication medication){
    return _medicationsList != null && _medicationsList!.contains(medication);
  }

  bool hasCorrelated(String medicationId, Medication medication){
    return _correlated?[medicationId] != null && _correlated![medicationId]!.contains(medication);
  }

  List<Medication>? getCorrelated(String medicationId){
    return _correlated?[medicationId];
  }

  @override
  String toString() {
    return '( '
      'name: $name, '
      'selectedLocation: $selectedLocation, '
      'medicationsList: $medicationsList, '
      'correlated: $_correlated, '
      'languageSelected: $languageSelected, '
      'darkMode: $darkMode '
    ')';
  }
}
