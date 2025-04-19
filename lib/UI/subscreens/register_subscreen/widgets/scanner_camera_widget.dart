import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/Providers/current_customer_provider.dart';

import 'package:gym_scanner/UI/Providers/usual_customers_list_provider.dart';

import 'package:gym_scanner/domain/customer_entity.dart';

import 'package:just_audio/just_audio.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

final isCameraUsingProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);

bool _isShowingErrorSnackBar = false;

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
  bool qrSelected =
      false; //qr select is a bool for bool for limitate the funtion onDetect of MobileScanner for remplace the value of qr until the internal funtion will complete
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
                if (checkIfDatabaseContainUserId(
                  qrSeleccionado.rawValue.toString(),
                )) {
                  if (ref.read(currentUsualCustomerSelectedProvider) != null
                      ? ref
                              .read(currentUsualCustomerSelectedProvider)!
                              .id!
                              .toString() !=
                          qrSeleccionado.rawValue.toString()
                      : true) {
                    //showCurrentUsualCustomerInScreen
                    _setCurrentUsualCustomer(int.parse(
                      qrSeleccionado.rawValue.toString(),
                    ));
                    await ref
                        .read(usualCustomerListProvider.notifier)
                        .updateLastAccess(
                            ref.read(currentUsualCustomerSelectedProvider)!);
                    _setCurrentUsualCustomer(int.parse(
                      qrSeleccionado.rawValue.toString(),
                    ));

                    //
                    //reproduce sound
                    if (!checkIfLastAccessValueIsToday(ref
                        .read(currentUsualCustomerSelectedProvider)!
                        .lastAccessDateTime)) {
                      await audioplayer
                          .setAsset("assets/sounds/successfull.mp3");
                      await audioplayer.play();
                      await Future.delayed(const Duration(seconds: 1));

                      //updateLastAccess in data base and currentUsualCustomer
                    } else {
                      await audioplayer
                          .setAsset("assets/sounds/sound_error.mp3");
                      await audioplayer.play();
                    }
                  } else if (ref
                          .read(currentUsualCustomerSelectedProvider)!
                          .id!
                          .toString() ==
                      qrSeleccionado.rawValue.toString()) {
                    //not do nothing if currentUsualCustomerSelected == scannedUser
                  } else {
                    await showError(context);
                  }
                } else {
                  await showError(context);
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

  Future<void> _setCurrentUsualCustomer(int id) async {
    ref.read(currentUsualCustomerSelectedProvider.notifier).state =
        ref.watch(usualCustomerListProvider).firstWhere(
      (element) {
        return element.id! == id;
      },
    );
  }

  Future<void> showError(BuildContext context) async {
    await audioplayer.setAsset("assets/sounds/sound_error.mp3");
    await audioplayer.play();
    if (!_isShowingErrorSnackBar) {
      _isShowingErrorSnackBar = true;
      final timeOfShowSnackBar = Duration(seconds: 1);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          duration: timeOfShowSnackBar,
          content: Text(
            "Usuario desconocido",
            style: TextStyle(color: Colors.white),
          )));

      Future.delayed(
        Duration(seconds: 3),
        () => _isShowingErrorSnackBar = false,
      );
    }
  }

  bool checkIfDatabaseContainUserId(String userID) {
    final listToAnalizate = ref.watch(usualCustomerListProvider);
    int? parsedID = int.tryParse(userID);
    if (parsedID == null) {
      return false;
    }

    return listToAnalizate.any(
      (element) {
        return element.id == parsedID;
      },
    );
  }
}

bool checkIfLastAccessValueIsToday(DateTime? lastAccessDate) {
  if (lastAccessDate != null) {
    return (lastAccessDate.year == DateTime.now().year &&
        lastAccessDate.month == DateTime.now().month &&
        lastAccessDate.day == DateTime.now().day);
  } else {
    return false;
  }
}
