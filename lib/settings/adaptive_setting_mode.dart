import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

/// Represents the mode of the theme.
enum AdaptiveThemeMode { light, dark, system }

class AdaptiveSettingMode {
  final AdaptiveThemeMode theme;
  final LocaleType localeType;
  const AdaptiveSettingMode(this.theme, this.localeType);

  // Define that two AdaptiveSettingMode are equal if their theme and locale are equal
  @override
  bool operator ==(other) {
    return (other is AdaptiveSettingMode) &&
        (other.theme == theme) &&
        (other.localeType == localeType);
  }

  @override
  int get hashCode => theme.hashCode + localeType.hashCode;

  Locale get locale =>
      Locale.fromSubtags(languageCode: describeEnum(localeType));

  static const AdaptiveSettingMode defaultMode =
      AdaptiveSettingMode(AdaptiveThemeMode.system, LocaleType.en);

  Map<String, dynamic> toJson() {
    return {
      "theme": describeEnum(theme),
      "locale_type": describeEnum(localeType)
    };
  }

  factory AdaptiveSettingMode.fromJson(Map<String, dynamic> parsedJson) {
    return AdaptiveSettingMode(
        AdaptiveThemeMode.values.firstWhere(
            (v) => describeEnum(v) == parsedJson['theme'],
            orElse: () => AdaptiveThemeMode.system),
        LocaleType.values.firstWhere(
            (v) => describeEnum(v) == parsedJson['locale_type'],
            orElse: () => LocaleType.en));
  }

  AdaptiveSettingMode copyWith(
      {AdaptiveThemeMode? theme, LocaleType? localeType}) {
    return AdaptiveSettingMode(
        theme ?? this.theme, localeType ?? this.localeType);
  }
}

/// Provides accessibility methods for theme modes.
extension AdaptiveThemeModeExt on AdaptiveThemeMode {
  bool get isLight => this == AdaptiveThemeMode.light;

  bool get isDark => this == AdaptiveThemeMode.dark;

  bool get isSystem => this == AdaptiveThemeMode.system;

  /// String representation of [AdaptiveThemeMode]
  String get name => describeEnum(this);
}
