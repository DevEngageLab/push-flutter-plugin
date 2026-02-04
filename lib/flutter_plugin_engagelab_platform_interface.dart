import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_plugin_engagelab_method_channel.dart';

abstract class FlutterPluginEngagelabPlatform extends PlatformInterface {
  /// Constructs a FlutterPluginEngagelabPlatform.
  FlutterPluginEngagelabPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterPluginEngagelabPlatform _instance = MethodChannelFlutterPluginEngagelab();

  /// The default instance of [FlutterPluginEngagelabPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterPluginEngagelab].
  static FlutterPluginEngagelabPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterPluginEngagelabPlatform] when
  /// they register themselves.
  static set instance(FlutterPluginEngagelabPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
