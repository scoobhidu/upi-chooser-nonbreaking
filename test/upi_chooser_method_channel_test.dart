import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upi_chooser/upi_chooser_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelUpiChooser platform = MethodChannelUpiChooser();
  const MethodChannel channel = MethodChannel('upi_chooser');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(
        await platform.getPlatformVersion({
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
