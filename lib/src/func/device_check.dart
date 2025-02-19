import 'package:device_info_plus/device_info_plus.dart';

class DeviceCheck {
  static Future<bool> isMobile() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

    if (iosInfo.model.toLowerCase().contains('ipad')) return false;

    return true;
  }
}
