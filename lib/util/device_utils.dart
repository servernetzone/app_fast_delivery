import 'dart:io';

import 'package:device_info/device_info.dart';

Future<bool> isIpad() async{
  if(Platform.isIOS) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    print('Antes do device info');
    IosDeviceInfo info = await deviceInfo.iosInfo;
    print(info.name);
    if (info.name.toLowerCase().contains("ipad")) {
      return true;
    }
    return false;
  }
  return false;
}