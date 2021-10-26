import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mediminder/global_bloc.dart';
import 'package:mediminder/models/medicine.dart';
import 'package:mediminder/ui/home_page.dart';
import 'package:mediminder/common.dart';
import 'package:mediminder/ui/success_screen.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;

import 'new_entry_bloc.dart';

export 'new_entry_bloc.dart';


class NewEntry extends StatefulWidget {
  const NewEntry({ Key? key }) : super(key: key);

  @override
  _NewEntryState createState() => _NewEntryState();
}

class _NewEntryState extends State<NewEntry> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final NewEntryBloc _newEntryBloc = NewEntryBloc();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    dosageController.dispose();
    _newEntryBloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    initializeErrorListen();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);

    return Scaffold(
      key: _scaffoldKey,
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: const IconThemeData(
          color: Color(0xFF3EB16F),
        ),
        centerTitle: true,
        title: Text(
          "add_mediminder".trans(),
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        elevation: 0.0,
      ),
      body: Provider<NewEntryBloc>.value(
          value: _newEntryBloc,
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            children: <Widget>[
              PanelTitle(
                title: "medicine_name".trans(),
                isRequired: true,
              ),
              TextFormField(
                maxLength: 12,
                style: const TextStyle(
                  fontSize: 16,
                ),
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                ),
              ),
              PanelTitle(
                title: "dosage_mg".trans(),
                isRequired: false,
              ),
              TextFormField(
                controller: dosageController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 12,
              ),

              PanelTitle(
                title: "medicine_type".trans(),
                isRequired: false,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: StreamBuilder<MedicineType>(
                  stream: _newEntryBloc.selectedMedicineType,
                  builder: (context, snapshot) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          MedicineTypeColumn(
                              type: MedicineType.bottle,
                              isSelected: snapshot.data == MedicineType.bottle),
                          MedicineTypeColumn(
                              type: MedicineType.pill,
                              isSelected: snapshot.data == MedicineType.pill),
                          MedicineTypeColumn(
                              type: MedicineType.syringe,
                              isSelected: snapshot.data == MedicineType.syringe),
                          MedicineTypeColumn(
                              type: MedicineType.tablet,
                              isSelected: snapshot.data == MedicineType.tablet),
                        ],
                      ));
                  },
                ),
              ),
              const PanelTitle(
                title: "Interval Selection",
                isRequired: true,
              ),
              //ScheduleCheckBoxes(),
              const IntervalSelection(),
              const PanelTitle(
                title: "Starting Time",
                isRequired: true,
              ),
              const SelectTime(),
              const SizedBox(
                height: 32,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height * 0.08,
                  right: MediaQuery.of(context).size.height * 0.08,
                ),
                child: SizedBox(
                  width: 220,
                  height: 64,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF3EB16F),
                      shape: const StadiumBorder(),
                    ),
                    child: Center(
                      child: Text(
                        "confirm".trans(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    onPressed: () {
                      String medicineName = '';
                      int dosage = 0;
                      //--------------------Error Checking------------------------
                      //Had to do error checking in UI
                      //Due to unoptimized BLoC value-grabbing architecture
                      if (nameController.text.isEmpty) {
                        _newEntryBloc.submitError(EntryError.nameNull);
                        return;
                      }
                      if (nameController.text.isNotEmpty) {
                        medicineName = nameController.text;
                      }
                      if (dosageController.text.isEmpty) {
                        dosage = 0;
                      }
                      if (dosageController.text.isNotEmpty) {
                        dosage = int.parse(dosageController.text);
                      }
                      for (var medicine in _globalBloc.medicineList$.value) {
                        if (medicineName == medicine.medicineName) {
                          _newEntryBloc.submitError(EntryError.nameDuplicate);
                          return;
                        }
                      }
                      if (_newEntryBloc.selectedTimeOfDay$.value == "none") {
                        _newEntryBloc.submitError(EntryError.startTime);
                        return;
                      }
                      //---------------------------------------------------------
                      MedicineType medicineType = _newEntryBloc
                          .selectedMedicineType.value;

                      int interval = _newEntryBloc.selectedInterval$.value;
                      String startTime = _newEntryBloc.selectedTimeOfDay$.value;

                      List<int> intIDs =
                          makeIDs( interval == 0 ? 1 : 24 / interval);
                      List<String> notificationIDs = intIDs
                          .map((i) => i.toString())
                          .toList(); //for Shared preference
                      Medicine newEntryMedicine = Medicine(
                        notificationIDs: notificationIDs,
                        medicineName: medicineName,
                        dosage: dosage,
                        medicineType: medicineType,
                        interval: interval,
                        startTime: startTime,
                      );

                      _globalBloc.updateMedicineList(newEntryMedicine);
                      scheduleNotification(newEntryMedicine);
                      context.pushReplacement((context) => const SuccessScreen());
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }

  void initializeErrorListen() {
    _newEntryBloc.errorState$.listen(
      (EntryError error) {
        switch (error) {
          case EntryError.nameNull:
            displayError("medicine_name_null".trans());
            break;
          case EntryError.nameDuplicate:
            displayError("medicine_name_exist".trans());
            break;
          case EntryError.dosage:
            displayError("dosage_error".trans());
            break;
          case EntryError.startTime:
            displayError("start_time_error".trans());
            break;
          default:
        }
      },
    );
  }

  void displayError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(error),
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }

  List<int> makeIDs(double n) {
    var rng = Random();
    List<int> ids = [];
    for (int i = 0; i < n; i++) {
      ids.add(rng.nextInt(1000000000));
    }
    return ids;
  }

  initializeNotifications() async {
    var initializationSettings = const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/launcher_icon'), iOS: IOSInitializationSettings());
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> onSelectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  Future<void> scheduleNotification(Medicine medicine) async {
    var hour = int.parse(medicine.startTime[0] + medicine.startTime[1]);
    var ogValue = hour;
    var minute = int.parse(medicine.startTime[2] + medicine.startTime[3]);

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'repeatDailyAtTime channel id',
      'repeatDailyAtTime channel name',
      channelDescription: 'repeatDailyAtTime description',
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('sound'),
      ledColor: Color(0xFF3EB16F),
      ledOffMs: 1000,
      ledOnMs: 1000,
      enableLights: true,
    );
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    int n = medicine.interval == 0 ? 1 : (24 / medicine.interval).floor();
    for (int i = 0; i < n; i++) {
      if ((hour + (medicine.interval * i) > 23)) {
        hour = hour + (medicine.interval * i) - 24;
      } else {
        hour = hour + (medicine.interval * i);
      }
      await flutterLocalNotificationsPlugin.zonedSchedule(
          int.parse(medicine.notificationIDs[i]),
          'Mediminder: ${medicine.medicineName}',
          medicine.medicineType.toString() != MedicineType.none.toString()
              ? 'It is time to take your ${describeEnum(medicine.medicineType).toLowerCase()}, according to schedule'
              : 'It is time to take your medicine, according to schedule',
          tz.TZDateTime.now(tz.local).add(Duration(hours: hour, minutes: minute, seconds: 0)),
          platformChannelSpecifics,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
          );
      hour = ogValue;
    }
    //await flutterLocalNotificationsPlugin.cancelAll();
  }
}

class IntervalSelection extends StatefulWidget {
  
  const IntervalSelection({Key? key}) : super(key: key);

  @override
  _IntervalSelectionState createState() => _IntervalSelectionState();
}

class _IntervalSelectionState extends State<IntervalSelection> {
  final _intervals = [
    0,
    6,
    8,
    12,
    24,
  ];
  var _selected = 0;

  @override
  Widget build(BuildContext context) {
    final NewEntryBloc _newEntryBloc = Provider.of<NewEntryBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'remind_me_every'.trans(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            DropdownButton<int>(
              iconEnabledColor: const Color(0xFF3EB16F),
              hint: _selected == 0
                  ? Text(
                      'select_interval'.trans(),
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400),
                    )
                  : null,
              elevation: 4,
              value: _selected == 0 ? null : _selected,
              items: _intervals.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  _selected = newVal ?? 0;
                  _newEntryBloc.updateInterval(_selected);
                });
              },
            ),
            Text(
              _selected == 1 ? " hour" : " hours",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
    );
  }
}

