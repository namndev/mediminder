import 'package:mediminder/models/medicine.dart';
import 'package:rxdart/rxdart.dart';

class NewEntryBloc {
  late BehaviorSubject<MedicineType> _selectedMedicineType$;
  ValueStream<MedicineType> get selectedMedicineType =>
      _selectedMedicineType$.stream;

  late BehaviorSubject<int> _selectedInterval$;
  BehaviorSubject<int> get selectedInterval$ => _selectedInterval$;

  late BehaviorSubject<String> _selectedTimeOfDay$;
  BehaviorSubject<String> get selectedTimeOfDay$ => _selectedTimeOfDay$;

    late BehaviorSubject<String> _selectedDate$;
  BehaviorSubject<String> get selectedDate$ => _selectedDate$;

  late BehaviorSubject<EntryError> _errorState$;
  BehaviorSubject<EntryError> get errorState$ => _errorState$;

  NewEntryBloc() {
    _selectedMedicineType$ =
        BehaviorSubject<MedicineType>.seeded(MedicineType.none);
    // _checkedDays$ = BehaviorSubject<List<Day>>.seeded([]);
    _selectedTimeOfDay$ = BehaviorSubject<String>.seeded("none");
    _selectedDate$ = BehaviorSubject<String>.seeded("none");
    _selectedInterval$ = BehaviorSubject<int>.seeded(0);
    _errorState$ = BehaviorSubject<EntryError>();
  }

  void dispose() {
    _selectedMedicineType$.close();
    // _checkedDays$.close();
    _selectedTimeOfDay$.close();
    _selectedDate$.close();
    _selectedInterval$.close();
  }

  void submitError(EntryError error) {
    _errorState$.add(error);
  }

  void updateInterval(int interval) {
    _selectedInterval$.add(interval);
  }

  void updateTime(String timeOfDay, {String? date}) {
    _selectedTimeOfDay$.add(timeOfDay);
    if (date != null){
      _selectedDate$.add(date);
    }
  }

  void updateSelectedMedicine(MedicineType type) {
    MedicineType _tempType = _selectedMedicineType$.value;
    if (type == _tempType) {
      _selectedMedicineType$.add(MedicineType.none);
    } else {
      _selectedMedicineType$.add(type);
    }
  }
}
