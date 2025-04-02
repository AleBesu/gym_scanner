import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/core/generate/generate_qr_image_file.dart';
import 'package:gym_scanner/data/local/customers_database.dart';

import 'package:gym_scanner/domain/customer_entity.dart';

final customerListProvider =
    StateNotifierProvider<_CustomersProvider, List<CustomerEntity>>(
  (ref) {
    return _CustomersProvider([]);
  },
);

class _CustomersProvider extends StateNotifier<List<CustomerEntity>> {
  CustomersDatabase localDataBase = CustomersDatabase.instance;
  _CustomersProvider(super.state) {
    loadInfoFromDatabase();
  }

  Future<void> loadInfoFromDatabase() async {
    final db = await localDataBase.getCustomersList();

    state = db
        .map(
          (e) => CustomerEntity.fromMap(e),
        )
        .toList();
  }

  void addCustomer(CustomerEntity addedCustomer) async {
    addedCustomer.creationDate = DateTime.now();
    addedCustomer.lastPayment = DateTime.now();
    addedCustomer.id = Random().nextInt(10000000);
    addedCustomer.qrCodeImage = await generateUserQrImageFile(addedCustomer);

    await localDataBase.addCustomer(addedCustomer);
    await loadInfoFromDatabase();
  }

  void addPayment(CustomerEntity addedCustomer, int daysToAdd) {
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

    await db.deleteCustomer(elementsToRemoveID);
    loadInfoFromDatabase();
  }
}
