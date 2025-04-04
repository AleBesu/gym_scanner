import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/Providers/Statitics/casual_user_payment_statitics_provider.dart';
import 'package:gym_scanner/UI/subscreens/register_subscreen/widgets/dialogs/show_payment_form.dart';
import 'package:gym_scanner/domain/casual_user.dart';

class UserCasualRegisterBotton extends ConsumerWidget {
  const UserCasualRegisterBotton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        showPaymentForm(
          context,
          ref,
          monthData: false,
          onValue: (value) {
            ref
                .read(casualUserPaymentStatiticsProvider.notifier)
                .addRegister(CasualCustomer(value), dayToAddIndex: 0);
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
