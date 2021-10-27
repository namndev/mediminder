import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mediminder/settings/adaptive_setting.dart';
import 'package:mediminder/settings/adaptive_setting_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Utility for storing theme info in SharedPreferences
class SettingPreferences {
  late AdaptiveSettingMode mode;
  late AdaptiveSettingMode defaultMode;

  SettingPreferences.initial({this.mode = AdaptiveSettingMode.defaultMode})
      : defaultMode = mode;

  void reset() => mode = defaultMode;

  SettingPreferences.fromJson(Map<String, dynamic> json) {
    if (json['setting_mode'] != null) {
      mode = AdaptiveSettingMode.fromJson(json['setting_mode']);
    }
    if (json['default_setting_mode'] != null) {
      defaultMode = AdaptiveSettingMode.fromJson(json['default_theme_mode']);
    } else {
      defaultMode = mode;
    }
  }

  Map<String, dynamic> toJson() => {
        'setting_mode': mode.toJson(),
        'default_setting_mode': defaultMode.toJson(),
      };

  /// saves the current theme preferences to the shared-preferences
  Future<bool> save() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(AdaptiveSetting.prefKey, json.encode(toJson()));
  }

  /// retrieves preferences from the shared-preferences
  static Future<SettingPreferences?> fromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeDataString = prefs.getString(AdaptiveSetting.prefKey);
      if (themeDataString == null || themeDataString.isEmpty) return null;
      return SettingPreferences.fromJson(json.decode(themeDataString));
    } on Exception catch (error, stacktrace) {
      if (!kReleaseMode) {
        // ignore: avoid_print
        print(error);
        // ignore: avoid_print
        print(stacktrace);
      }
      return null;
    }
  }
}
