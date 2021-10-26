import 'package:flutter/material.dart';
import 'package:mediminder/global_bloc.dart';
import 'package:mediminder/models/medicine.dart';
import 'package:mediminder/ui/medicine_details.dart';
import 'package:mediminder/ui/new_entry/new_entry.dart';
import 'package:provider/provider.dart';
import 'package:mediminder/common.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3EB16F),
        elevation: 0.0,
      ),
      body: Container(
        color: const Color(0xFFF6F8FC),
        child: Column(
          children: <Widget>[
            const Flexible(
              flex: 3,
              child: TopContainer(),
            ),
            const SizedBox(height: 10),
            Flexible(
              flex: 7,
              child: Provider<GlobalBloc>.value(
                child: const BottomContainer(),
                value: _globalBloc,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 4,
        backgroundColor: const Color(0xFF3EB16F),
        child: const Icon(Icons.add),
        onPressed: () {
          context.pushMaterialRoute((ctx) => const NewEntry());
        },
      ),
    );
  }
}

class TopContainer extends StatelessWidget {
  const TopContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.elliptical(50, 27),
          bottomRight: Radius.elliptical(50, 27),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.grey[400]!,
            offset: const Offset(0, 3.5),
          )
        ],
        color: const Color(0xFF3EB16F),
      ),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(
              bottom: 10,
            ),
            child: Text(
              "Mediminder",
              style: TextStyle(
                fontFamily: "Angel",
                fontSize: 64,
                color: Colors.white,
              ),
            ),
          ),
          const Divider(
            color: Color(0xFFB0F3CB),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Center(
              child: Text(
                "num_of_mediminders".trans(),
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          StreamBuilder<List<Medicine>>(
            stream: globalBloc.medicineList$,
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 5 ),
                child: Center(
                  child: Text(
                    snapshot.data?.length.toString() ?? '0',
                    style: const TextStyle(
                      fontFamily: "Neu",
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class BottomContainer extends StatelessWidget {

  const BottomContainer({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return StreamBuilder<List<Medicine>>(
      stream: _globalBloc.medicineList$,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else if (snapshot.data!.isEmpty) {
          return Center(
              child: Text(
                "press_add_mediminer".trans(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFFC9C9C9),
                    fontWeight: FontWeight.bold),
              ),
            );
        } else {
          return  Container(
            color: const Color(0xFFF6F8FC),
            child: GridView.builder(
              padding: const EdgeInsets.only(top: 12),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return MedicineCard(snapshot.data![index]);
              },
            ),
          );
        }
      },
    );
  }
}

@immutable
class MedicineCard extends StatelessWidget {
  final Medicine medicine;

  const MedicineCard(this.medicine, {Key? key}):super(key: key);

  Hero makeIcon(double size) =>  Hero(
        tag: medicine.getTag,
        child: Icon(
          medicine.getIconData,
          color: const Color(0xFF3EB16F),
          size: size,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        highlightColor: Colors.white,
        splashColor: Colors.grey,
        onTap: () {
          context.pushRouteAnimation(MedicineDetails(medicine));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                makeIcon(48.0),
                Hero(
                  tag: medicine.medicineName,
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      medicine.medicineName,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xFF3EB16F),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Text(
                  medicine.interval == 1
                      ? "Every " + medicine.interval.toString() + " hour"
                      : "Every " + medicine.interval.toString() + " hours",
                  style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFFC9C9C9),
                      fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}