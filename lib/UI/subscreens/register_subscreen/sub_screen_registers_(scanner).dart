import 'package:flutter/material.dart';
import 'package:gym_scanner/UI/subscreens/register_subscreen/screens/payment_screen.dart';
import 'package:gym_scanner/UI/subscreens/register_subscreen/screens/registred_customer_screen.dart';
import 'package:gym_scanner/UI/subscreens/register_subscreen/widgets/scanner_camera_widget.dart';
import 'package:gym_scanner/UI/subscreens/register_subscreen/widgets/user_infor.dart';
import 'screens/register_customer_screen.dart';
import '../../widgets/opcion_botton.dart';

class SubScreenRegisters extends StatefulWidget {
  const SubScreenRegisters({super.key});

  @override
  State<SubScreenRegisters> createState() => _SubScreenRegistersState();
}

class _SubScreenRegistersState extends State<SubScreenRegisters> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ScannerCameraWidget(),
        const Padding(
          padding: EdgeInsets.only(bottom: 25),
          child: UserInfoWidget(),
        ),
        OptionButton(
            onPressed: () async {
              cameraController.stop();
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentScreen(),
                  ));
              cameraController.start();
            },
            backGroundColor: Colors.green,
            text: "Registrar Pago",
            icon: Icons.loyalty),
        OptionButton(
          backGroundColor: const Color(0xFF6C757D),
          text: "Registrar Cliente",
          icon: Icons.person_add,
          onPressed: () {
            cameraController.stop();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerRegisterScreen(),
                ));
            cameraController.start();
          },
        ),
        OptionButton(
            onPressed: () {
              cameraController.stop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistredCustomerScreen(),
                  ));
              cameraController.start();
            },
            backGroundColor: const Color(0xFF6C757D),
            text: "Clientes registrados",
            icon: Icons.people),
      ],
    );
  }
}
