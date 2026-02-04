import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_plugin_engagelab_platform_interface.dart';

/// An implementation of [FlutterPluginEngagelabPlatform] that uses method channels.
class MethodChannelFlutterPluginEngagelab extends FlutterPluginEngagelabPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_plugin_engagelab');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
