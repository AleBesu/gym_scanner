import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/Providers/customers_list_provider.dart';
import 'package:gym_scanner/UI/widgets/imageSelector/image_selected_widget.dart';

import 'package:gym_scanner/domain/customer_entity.dart';

class CustomerRegisterScreen extends ConsumerWidget {
  CustomerRegisterScreen({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController daysController = TextEditingController();

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
                assert(
                    daysController.text != null || daysController.text.isEmpty,
                    "daysController cannot be null or isEmpty");
                if (_formKey.currentState!.validate()) {
                  ref.read(customerListProvider.notifier).add(CustomerEntity(
                        userImage: imageSelectedPro,
                        nameController.text,
                        expiratioDate: DateTime.now().add(
                            Duration(days: int.tryParse(daysController.text)!)),
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
                            child: const Text("Días"),
                          ),
                          TextFormField(
                            validator: (value) {},
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: daysController,
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
