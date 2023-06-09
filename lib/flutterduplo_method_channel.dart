import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutterduplo_platform_interface.dart';

/// An implementation of [FlutterduploPlatform] that uses method channels.
class MethodChannelFlutterduplo extends FlutterduploPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutterduplo');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
