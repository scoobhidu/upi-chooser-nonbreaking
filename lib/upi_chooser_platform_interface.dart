import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'upi_chooser_method_channel.dart';

abstract class UpiChooserPlatform extends PlatformInterface {
  /// Constructs a UpiChooserPlatform.
  UpiChooserPlatform() : super(token: _token);

  static final Object _token = Object();

  static UpiChooserPlatform _instance = MethodChannelUpiChooser();

  /// The default instance of [UpiChooserPlatform] to use.
  ///
  /// Defaults to [MethodChannelUpiChooser].
  static UpiChooserPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [UpiChooserPlatform] when
  /// they register themselves.
  static set instance(UpiChooserPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion(String pkgName) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
