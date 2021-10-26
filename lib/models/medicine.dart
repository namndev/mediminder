
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mediminder/common.dart';

enum MedicineType {
  bottle,
  pill,
  syringe,
  tablet,
  none,
}
extension MedicineTypeExt on MedicineType {
  String asString() => describeEnum(this);

  IconData iconData() {
    switch (this) {
      case MedicineType.bottle:
        return const IconData(0xe900, fontFamily: "Ic");
      case MedicineType.pill:
        return const IconData(0xe901, fontFamily: "Ic");
      case MedicineType.syringe:
        return const IconData(0xe902, fontFamily: "Ic");
      case MedicineType.tablet:
        return const IconData(0xe903, fontFamily: "Ic");
      default:
        return Icons.local_hospital;
    }
  }
}

enum EntryError {
  nameDuplicate,
  nameNull,
  dosage,
  type,
  startTime,
  none,
}

enum Period {
  week,
  month,
  year,
}

enum Day {
  sunday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
}


class Medicine {
  final List<dynamic> notificationIDs;
  final String medicineName;
  final int dosage;
  final MedicineType medicineType;
  final int interval;
  final String startTime;

  Medicine({
    required this.notificationIDs,
    required this.medicineName,
    this.dosage = 0,
    this.medicineType = MedicineType.none,
    this.startTime = '',
    this.interval = 0,
  });

  String get getName => medicineName;
  int get getDosage => dosage;
  String get getType => describeEnum(medicineType);
  int get getInterval => interval;
  String get getStartTime => startTime;
  List<dynamic>? get getIDs => notificationIDs;
  String get getTag => medicineName + medicineType.toString();
  String get getTimeFMT => startTime.length == 4 ? startTime[0] + startTime[1] + ":" + startTime[2] + startTime[3] : startTime;
  IconData get getIconData => medicineType.iconData();

  Map<String, dynamic> toJson() {
    return {
      "ids": notificationIDs,
      "name": medicineName,
      "dosage": dosage,
      "type": describeEnum(medicineType),
      "interval": interval,
      "start": startTime,
    };
  }

  factory Medicine.fromJson(Map<String, dynamic> parsedJson) {
    return Medicine(
      notificationIDs: parsedJson['ids'],
      medicineName: parsedJson['name'],
      dosage: parsedJson['dosage'],
      medicineType: (parsedJson['type'] as String).toMedicineType(),
      interval: parsedJson['interval'],
      startTime: parsedJson['start'],
    );
  }

  
}
