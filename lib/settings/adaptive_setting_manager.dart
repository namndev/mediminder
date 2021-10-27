import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mediminder/settings/adaptive_setting_mode.dart';

abstract class AdaptiveSettingManager {
  /// provides current theme
  ThemeData get theme;

  /// provides the light theme
  ThemeData get lightTheme;

  /// provides the dark theme
  ThemeData get darkTheme;

  /// Returns current theme mode
  AdaptiveSettingMode get mode;

  LocaleType get localeType;

  /// Allows to listen to changes in them mode.
  ValueNotifier<AdaptiveSettingMode> get modeChangeNotifier;

  /// provides brightness of the current theme
  Brightness get brightness;

  /// Sets light theme as current
  /// Uses [AdaptiveThemeMode.light].
  void setLight();

  /// Sets dark theme as current
  /// Uses [AdaptiveThemeMode.dark].
  void setDark();

  /// Sets theme based on the theme of the underlying OS.
  /// Uses [AdaptiveThemeMode.system].
  void setSystem();

  /// Sets language based on the languages of supported by OS.
  /// Uses [localeType].
  void setLocaleType(LocaleType localeType);

  /// Allows to set/change theme mode.
  void setSettingMode(AdaptiveSettingMode mode);

  /// Allows to set/change the entire theme.
  /// [notify] when set to true, will update the UI to use the new theme..
  void setSetting({
    required ThemeData light,
    ThemeData? dark,
    LocaleType? localeType,
    bool notify = true,
  });

  /// Allows to toggle between theme modes [AdaptiveThemeMode.light],
  /// [AdaptiveThemeMode.dark] and [AdaptiveThemeMode.system].
  void toggleThemeMode();

  /// Saves the configuration to the shared-preferences. This can be useful
  /// when you want to persist theme settings after clearing
  /// shared-preferences. e.g. when user logs out, usually, preferences
  /// are cleared. Call this method after clearing preferences to
  /// persist theme mode.
  Future<bool> persist();

  /// Resets configuration to default configuration which has been provided
  /// while initializing [MaterialApp].
  /// If [setTheme] method has been called with [isDefault] to true, Calling
  /// this method afterwards will use theme provided by [setTheme] as default
  /// themes.
  Future<bool> reset();
}
