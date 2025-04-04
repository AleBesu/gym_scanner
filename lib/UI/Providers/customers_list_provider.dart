import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/Providers/Statitics/usual_user_payment_provider.dart';
import 'package:gym_scanner/core/generate/generate_qr_image_file.dart';
import 'package:gym_scanner/data/local/customers_database.dart';

import 'package:gym_scanner/domain/customer_entity.dart';

final customerListProvider =
    StateNotifierProvider<_CustomersProvider, List<UsualCustomerEntity>>(
  (ref) {
    return _CustomersProvider([], ref);
  },
);

class _CustomersProvider extends StateNotifier<List<UsualCustomerEntity>> {
  CustomersDatabase localDataBase = CustomersDatabase.instance;
  final Ref ref;
  _CustomersProvider(super.state, this.ref) {
    loadInfoFromDatabase();
  }

  Future<void> loadInfoFromDatabase() async {
    final db = await localDataBase.getUsualCustomersList();

    state = db
        .map(
          (e) => UsualCustomerEntity.fromMap(e),
        )
        .toList();
  }

  void addCustomer(UsualCustomerEntity addedCustomer) async {
    addedCustomer.creationDate = DateTime.now();
    addedCustomer.lastPayment = DateTime.now();
    addedCustomer.id = Random().nextInt(10000000);
    addedCustomer.qrCodeImage = await generateUserQrImageFile(addedCustomer);

    await localDataBase.addUsualCustomer(addedCustomer);
    await loadInfoFromDatabase();

    ///saved in statitics
    ref
        .read(usualUserPaymentStatiticsProvider.notifier)
        .addRegister(addedCustomer);
  }

  void addPayment(UsualCustomerEntity addedCustomer, int daysToAdd) {
    state = state.map(
      (customer) {
        if (addedCustomer.id == customer.id) {
          customer.expiratioDate =
              customer.expiratioDate!.add(Duration(days: daysToAdd));
        }

        return customer;
      },
    ).toList();
  }

  Future<void> removeForID(List<int> elementsToRemoveID) async {
    final db = await localDataBase;

    await db.deleteUsualCustomer(elementsToRemoveID);
    loadInfoFromDatabase();
  }
}
