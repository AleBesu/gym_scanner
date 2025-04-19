import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/Providers/usual_customers_list_provider.dart';
import 'package:gym_scanner/UI/subscreens/register_subscreen/widgets/user_casual_register_botton.dart';
import 'package:gym_scanner/UI/subscreens/register_subscreen/widgets/user_subcripted_register_payment_boton.dart';
import 'package:gym_scanner/domain/casual_user.dart';

import '../../../Providers/Statitics/casual_user_payment_statitics_provider.dart';
import '../widgets/dialogs/show_payment_form.dart';

class PaymentScreen extends ConsumerWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerListPro = ref.watch(usualCustomerListProvider);

    return Scaffold(
      appBar: AppBar(),
      body: customerListPro.isEmpty
          ? FutureBuilder(
              future: Future.delayed(const Duration(seconds: 5)),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   ;
                // } else {
                return ListView.builder(
                  itemCount: 2,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return UserCasualRegisterBotton();
                    }
                    if (index == 1 &&
                        snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(),
                      ));
                    }
                    return Center(
                      child: Text(
                        "No hay usuarios registrados",
                      ),
                    );
                  },
                );

                // return const Center(
                //   child: Text(
                //     "No hay usuario registrados",
                //   ),
                // );
                // }
              },
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

class UserCasualRegisterBotton extends ConsumerWidget {
  const UserCasualRegisterBotton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () async {
        await showPaymentForm(
          context,
          timeSelectedText: 'Clientes',
          title: "Registrar cliente casual",
          ref,
          // monthData: false,
          onValue: (value) async {
            ref.read(casualUserPaymentStatiticsProvider.notifier).addRegister(
                CasualCustomer(value),
                quantityCustomersToAdd: value);

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              margin: EdgeInsets.all(size.height * 0.02),
              behavior: SnackBarBehavior.floating,
              content: Text(
                "Cliente casual registrado",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ));
          },
        );
      },
      child: SizedBox(
        height: size.height * 0.15,
        child: const Card(
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_add),
                    Text("Agregar usuario casual")
                  ],
                )
              ],
            )),
      ),
    );
  }
}
