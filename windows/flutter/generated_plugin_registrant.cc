//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <firebase_auth/firebase_auth_plugin_c_api.h>
#include <firebase_core/firebase_core_plugin_c_api.h>
#include <flutter_unity_widget/flutter_unity_widget_plugin.h>
#include <geolocator_windows/geolocator_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FirebaseAuthPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FirebaseAuthPluginCApi"));
  FirebaseCorePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FirebaseCorePluginCApi"));
  FlutterUnityWidgetPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterUnityWidgetPlugin"));
  GeolocatorWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("GeolocatorWindows"));
}
