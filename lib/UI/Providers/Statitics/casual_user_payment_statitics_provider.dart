import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/core/coordinate2d.dart';
import 'package:gym_scanner/data/local/customers_database.dart';
import 'package:gym_scanner/domain/casual_user.dart';
import 'package:sqflite/sqflite.dart';

final int sinceFirstDay = 30;

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
      {required int dayToAddIndex}) async {
    await loadData();

    await customersDatabase.addCasualCustomerStatitic(newRegister);
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
