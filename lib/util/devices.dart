import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' show Platform;

Future<String?> getDeviceId() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    return androidInfo.id; // Updated field for unique ID on Android
  } else if (Platform.isIOS) {
    final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
    return iosInfo.identifierForVendor; // Unique ID on iOS
  }
  return null;
}
