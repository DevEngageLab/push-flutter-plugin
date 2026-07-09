import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_plugin_engagelab/flutter_plugin_engagelab.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_plugin_engagelab');

  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async => '42',
    );
  });

  tearDown(() {
    binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterPluginEngagelab.getPlatformVersion(), '42');
  });
}
