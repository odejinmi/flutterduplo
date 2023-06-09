#include "include/flutterduplo/flutterduplo_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutterduplo_plugin.h"

void FlutterduploPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutterduplo::FlutterduploPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
