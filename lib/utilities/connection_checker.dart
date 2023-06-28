import 'dart:io';

import 'package:flutter/foundation.dart';

class ConnectionChecker {
  static Future<bool> checkConnection() async {
    try {
      if (kIsWeb) {
        return true;
      } else {
        final result = await InternetAddress.lookup('datawizard.it');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        }
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}
