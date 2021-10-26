// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Mediminder`
  String get app_name {
    return Intl.message(
      'Mediminder',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `Number of Mediminders`
  String get num_of_mediminders {
    return Intl.message(
      'Number of Mediminders',
      name: 'num_of_mediminders',
      desc: '',
      args: [],
    );
  }

  /// `Press + to add a Mediminder`
  String get press_add_mediminer {
    return Intl.message(
      'Press + to add a Mediminder',
      name: 'press_add_mediminer',
      desc: '',
      args: [],
    );
  }

  /// `Add New Mediminder`
  String get add_mediminder {
    return Intl.message(
      'Add New Mediminder',
      name: 'add_mediminder',
      desc: '',
      args: [],
    );
  }

  /// `Delete this Mediminder?`
  String get delete_this_mediminder {
    return Intl.message(
      'Delete this Mediminder?',
      name: 'delete_this_mediminder',
      desc: '',
      args: [],
    );
  }

  /// `Delete Mediminder`
  String get delete_mediminder {
    return Intl.message(
      'Delete Mediminder',
      name: 'delete_mediminder',
      desc: '',
      args: [],
    );
  }

  /// `Mediminder Details`
  String get mediminder_detail {
    return Intl.message(
      'Mediminder Details',
      name: 'mediminder_detail',
      desc: '',
      args: [],
    );
  }

  /// `Medicine Type`
  String get medicine_type {
    return Intl.message(
      'Medicine Type',
      name: 'medicine_type',
      desc: '',
      args: [],
    );
  }

  /// `Bottle`
  String get bottle {
    return Intl.message(
      'Bottle',
      name: 'bottle',
      desc: '',
      args: [],
    );
  }

  /// `Pill`
  String get pill {
    return Intl.message(
      'Pill',
      name: 'pill',
      desc: '',
      args: [],
    );
  }

  /// `Syringe`
  String get syringe {
    return Intl.message(
      'Syringe',
      name: 'syringe',
      desc: '',
      args: [],
    );
  }

  /// `Tablet`
  String get tablet {
    return Intl.message(
      'Tablet',
      name: 'tablet',
      desc: '',
      args: [],
    );
  }

  /// `Medicine Name`
  String get medicine_name {
    return Intl.message(
      'Medicine Name',
      name: 'medicine_name',
      desc: '',
      args: [],
    );
  }

  /// `Dosage`
  String get dosage {
    return Intl.message(
      'Dosage',
      name: 'dosage',
      desc: '',
      args: [],
    );
  }

  /// `Dosage in mg`
  String get dosage_mg {
    return Intl.message(
      'Dosage in mg',
      name: 'dosage_mg',
      desc: '',
      args: [],
    );
  }

  /// `Not Specified`
  String get not_specified {
    return Intl.message(
      'Not Specified',
      name: 'not_specified',
      desc: '',
      args: [],
    );
  }

  /// `Dose Interval`
  String get dose_interval {
    return Intl.message(
      'Dose Interval',
      name: 'dose_interval',
      desc: '',
      args: [],
    );
  }

  /// `Remind me every  `
  String get remind_me_every {
    return Intl.message(
      'Remind me every  ',
      name: 'remind_me_every',
      desc: '',
      args: [],
    );
  }

  /// `Select an interval`
  String get select_interval {
    return Intl.message(
      'Select an interval',
      name: 'select_interval',
      desc: '',
      args: [],
    );
  }

  /// `Every %d hours | %d times a day`
  String get dose_interval_fmt {
    return Intl.message(
      'Every %d hours | %d times a day',
      name: 'dose_interval_fmt',
      desc: '',
      args: [],
    );
  }

  /// `Start Time`
  String get start_time {
    return Intl.message(
      'Start Time',
      name: 'start_time',
      desc: '',
      args: [],
    );
  }

  /// `Pick Time`
  String get pick_time {
    return Intl.message(
      'Pick Time',
      name: 'pick_time',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the medicine is name`
  String get medicine_name_null {
    return Intl.message(
      'Please enter the medicine is name',
      name: 'medicine_name_null',
      desc: '',
      args: [],
    );
  }

  /// `Medicine name already exists`
  String get medicine_name_exist {
    return Intl.message(
      'Medicine name already exists',
      name: 'medicine_name_exist',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the dosage required`
  String get dosage_error {
    return Intl.message(
      'Please enter the dosage required',
      name: 'dosage_error',
      desc: '',
      args: [],
    );
  }

  /// `Please select the reminder is starting time`
  String get start_time_error {
    return Intl.message(
      'Please select the reminder is starting time',
      name: 'start_time_error',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
