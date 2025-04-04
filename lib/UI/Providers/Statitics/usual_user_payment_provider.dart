import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/core/coordinate2d.dart';
import 'package:gym_scanner/data/local/customers_database.dart';
import 'package:gym_scanner/domain/customer_entity.dart';

final usualUserPaymentStatiticsProvider = StateNotifierProvider(
  (ref) {
    return _UsualUserPayment([]);
  },
);

class _UsualUserPayment
    extends StateNotifier<List<List<List<UsualCustomerEntity>>>> {
  _UsualUserPayment(super.state);
  CustomersDatabase customersDatabase = CustomersDatabase.instance;

  Future<void> addRegister(UsualCustomerEntity entity) async {
    await customersDatabase.addUsualCustomerStatitic(entity);
  }

  Future<List<List<UsualCustomerEntity>>> getStatitics() async {
    final allStattitics = await customersDatabase.getUsualCustomerStatitics();

    // return allStattitics[0];
    return allStattitics[0];
  }

  // Future<List<Coordinate2d>> getRegistersCoordenates() async {

  //   return coordenatesList;
  // }
}
