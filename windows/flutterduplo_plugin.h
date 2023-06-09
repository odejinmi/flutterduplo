#ifndef FLUTTER_PLUGIN_FLUTTERDUPLO_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTERDUPLO_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutterduplo {

class FlutterduploPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterduploPlugin();

  virtual ~FlutterduploPlugin();

  // Disallow copy and assign.
  FlutterduploPlugin(const FlutterduploPlugin&) = delete;
  FlutterduploPlugin& operator=(const FlutterduploPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutterduplo

#endif  // FLUTTER_PLUGIN_FLUTTERDUPLO_PLUGIN_H_
