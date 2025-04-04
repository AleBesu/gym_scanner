import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/subscreens/register_subscreen/screens/payment_screen.dart';
import 'package:gym_scanner/UI/subscreens/register_subscreen/screens/registred_customer_screen.dart';
import 'package:gym_scanner/UI/subscreens/register_subscreen/widgets/scanner_camera_widget.dart';
import 'package:gym_scanner/UI/subscreens/register_subscreen/widgets/user_infor.dart';
import 'screens/register_customer_screen.dart';
import '../../widgets/opcion_botton.dart';

class SubScreenRegisters extends ConsumerStatefulWidget {
  const SubScreenRegisters({super.key});

  @override
  ConsumerState<SubScreenRegisters> createState() => _SubScreenRegistersState();
}

class _SubScreenRegistersState extends ConsumerState<SubScreenRegisters> {
  @override
  Widget build(BuildContext context) {
    bool isCameraUsingPro = ref.watch(isCameraUsingProvider);

    return Column(
      children: [
        ScannerCameraWidget(),
        Padding(
          padding: EdgeInsets.only(bottom: 25),
          child: UserInfoWidget(),
        ),
        OptionButton(
            onPressed: () async {
              cameraController.stop();
              ref.read(isCameraUsingProvider.notifier).state = false;
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentScreen(),
                  ));
              if (isCameraUsingPro) {
                cameraController.start();
              }
            },
            backGroundColor: Colors.red,
            text: "Registrar Pago",
            icon: Icons.loyalty),
        OptionButton(
          backGroundColor: const Color(0xFF6C757D),
          text: "Registrar Cliente",
          icon: Icons.person_add,
          onPressed: () async {
            cameraController.stop();
            ref.read(isCameraUsingProvider.notifier).state = false;
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerRegisterScreen(),
                ));

            if (isCameraUsingPro) {
              cameraController.start();
            }
          },
        ),
        OptionButton(
            onPressed: () {
              cameraController.stop();
              ref.read(isCameraUsingProvider.notifier).state = false;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistredCustomerScreen(),
                  ));
              if (isCameraUsingPro) {
                cameraController.start();
              }
            },
            backGroundColor: const Color(0xFF6C757D),
            text: "Clientes registrados",
            icon: Icons.people),
      ],
    );
  }
}
