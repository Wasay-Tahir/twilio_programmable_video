import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class PlatformService {
  static String? generatedDeviceId;

  static Future<String> get deviceId async {
    final deviceInfo = DeviceInfoPlugin();
    // Always have a fallback UUID
    generatedDeviceId ??= const Uuid().v1();

    if (kIsWeb) {
      return generatedDeviceId!;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? generatedDeviceId!;
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      // device_info_plus may expose id as nullable
      return androidInfo.id ?? generatedDeviceId!;
    }

    return generatedDeviceId!;
  }
}
