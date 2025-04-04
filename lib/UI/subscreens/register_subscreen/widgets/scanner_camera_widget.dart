import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/Providers/current_customer_provider.dart';

import 'package:gym_scanner/UI/Providers/customers_list_provider.dart';
import 'package:gym_scanner/core/encriptation/get_encripted_value.dart';
import 'package:gym_scanner/domain/customer_entity.dart';

import 'package:just_audio/just_audio.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

final isCameraUsingProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);

final MobileScannerController cameraController = MobileScannerController();

class ScannerCameraWidget extends ConsumerStatefulWidget {
  const ScannerCameraWidget({super.key});

  @override
  ConsumerState<ScannerCameraWidget> createState() =>
      _ScannerCameraWidgetState();
}

class _ScannerCameraWidgetState extends ConsumerState<ScannerCameraWidget> {
  final audioplayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
  }

  bool isVisibleBottons = false;
  bool isOnCamera = false;
  bool qrSelected = false;
  UsualCustomerEntity? lastUserEntity;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (ref.watch(isCameraUsingProvider)) {
      return Expanded(
          child: Stack(
        children: [
          GestureDetector(
              child: MobileScanner(
            onDetect: (
              barcodes,
            ) async {
              if (!qrSelected) {
                qrSelected = true;

                final qrSeleccionado = barcodes.barcodes[0];

                if (ref.watch(customerListProvider).map(
                  (e) {
                    return e.id;
                  },
                ).contains(int.tryParse(
                  qrSeleccionado.rawValue.toString(),
                ))) {
                  ref.read(currentCustomerProvider.notifier).state =
                      ref.watch(customerListProvider).firstWhere(
                    (element) {
                      return element.id ==
                          int.parse(
                            qrSeleccionado.rawValue.toString(),
                          );
                    },
                  );
                  await audioplayer.setAsset("assets/sounds/successfull.mp3");
                  await audioplayer.play();
                  await Future.delayed(const Duration(seconds: 1));
                } else {
                  await audioplayer.setAsset("assets/sounds/sound_error.mp3");
                  await audioplayer.play();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Error!usuario desconocido")));
                }
                qrSelected = false;
              }
            },
            controller: cameraController,
          )),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    ref.read(isCameraUsingProvider.notifier).state = false;
                    // isOnCamera = false;
                  });
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.power_settings_new),
                ),
              ),
            ),
          )
        ],
      ));
    }

    return Expanded(
        child: Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  // isOnCamera = true;
                  ref.read(isCameraUsingProvider.notifier).state = true;
                  cameraController.start();
                });
              },
              child: Icon(
                Icons.power_settings_new,
                size: size.height * 0.07,
              ),
            ),
            Text(
              "Abrir Camara",
              style: TextStyle(fontSize: size.height * 0.015),
            )
          ],
        ),
      ),
    ));
  }
}

// class ScannerCameraFullScreen extends StatefulWidget {
//   const ScannerCameraFullScreen({super.key});

//   @override
//   State<ScannerCameraFullScreen> createState() =>
//       _ScannerCameraFullScreenState();
// }

// class _ScannerCameraFullScreenState extends State<ScannerCameraFullScreen> {
//   final MobileScannerController _controller = MobileScannerController();
//   @override
//   void initState() {
//     super.initState();
//     _controller.start();
//   }

//   @override
//   void dispose() async {
//     super.dispose();
//     _controller.dispose();
//     Future.delayed(const Duration(seconds: 3));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MobileScanner(
//       controller: _controller,
//     );
//   }
// }
