import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' show Platform;

class DeviceInfoUtil {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  // Mendapatkan nama device
  static Future<String> getDeviceName() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return androidInfo.model;
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      return iosInfo.name;
    }
    return 'Unknown Device';
  }

  // Mendapatkan versi OS
  static Future<String> getOSVersion() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return androidInfo.version.release;
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      return iosInfo.systemVersion;
    }
    return 'Unknown OS';
  }

  // Mendapatkan informasi lengkap device
  static Future<Map<String, dynamic>> getDeviceFullInfo() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return {
        'model': androidInfo.model,
        'brand': androidInfo.brand,
        'androidVersion': androidInfo.version.release,
        'sdkInt': androidInfo.version.sdkInt,
        'manufacturer': androidInfo.manufacturer,
        'isPhysicalDevice': androidInfo.isPhysicalDevice,
      };
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      return {
        'name': iosInfo.name,
        'systemName': iosInfo.systemName,
        'systemVersion': iosInfo.systemVersion,
        'model': iosInfo.model,
        'localizedModel': iosInfo.localizedModel,
        'isPhysicalDevice': iosInfo.isPhysicalDevice,
      };
    }
    return {'error': 'Unsupported platform'};
  }
}