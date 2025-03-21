import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/core/generate/generate_qr_image_file.dart';
import 'package:gym_scanner/core/get_new_qr_file.dart';
import 'package:gym_scanner/core/get_random_string.dart';
import 'package:gym_scanner/domain/customer_entity.dart';

final customerListProvider =
    StateNotifierProvider<_CustomersProvider, List<CustomerEntity>>(
  (ref) {
    return _CustomersProvider([]);
  },
);

class _CustomersProvider extends StateNotifier<List<CustomerEntity>> {
  _CustomersProvider(super.state);

  void add(CustomerEntity addedCustomer) async {
    addedCustomer.creationDate = DateTime.now();
    addedCustomer.lastPayment = DateTime.now();
    addedCustomer.id = Random().nextInt(900000);

    addedCustomer.qrCodeImage = await generateUserQrImageFile(addedCustomer);

    state = [...state, addedCustomer];
  }

  void addPayment(CustomerEntity addedCustomer, int daysToAdd) {
    state = [
      ...state.map(
        (customer) {
          if (addedCustomer.id == customer.id) {
            customer.expiratioDate =
                customer.expiratioDate!.add(Duration(days: daysToAdd));
          }

          return customer;
        },
      )
    ];
  }
}
