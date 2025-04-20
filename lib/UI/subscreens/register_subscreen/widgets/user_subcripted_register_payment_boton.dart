import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/Providers/usual_customers_list_provider.dart';

import 'package:gym_scanner/UI/widgets/dialogs/show_image.dart';
import 'package:gym_scanner/UI/widgets/info_text.dart';
import 'package:gym_scanner/domain/usual_customer_entity.dart';

import 'dialogs/show_payment_form.dart';

class UserRegisterPaymentBoton extends ConsumerWidget {
  final UsualCustomerEntity entity;
  const UserRegisterPaymentBoton({super.key, required this.entity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.15,
      child: Card(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(left: size.width * 0.03),
              child: InkWell(
                onTap: () => showImage(context, image: entity.userImage!),
                child: Container(
                  width: size.width * 0.22,
                  height: size.width * 0.22,
                  decoration: BoxDecoration(
                      image: entity.userImage != null
                          ? DecorationImage(image: entity.userImage!)
                          : null),
                ),
              )),
          SizedBox(
            width: size.width * 0.38,
            child: ListTile(
              contentPadding: EdgeInsets.only(left: size.width * 0.02),
              title: Text(entity.name),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoText(
                    info: "Días restantes",
                    value: entity.availablesDays.toString(),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.335,
            child: OutlinedButton(
              onPressed: () {
                showPaymentForm(
                  context,
                  title: "Registrar tiempo",
                  timeSelectedText: 'Meses',
                  timeToAddMultiply: 30,
                  ref,
                  onValue: (value) {
                    ref
                        .read(usualCustomerListProvider.notifier)
                        .addPayment(entity, value);
                  },
                );
              },
              style: const ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.white)),
              child: Text(
                "Registrar pago",
                style: TextStyle(fontSize: size.width * 0.03),
              ),
            ),
          )
        ],
      )),
    );
  }
}
