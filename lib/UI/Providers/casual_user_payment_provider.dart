import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/core/coordinate2d.dart';
import 'package:gym_scanner/domain/casual_user.dart';

final casualUserPaymentProvider = StateNotifierProvider<
    _CasualUserPaymentStateNotifier, List<List<List<List<List<CasualUser>>>>>>(
  (ref) {
    return _CasualUserPaymentStateNotifier([
      [
        [
          [[], [], []]
        ]
      ]
    ]);
  },
);

class _CasualUserPaymentStateNotifier
    extends StateNotifier<List<List<List<List<List<CasualUser>>>>>> {
  _CasualUserPaymentStateNotifier(super.state);

  void addRegister(CasualUser newRegister,
      {required int yearToAdd,
      required int monthToAdd,
      required int weekToAdd,
      required int dayToAdd}) {
    final lastRegisterList = state[yearToAdd][monthToAdd][weekToAdd][dayToAdd];

    final newRegisterList = [...lastRegisterList, newRegister];
    List<List<List<List<List<CasualUser>>>>> newState = state;
    newState[yearToAdd][monthToAdd][weekToAdd][dayToAdd] = newRegisterList;

    state = newState;
  }

  List<Coordinate2d> getRegistersCoordenates() {
    int xActual = 0;
    List<Coordinate2d> coordenatesList = [];
    for (List year in state) {
      for (List month in year) {
        for (List week in month) {
          for (List day in week) {
            coordenatesList
                .add(Coordinate2d(xActual.toDouble(), day.length.toDouble()));
            xActual++;
          }
        }
      }
    }

    return coordenatesList;
  }
}
