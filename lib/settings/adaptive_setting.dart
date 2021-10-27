import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mediminder/settings/adaptive_setting_manager.dart';
import 'package:mediminder/settings/adaptive_setting_mode.dart';
import 'package:mediminder/settings/adaptive_setting_preferences.dart';

/// Builder function to build themed widgets
typedef AdaptiveSettingBuilder = Widget Function(
    ThemeData light, ThemeData dark, Locale locale);

class AdaptiveSetting extends StatefulWidget {
  /// Represents the light theme for the app.
  final ThemeData light;

  /// Represents the dark theme for the app.
  final ThemeData dark;

  /// Indicates which [AdaptiveSettingMode] to use initially.
  final AdaptiveSettingMode? initial;

  /// Provides a builder with access of light and dark theme. Intended to
  /// be used to return [MaterialApp].
  final AdaptiveSettingBuilder builder;

  /// Key used to store theme information into shared-preferences. If you want
  /// to persist theme mode changes even after shared-preferences
  /// is cleared (e.g. after log out), do not remove this [prefKey] key from
  /// shared-preferences.
  static const String prefKey = 'adaptive_setting_preferences';

  /// Primary constructor which allows to configure themes initially.
  const AdaptiveSetting({
    Key? key,
    required this.light,
    ThemeData? dark,
    this.initial,
    required this.builder,
  })  : dark = dark ?? light,
        super(key: key);

  @override
  _AdaptiveSettingState createState() => _AdaptiveSettingState();

  /// Returns reference of the [AdaptiveThemeManager] which allows access of
  /// the state object of [AdaptiveTheme] in a restrictive way.
  static AdaptiveSettingManager of(BuildContext context) =>
      context.findAncestorStateOfType<State<AdaptiveSetting>>()!
          as AdaptiveSettingManager;

  /// Returns reference of the [AdaptiveThemeManager] which allows access of
  /// the state object of [AdaptiveTheme] in a restrictive way.
  /// This returns null if the state instance of [AdaptiveTheme] is not found.
  static AdaptiveSettingManager? maybeOf(BuildContext context) {
    final state = context.findAncestorStateOfType<State<AdaptiveSetting>>();
    if (state == null) return null;
    return state as AdaptiveSettingManager;
  }

  /// returns most recent theme mode. This can be used to eagerly get previous
  /// theme mode inside main method before calling [runApp].
  static Future<AdaptiveSettingMode?> getSettingMode() async {
    return (await SettingPreferences.fromPrefs())?.mode;
  }
}

class _AdaptiveSettingState extends State<AdaptiveSetting>
    implements AdaptiveSettingManager {
  late ThemeData _theme;
  late ThemeData _darkTheme;
  late LocaleType _localeType;
  late AdaptiveSettingMode _initial;
  late SettingPreferences _preferences;
  late ValueNotifier<AdaptiveSettingMode> _modeChangeNotifier;

  @override
  void initState() {
    super.initState();
    _theme = widget.light.copyWith();
    _initial = widget.initial ?? AdaptiveSettingMode.defaultMode;
    _modeChangeNotifier = ValueNotifier(_initial);
    _darkTheme = widget.dark.copyWith();
    _localeType = _initial.localeType;
    _preferences = SettingPreferences.initial(mode: _initial);
    SettingPreferences.fromPrefs().then((pref) {
      if (pref == null) {
        _preferences.save();
      } else {
        _preferences = pref;
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  ValueNotifier<AdaptiveSettingMode> get modeChangeNotifier =>
      _modeChangeNotifier;

  @override
  ThemeData get theme {
    if (_preferences.mode.theme.isSystem) {
      final brightness = SchedulerBinding.instance!.window.platformBrightness;
      return brightness == Brightness.light ? _theme : _darkTheme;
    }
    return _preferences.mode.theme.isDark ? _darkTheme : _theme;
  }

  @override
  ThemeData get lightTheme => _theme;

  @override
  ThemeData get darkTheme => _darkTheme;

  @override
  AdaptiveSettingMode get mode => _preferences.mode;

  @override
  LocaleType get localeType => _localeType;

  @override
  Brightness get brightness => theme.brightness;

  @override
  void setLight() =>
      setSettingMode(mode.copyWith(theme: AdaptiveThemeMode.light));

  @override
  void setDark() =>
      setSettingMode(mode.copyWith(theme: AdaptiveThemeMode.dark));

  @override
  void setSystem() =>
      setSettingMode(mode.copyWith(theme: AdaptiveThemeMode.system));

  @override
  void setLocaleType(LocaleType localeType) =>
      setSettingMode(mode.copyWith(localeType: localeType));

  @override
  void setSettingMode(AdaptiveSettingMode mode) {
    _preferences.mode = mode;
    if (mounted) {
      setState(() {});
    }
    _modeChangeNotifier.value = mode;
    _preferences.save();
  }

  @override
  void setSetting({
    required ThemeData light,
    ThemeData? dark,
    LocaleType? localeType,
    bool notify = true,
  }) {
    _theme = light;
    if (dark != null) {
      _darkTheme = dark;
    }
    if (localeType != null) {
      _localeType = localeType;
    }
    if (notify && mounted) {
      setState(() {});
    }
  }

  @override
  void toggleThemeMode() {
    final nextModeIndex =
        (mode.theme.index + 1) % AdaptiveThemeMode.values.length;
    final nextMode = AdaptiveThemeMode.values[nextModeIndex];
    setSettingMode(mode.copyWith(theme: nextMode));
  }

  @override
  Future<bool> persist() async => _preferences.save();

  @override
  Future<bool> reset() async {
    _preferences.reset();
    _theme = widget.light.copyWith();
    _darkTheme = widget.dark.copyWith();
    if (mounted) {
      setState(() {});
    }
    modeChangeNotifier.value = mode;
    return _preferences.save();
  }

  @override
  Widget build(BuildContext context) => widget.builder(
      theme,
      _preferences.mode.theme.isLight ? _theme : _darkTheme,
      Locale.fromSubtags(languageCode: describeEnum(_preferences.mode.locale)));

  @override
  void dispose() {
    _modeChangeNotifier.dispose();
    super.dispose();
  }
}
