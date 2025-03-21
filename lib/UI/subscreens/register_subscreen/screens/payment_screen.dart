import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/Providers/customers_list_provider.dart';
import 'package:gym_scanner/UI/subscreens/register_subscreen/widgets/user_register_payment_boton.dart';

class PaymentScreen extends ConsumerWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerWidgetPro = ref.watch(customerListProvider);

    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: customerWidgetPro.length,
        itemBuilder: (BuildContext context, int index) {
          return UserRegisterPaymentBoton(entity: customerWidgetPro[index]);
        },
      ),
    );
  }
}
