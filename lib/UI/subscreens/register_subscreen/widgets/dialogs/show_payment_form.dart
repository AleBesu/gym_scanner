import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/domain/usual_customer_entity.dart';

import '../../../../Providers/usual_customers_list_provider.dart';

Future<void> showPaymentForm(BuildContext context, WidgetRef ref,
    {required String timeSelectedText,
    required String title,
    required Function(int value) onValue,
    int timeToAddMultiply = 1
    // bool monthData = true,
    }) async {
  TextEditingController timeController = TextEditingController(text: "1");
  int timeLastValue = 1;
  // String? timeTypeSelected = monthData ? "Meses" : "Dias";

  Size size = MediaQuery.of(context).size;
  showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
            int timeValue = int.parse(timeController.text.isNotEmpty
                ? timeController.text
                : 0.toString());

            return AlertDialog(
              insetPadding: EdgeInsets.zero,
              title: Text(title),
              content: Row(
                children: [
                  IntrinsicWidth(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: size.width * 0.15,
                          maxHeight: size.height * 0.07),
                      child: TextFormField(
                        onChanged: (value) {
                          timeValue = int.parse(
                              value.isNotEmpty ? value : 0.toString());

                          if (timeLastValue == 1 && timeValue != 1 ||
                              timeLastValue != 1 && timeValue == 1) {
                            timeLastValue = timeValue;

                            setState(() {});
                          }
                        },
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
                      child: Text(timeSelectedText)
                      //  /!monthData
                      //     ? Text("Días")
                      //     : DropdownButton(
                      //         value: timeTypeSelected,
                      //         items: [
                      //           DropdownMenuItem(
                      //             value: "Meses",
                      //             child: Text("Mes${timeValue == 1 ? "" : "es"}"),
                      //           ),
                      //           DropdownMenuItem(
                      //             value: "Dias",
                      //             child: Text("Día${timeValue == 1 ? "" : "s"}"),
                      //           ),
                      //         ],
                      //         onChanged: (value) {
                      //           if (value != null) {
                      //             setState(() {
                      //               timeTypeSelected = value;
                      //             });
                      //           }
                      //         },
                      //       ),
                      ),
                  FilledButton(
                    onPressed: () {
                      // onValue(timeTypeSelected == "Dias"
                      //     ? timeValue
                      //     : timeValue * 30);

                      // ref.read(customerListProvider.notifier).addPayment(
                      //     entity,
                      //     timeTypeSelected == "Dias"
                      // ? timeValue
                      //         : timeValue * 30);
                      onValue(timeValue * timeToAddMultiply);

                      Navigator.pop(context);
                    },
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.red),
                        foregroundColor: WidgetStatePropertyAll(Colors.white)),
                    child: const Text("Confirmar"),
                  )
                ],
              ),
            );
          }));
}
