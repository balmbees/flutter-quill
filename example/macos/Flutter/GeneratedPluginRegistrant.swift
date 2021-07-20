//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import package_info
import path_provider_macos
import sqflite
import sqflite_sqlcipher
import url_launcher_macos
import wakelock_macos

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  FLTPackageInfoPlugin.register(with: registry.registrar(forPlugin: "FLTPackageInfoPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
  SqfliteSqlCipherPlugin.register(with: registry.registrar(forPlugin: "SqfliteSqlCipherPlugin"))
  UrlLauncherPlugin.register(with: registry.registrar(forPlugin: "UrlLauncherPlugin"))
  WakelockMacosPlugin.register(with: registry.registrar(forPlugin: "WakelockMacosPlugin"))
}
