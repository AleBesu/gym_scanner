import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/Providers/customers_list_provider.dart';
import 'package:gym_scanner/UI/subscreens/register_subscreen/widgets/user_casual_register_botton.dart';
import 'package:gym_scanner/UI/subscreens/register_subscreen/widgets/user_subcripted_register_payment_boton.dart';

class PaymentScreen extends ConsumerWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerListPro = ref.watch(customerListProvider);

    return Scaffold(
      appBar: AppBar(),
      body: customerListPro.isEmpty
          ? const Center(
              child: Text(
                "No hay usuario registrados",
              ),
            )
          : ListView.builder(
              itemCount: customerListPro.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const UserCasualRegisterBotton(),
                      UserRegisterPaymentBoton(entity: customerListPro[index]),
                    ],
                  );
                }
                return UserRegisterPaymentBoton(entity: customerListPro[index]);
              },
            ),
    );
  }
}
