import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/Providers/Statitics/casual_user_payment_statitics_provider.dart';

Future<void> showQuestionIfResetStatitics(
    BuildContext context, WidgetRef ref) async {
  Size size = MediaQuery.of(context).size;
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        // contentPadding: EdgeInsets.symmetric(
        //   vertical: size.height * 0.01,
        //   horizontal: size.width * 0.06,
        // ),
        actionsPadding: EdgeInsets.only(
          bottom: size.height * 0.01,
          right: size.width * 0.06,
        ),
        content: const Text("Está seguro que desea reiniciar la estadísticas?"),
        actions: [
          TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancelar",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              )),
          TextButton(
              onPressed: () async {
                await ref
                    .read(casualUserPaymentStatiticsProvider.notifier)
                    .resetAllStatiticts();

                Navigator.pop(context);
              },
              child: const Text(
                "Confirmar",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              )),
        ],
      );
    },
  );
}
