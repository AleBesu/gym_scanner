import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/core/coordinate2d.dart';
import 'package:gym_scanner/data/local/customers_database.dart';
import 'package:gym_scanner/domain/casual_user.dart';
import 'package:sqflite/sqflite.dart';

final int sinceFirstDay = 30;

final casualUserPaymentStatiticsProvider = StateNotifierProvider<
    _CasualUserPaymentStateNotifier, List<List<CasualCustomer>>>(
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
    extends StateNotifier<List<List<CasualCustomer>>> {
  _CasualUserPaymentStateNotifier(super.state);
  CustomersDatabase customersDatabase = CustomersDatabase.instance;

  Future<void> loadData() async {
    final savedList = await customersDatabase.getCasualCustomerStatitics();
    state = savedList;
  }

  void addRegister(CasualCustomer newRegister,
      {required int dayToAddIndex}) async {
    await loadData();

    await customersDatabase.addCasualCustomerStatitic(newRegister);
  }

  Future<List<Coordinate2d>> getRegistersCoordenates() async {
    await loadData();
    List<Coordinate2d> coordenatesList = [];

    for (int x = 0; x < state.length; x++) {
      coordenatesList
          .add(Coordinate2d(x.toDouble(), state[x].length.toDouble()));
    }

    return coordenatesList;
  }
}
