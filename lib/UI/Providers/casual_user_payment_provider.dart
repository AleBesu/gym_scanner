import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/core/coordinate2d.dart';
import 'package:gym_scanner/data/local/customers_database.dart';
import 'package:gym_scanner/domain/casual_user.dart';
import 'package:sqflite/sqflite.dart';

final int sinceFirstDay = 30;

final casualUserPaymentProvider = StateNotifierProvider<
    _CasualUserPaymentStateNotifier, List<List<CasualUser>>>(
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
    extends StateNotifier<List<List<CasualUser>>> {
  _CasualUserPaymentStateNotifier(super.state);
  CustomersDatabase customersDatabase = CustomersDatabase.instance;

  Future<void> loadData() async {
    final db = await customersDatabase;
    final savedList = await customersDatabase.getCasualUserStatitics();
    state = savedList;
  }

  void addRegister(CasualUser newRegister, {required int dayToAddIndex}) async {
    // List<CasualUser> actualDay = state[dayToAddIndex];
    // actualDay.add(newRegister);
    // List<List<CasualUser>> newState = state;
    // for (int i = 0; i < state.length; i++) {
    //   if (i == dayToAddIndex) {
    //     newState[i] = actualDay;
    //   }
    // }
    await loadData();
    // List<List<CasualUser>> newState = state;
    // newState.last.add(newRegister);
    await customersDatabase.addCasualUser(newRegister);

    // state = newState;
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
