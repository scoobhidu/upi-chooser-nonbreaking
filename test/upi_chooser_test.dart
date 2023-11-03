import 'package:flutter_test/flutter_test.dart';
import 'package:upi_chooser/upi_chooser.dart';
import 'package:upi_chooser/upi_chooser_platform_interface.dart';
import 'package:upi_chooser/upi_chooser_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockUpiChooserPlatform
    with MockPlatformInterfaceMixin
    implements UpiChooserPlatform {
  @override
  Future<String?> getPlatformVersion(Map<String, dynamic> args) =>
      Future.value('42');
}

void main() {
  final UpiChooserPlatform initialPlatform = UpiChooserPlatform.instance;

  test('$MethodChannelUpiChooser is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelUpiChooser>());
  });

  test('getPlatformVersion', () async {
    UpiChooser upiChooserPlugin = UpiChooser();
    MockUpiChooserPlatform fakePlatform = MockUpiChooserPlatform();
    UpiChooserPlatform.instance = fakePlatform;

    expect(
        await upiChooserPlugin.getPlatformVersion({
          'pkg': '',
          'payeeAddress': '',
          'payeeName': '',
          'payeeMCC': '',
          'txnID': '',
          'txnRefId': '',
          'txnNote': '',
          'payeeAmount': '',
          'currencyCode': '',
          'refUrl': '',
          'mode': '',
          'orgid': '',
          'mid': '',
        }),
        '42');
  });
}
