import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/Providers/Statitics/usual_user_payment_provider.dart';
import 'package:gym_scanner/UI/Providers/usual_customers_list_provider.dart';
import 'package:gym_scanner/UI/widgets/imageSelector/image_selected_widget.dart';

import 'package:gym_scanner/domain/usual_customer_entity.dart';

class CustomerRegisterScreen extends ConsumerWidget {
  CustomerRegisterScreen({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController timeToAddTextController =
      TextEditingController(text: 1.toString());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageSelectedPro = ref.watch(imageSelectedProvider);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  ref
                      .read(usualCustomerListProvider.notifier)
                      .addCustomer(UsualCustomerEntity(
                        nameController.text.trim(),
                        creationDate: DateTime.now(),
                        lastPayment: DateTime.now(),
                        userImage: imageSelectedPro,
                        expiratioDate: DateTime.now().add(Duration(
                            days: int.tryParse(timeToAddTextController.text)! *
                                30)),
                      ));

                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.done))
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const ImageSelectedWidget(),
                Padding(
                  padding: EdgeInsets.only(
                      top: size.height * 0.05, bottom: size.height * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: size.height * 0.01),
                        child: const Text("Nombre"),
                      ),
                      SizedBox(
                        width: size.width * 0.8,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return "Rellena los campo";
                            }

                            if (ref.read(usualCustomerListProvider).any(
                              (usualCustomer) {
                                return nameController.text.trim() ==
                                    usualCustomer.name;
                              },
                            )) {
                              return 'Ya existe un usuario con ese nombre';
                            }
                          },
                          decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            border: OutlineInputBorder(),
                          ),
                          controller: nameController,
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: size.width * 0.1),
                    child: SizedBox(
                      width: size.width * 0.15,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: size.height * 0.01),
                            child: Text('Meses'),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "Rellena los campos";
                              }
                              if (int.parse(timeToAddTextController.value.text
                                      .toString()
                                      .trim()) <=
                                  0) {
                                return 'Debes agregar al menos un mes';
                              }
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: timeToAddTextController,
                            decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
