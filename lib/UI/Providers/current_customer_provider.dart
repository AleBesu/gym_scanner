import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/domain/usual_customer_entity.dart';

final currentUsualCustomerSelectedProvider =
    StateProvider<UsualCustomerEntity?>(
  (ref) {
    return null;
  },
);