class SelectTime extends StatefulWidget {
  const SelectTime({Key? key}) : super(key: key);

  @override
  _SelectTimeState createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  DateTime _time = DateTime.now();
  TimeOfDay _timeOfDay = const TimeOfDay(hour: 00, minute: 00);
  bool _clicked = false;

  Future<void> _selectTime(BuildContext context) async {
    final NewEntryBloc _newEntryBloc = Provider.of<NewEntryBloc>(context, listen: false);
    if (_newEntryBloc.selectedInterval$.value == 0){
      context.showDatePicker(
        onConfirm: (picked) {
          setState(() {
            _time = picked;
            _timeOfDay = TimeOfDay(hour: _time.hour, minute: _time.minute);
            _clicked = true;
            _newEntryBloc.updateTime(_time.hour.timeStr() + _time.minute.timeStr(), 
                date: _time.year.toString() + _time.month.timeStr() + _time.day.timeStr());
          });
        }
      );
    } else {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: _time.hour, minute: _time.minute),
      );
      if (picked != null && picked != _timeOfDay) {
        setState(() {
          _timeOfDay = picked;
          _clicked = true;
          _newEntryBloc.updateTime(_timeOfDay.hour.timeStr() +
              _timeOfDay.minute.timeStr());
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFF3EB16F),
            shape: const StadiumBorder(),
          ),
          onPressed: () {
            _selectTime(context);
          },
          child: Center(
            child: Text(
              _clicked == false
                  ? "pick_time".trans()
                  : "${_time.hour.timeStr()}:${_time.minute.timeStr()}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MedicineTypeColumn extends StatelessWidget {
  final MedicineType type;
  final bool isSelected;

  const MedicineTypeColumn(
      {Key? key,
      required this.type,
      required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NewEntryBloc _newEntryBloc = Provider.of<NewEntryBloc>(context);
    return GestureDetector(
      onTap: () {
        _newEntryBloc.updateSelectedMedicine(type);
      },
      child: Column(
        children: <Widget>[
          Container(
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isSelected ? const Color(0xFF3EB16F) : Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Icon(
                  type.iconData(),
                  size: 72,
                  color: isSelected ? Theme.of(context).scaffoldBackgroundColor : const Color(0xFF3EB16F),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              width: 72,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF3EB16F) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  type.asString().trans(),
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected ? Colors.white : const Color(0xFF3EB16F),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PanelTitle extends StatelessWidget {
  final String title;
  final bool isRequired;

  const PanelTitle({
    Key? key,
    required this.title,
    required this.isRequired,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Text.rich(
        TextSpan(children: <TextSpan>[
          TextSpan(
            text: title,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500),
          ),
          TextSpan(
            text: isRequired ? " (*)" : "",
            style: const TextStyle(fontSize: 14, color: Colors.red),
          ),
        ]),
      ),
    );
  }
}
