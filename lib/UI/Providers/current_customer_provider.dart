import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/domain/customer_entity.dart';

final currentCustomerProvider = StateProvider<CustomerEntity?>(
  (ref) {
    return null;
  },
);
