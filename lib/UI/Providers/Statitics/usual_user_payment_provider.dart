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
    await customersDatabase.addUsualCustomerStatitic(entity,
        toAddMonthNumber: DateTime.now().month);
  }

  Future<List<List<UsualCustomerEntity>>> getAYearStatitics(
      {required int yearSelected}) async {
    final allStattitics = await customersDatabase.getUsualCustomerStatitics();

    return allStattitics[yearSelected];
  }

  Future<List<List<List<UsualCustomerEntity>>>> getAllYearsStatics() async {
    final valor = await customersDatabase.getUsualCustomerStatitics();
    print(valor.length);

    return await customersDatabase.getUsualCustomerStatitics();
  }

  Future<DateTime> getStartDateTime() async {
    return customersDatabase.getStartDateTime();
  }
}
