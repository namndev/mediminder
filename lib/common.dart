import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:mediminder/models/medicine.dart';

extension PrettyJson on Map<String, dynamic> {
  String toPrettyString() {
    var encoder = const JsonEncoder.withIndent("     ");
    return encoder.convert(this);
  }
}

extension ConvertString on String {
  String trans() =>
     Intl.message(
      this,
      name: this,
      desc: '',
      args: [],
    );
  // validatos
  bool isValidPassword() {
    return length >= 6;
  }

  bool isValidName() {
    return length >= 5;
  }

  bool isValidPhone() {
    return length == 10;
  }
  
  String convertTime() {
    if (length == 1) {
      return "0" + this;
    } else {
      return this;
    }
  }

  MedicineType toMedicineType() {
    return MedicineType.values.firstWhere((v) => describeEnum(v) == toLowerCase(),
                             orElse: () => MedicineType.none);
  }
  
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

extension ConvertInt on int {
  String timeStr() {
    if (this < 10){
      return "0" + toString();
    }
    return toString();
  }
}

extension MRContext on BuildContext {
  // push PageRoute with Animation
  Future<void> pushRouteAnimation(Widget? child, 
    {Duration transitionDuration = const Duration(milliseconds: 500)}) {
     return Navigator.of(this).push(
            PageRouteBuilder<void>(
              pageBuilder: (ctx, animation, secondaryAnimation) => AnimatedBuilder(
                    animation: animation,
                    builder: (ctx, ch) => Opacity(
                        opacity: animation.value,
                        child: child,
                      )),
              transitionDuration: transitionDuration,
            ),
          );
  }
  // pushMaterialPageRoute
  Future<void> pushMaterialRoute(WidgetBuilder child, {bool maintainState = true}) {
    return Navigator.of(this).push(
      MaterialPageRoute(builder: child, maintainState: maintainState),
    );
  }

  Future<void> pushReplacement(WidgetBuilder child){
    return Navigator.of(this).pushReplacement(
              MaterialPageRoute(
                builder: child,
              ),
            );
  }


  // popUntil with Name
  void popUntilWithName(String name) {
    Navigator.of(this).popUntil(ModalRoute.withName(name));
  }

  // The size of the media in logical pixels (e.g, the size of the screen)
  Size mediaSize() {
    return MediaQuery.of(this).size;
  } 

  Future<DateTime?> showDatePicker(
    {
      DateChangedCallback? onChanged,
      DateChangedCallback? onConfirm}) => 
        DatePicker.showDateTimePicker(this,
          showTitleActions: true,
          minTime: DateTime(2018, 01, 01),
          maxTime: DateTime(2050, 12, 31),
          theme: DatePickerTheme(
              headerColor: const Color(0xFF3EB16F),
              backgroundColor: Theme.of(this).scaffoldBackgroundColor,
              itemStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3EB16F),
                  fontSize: 16),
              doneStyle: const TextStyle(fontSize: 16, color: Colors.white),
              cancelStyle: const TextStyle(fontSize: 16, color: Colors.red)),
          onChanged: onChanged, 
          onConfirm: onConfirm,
          currentTime: DateTime.now(),
          locale: LocaleType.en);

}



