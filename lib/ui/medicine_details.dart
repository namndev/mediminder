import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mediminder/models/medicine.dart';
import 'package:provider/provider.dart';
import 'package:mediminder/common.dart';
import 'package:mediminder/global_bloc.dart';
import 'package:sprintf/sprintf.dart';

class MedicineDetails extends StatelessWidget {
  final Medicine medicine;

  const MedicineDetails(this.medicine, {Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Color(0xFF3EB16F),
        ),
        centerTitle: true,
        title: Text(
          "mediminder_detail".trans(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        elevation: 0.0,
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              MainSection(medicine: medicine),
              const SizedBox(
                height: 16,
              ),
              ExtendedSection(medicine: medicine)
            ],
          ),
        ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          openAlertBox(context, _globalBloc);
        },
        label: Text("delete_mediminder".trans()),
        icon: const Icon(Icons.delete),
        backgroundColor: Colors.red[600],
      ),
    );
  }

  Future<void> openAlertBox(BuildContext context, GlobalBloc _globalBloc) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(24.0),
              ),
            ),
            contentPadding: const EdgeInsets.only(top: 8.0),
            content: SizedBox(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        "delete_this_mediminder".trans(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          _globalBloc.removeMedicine(medicine);
                          context.popUntilWithName('/');
                        },
                        child: InkWell(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.6,
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            decoration: const BoxDecoration(
                              color: Color(0xFF3EB16F),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(24.0),
                              ),
                            ),
                            child: Text(
                              "yes".trans(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: InkWell(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.6,
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            decoration: BoxDecoration(
                              color: Colors.red[600],
                              borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(24.0)),
                            ),
                            child: Text(
                              "no".trans(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
// _globalBloc.removeMedicine(medicine);
//                       Navigator.of(context).pop()

class MainSection extends StatelessWidget {
  final Medicine medicine;

  const MainSection({
    Key? key,
    required this.medicine,
  }) : super(key: key);

  Hero makeIcon(double size) => Hero(tag: medicine.getTag, child: Icon(
          medicine.getIconData,
          color: const Color(0xFF3EB16F),
          size: size,
        ));

  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
          makeIcon(160),
          const SizedBox(width: 16),
          Column(
            children: <Widget>[
              Hero(
                tag: medicine.medicineName,
                child: Material(
                  color: Colors.transparent,
                  child: MainInfoTab(
                    fieldTitle: "medicine_name".trans(),
                    fieldInfo: medicine.medicineName,
                  ),
                ),
              ),
              MainInfoTab(
                fieldTitle: "dosage".trans(),
                fieldInfo: medicine.dosage == 0
                    ? "not_specified".trans()
                    : medicine.dosage.toString() + " mg",
              )
            ],
          )
        ],
      );
  }
}

class MainInfoTab extends StatelessWidget {
  final String fieldTitle;
  final String fieldInfo;

  const MainInfoTab({Key? key, required this.fieldTitle, required this.fieldInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.35,
      height: 100,
      child: ListView(
        padding: const EdgeInsets.only(top: 15),
        shrinkWrap: true,
        children: <Widget>[
          Text(
            fieldTitle,
            style: const TextStyle(
                fontSize: 17,
                color: Color(0xFFC9C9C9),
                fontWeight: FontWeight.bold),
          ),
          Text(
            fieldInfo,
            style: const TextStyle(
                fontSize: 24,
                color: Color(0xFF3EB16F),
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ExtendedSection extends StatelessWidget {
  final Medicine medicine;

  const ExtendedSection({Key? key, required this.medicine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        children: <Widget>[
          ExtendedInfoTab(
            fieldTitle: "medicine_type".trans(),
            fieldInfo: medicine.medicineType == MedicineType.none
                ? "not_specified".trans()
                : medicine.medicineType.asString().trans(),
          ),
          ExtendedInfoTab(
            fieldTitle: "dose_interval".trans(),
            fieldInfo: sprintf("dose_interval_fmt".trans(), [medicine.interval, (24 / medicine.interval).floor()]) ,
          ),
          ExtendedInfoTab(
              fieldTitle: "start_time".trans(),
              fieldInfo: medicine.getTimeFMT),
        ],
      );
  }
}

class ExtendedInfoTab extends StatelessWidget {
  final String fieldTitle;
  final String fieldInfo;

  const ExtendedInfoTab(
      {Key? key, required this.fieldTitle, required this.fieldInfo})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                fieldTitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              fieldInfo,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFFC9C9C9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
    );
  }
}
