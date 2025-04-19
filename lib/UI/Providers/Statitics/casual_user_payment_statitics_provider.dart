import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/core/Date/get/get_day_of_year_number.dart';
import 'package:gym_scanner/core/coordinate2d.dart';
import 'package:gym_scanner/data/local/customers_database.dart';
import 'package:gym_scanner/domain/casual_user.dart';

final casualUserPaymentStatiticsProvider = StateNotifierProvider<
    _CasualUserPaymentStateNotifier, List<List<List<CasualCustomer>>>>(
  (ref) {
    return _CasualUserPaymentStateNotifier([
      // ...List.generate(
      //   sinceFirstDay,
      //   (index) => [],
      // )
    ]);
  },
);

class _CasualUserPaymentStateNotifier
    extends StateNotifier<List<List<List<CasualCustomer>>>> {
  _CasualUserPaymentStateNotifier(super.state);
  CustomersDatabase customersDatabase = CustomersDatabase.instance;
  bool isLoading = false;

  Future<void> resetAllStatiticts() async {
    await customersDatabase.deleteStatitics();
  }

  Future<void> loadData() async {
    if (!isLoading) {
      try {
        isLoading = true;
        final allYearsList =
            await customersDatabase.getCasualCustomerStatitics();

        state = allYearsList;
      } finally {
        isLoading = false;
      }
    }
  }

  void addRegister(CasualCustomer newRegister,
      {int quantityCustomersToAdd = 1}) async {
    await loadData();

    final startDateInstance = await startDate;

    int daysSinceStartYear = state.length <= 1
        ? startDateInstance.difference(DateTime(startDateInstance.year)).inDays
        : 0; //this only for initial year for fit the index format,i mean the dayOfYear fit to his index in year

    for (int i = 0; i < quantityCustomersToAdd; i++) {
      await customersDatabase.addCasualCustomerStatitic(
          newRegister, getDayOfYearNumber(DateTime.now()) - daysSinceStartYear);
    }
  }

  Future<List<Coordinate2d>> getRegistersCoordenates(int yearSelected) async {
    await loadData();
    List<Coordinate2d> coordenatesList = [];

    for (int x = 0; x < state[yearSelected].length; x++) {
      coordenatesList.add(
          Coordinate2d(x.toDouble(), state[yearSelected][x].length.toDouble()));
    }

    return coordenatesList;
  }

  Future<DateTime> getLastDateRegister() async {
    return await customersDatabase.lastDateRegitred;
  }

  Future<DateTime> get startDate async {
    return await customersDatabase.startTimeDate;
  }
}
