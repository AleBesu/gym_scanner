import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/Providers/customers_list_provider.dart';
import 'package:gym_scanner/UI/subscreens/register_subscreen/widgets/user_infor.dart';
import 'package:gym_scanner/UI/widgets/alert_dialogs/show_image.dart';
import 'package:gym_scanner/UI/widgets/info_text.dart';
import 'package:gym_scanner/domain/customer_entity.dart';

class UserRegisterPaymentBoton extends ConsumerWidget {
  final CustomerEntity entity;
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
                _showPaymentForm(context, ref, entity: entity);
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

Future<void> _showPaymentForm(BuildContext context, WidgetRef ref,
    {required CustomerEntity entity}) async {
  TextEditingController timeController = TextEditingController(text: "1");
  int timeValue = int.parse(timeController.text);
  String? timeTypeSelected = "Meses";

  Size size = MediaQuery.of(context).size;
  showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              insetPadding: EdgeInsets.zero,
              title: const Text("Registrar tiempo"),
              content: Row(
                children: [
                  IntrinsicWidth(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: size.width * 0.15,
                          maxHeight: size.height * 0.07),
                      child: TextFormField(
                        controller: timeController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black))),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton(
                      value: timeTypeSelected,
                      items: [
                        DropdownMenuItem(
                          value: "Meses",
                          child: Text("Mes${timeValue == 1 ? "" : "es"}"),
                        ),
                        DropdownMenuItem(
                          value: "Dias",
                          child: Text("Día${timeValue == 1 ? "" : "s"}"),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            timeTypeSelected = value;
                          });
                        }
                      },
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      ref.read(customerListProvider.notifier).addPayment(
                          entity,
                          timeTypeSelected == "Dias"
                              ? timeValue
                              : timeValue * 30);
                      Navigator.pop(context);
                    },
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.green),
                        foregroundColor: WidgetStatePropertyAll(Colors.white)),
                    child: const Text("Confirmar"),
                  )
                ],
              ),
            ),
          ));
}
