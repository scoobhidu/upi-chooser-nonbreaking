import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'upi_chooser_platform_interface.dart';

/// An implementation of [UpiChooserPlatform] that uses method channels.
class MethodChannelUpiChooser extends UpiChooserPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('upi_chooser');

  @override
  Future<String?> getPlatformVersion(String pkgName) async {
    final version =
        await methodChannel.invokeMethod<String>('getUpiApps', pkgName);
    return version;
  }
}
