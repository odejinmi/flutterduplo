import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutterduplo_method_channel.dart';

abstract class FlutterduploPlatform extends PlatformInterface {
  /// Constructs a FlutterduploPlatform.
  FlutterduploPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterduploPlatform _instance = MethodChannelFlutterduplo();

  /// The default instance of [FlutterduploPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterduplo].
  static FlutterduploPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterduploPlatform] when
  /// they register themselves.
  static set instance(FlutterduploPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
