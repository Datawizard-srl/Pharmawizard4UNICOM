import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';
import 'package:unicom_patient/entities/test_entities/medication.dart';
import 'package:unicom_patient/entities/test_entities/user_info.dart';

class UserInfoRepository {
  static late UserInfo _userInfo;
  static final LocalStorage _storage = LocalStorage('user_info.json');

  static UserInfo get userInfo { return _userInfo; }
  static LocalStorage get storage { return _storage; }

  static Future<void> fetch() async {
    try {
      final response = await _storage.ready.then((value) => _storage.getItem('userinfo'));
      if (response == null) {
        _userInfo = UserInfo();
        save();
      } else {
        _userInfo = UserInfo.fromMap(response);
      }


      // final response = await _storage.ready.then((value) => _storage.getItem('name'));
      // if (response == null) {
      //   return;
      // }
      // _userInfo = UserInfo.fromMap({
      //   'name': _storage.getItem('name'),
      //   'selectedLocation': _storage.getItem('selectedLocation'),
      //   'medicationsList': _storage.getItem('medicationsList'),
      //   'languageSelected': _storage.getItem('languageSelected'),
      //   '_darkMode': _storage.getItem('_darkMode'),
      // });
    } catch (error) {
      debugPrint(error.toString());
      throw Exception('Failed to fetch user info');
    }
  }

  static Future<void> save() async {
    await saveUserInfo(userInfo);
  }

  static Future<void> saveUserInfo(UserInfo userInfo) async {
    _storage.setItem("userinfo", userInfo.toMap());
  }

  static Future<void> deleteUserInfo() async {
    try {
      _userInfo = UserInfo();
      await _storage.clear();
    } catch (error) {
      debugPrint(error.toString());
      throw Exception('Failed to delete user info');
    }
  }

  static Future<void> addMedications(List<Medication> medications) async {
    try {
      _userInfo.addMedications(medications);
      save();
    } catch (error) {
      debugPrint(error.toString());
      throw Exception('Failed to add medication');
    }
  }

  static Future<void> addCorrelated(String medicationId, List<Medication> medications) async {
    try {
      _userInfo.addCorrelated(medicationId, medications);
      save();
    } catch (error) {
      debugPrint(error.toString());
      throw Exception('Failed to add medication');
    }
  }

  static Future<void> deleteCorrelated(String medicationId, List<Medication> medications) async {
    try {
      _userInfo.removeCorrelated(medicationId, medications);
      save();
    } catch (error) {
      debugPrint(error.toString());
      throw Exception('Failed to add medication');
    }
  }

  static Future<void> deleteMedication(Medication medication) async {
    try {
      _userInfo.removeMedications([medication]);
      save();
    } catch (error) {
      debugPrint(error.toString());
      throw Exception('Failed to delete medication');
    }
  }
}
