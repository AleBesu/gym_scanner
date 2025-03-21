import 'package:flutter/material.dart';
import 'package:gym_scanner/UI/widgets/info_text.dart';
import 'package:gym_scanner/UI/subscreens/register_subscreen/widgets/statusUserWiidget.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(children: [
      Container(
        color: const Color.fromARGB(255, 54, 54, 54),
        width: size.width,
        height: size.height * 0.42,
      ),
      Container(
        width: size.width,
        height: size.height * 0.42,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    width: size.width / 3,
                    height: size.width / 3,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: size.width * 0.08,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    width: size.width / 3,
                    height: size.width / 3,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/qr_image.png"))),
                  ),
                ),
              ],
            ),
            ListTile(
              title: const Text(
                "Información",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoText(
                    info: "Nombre",
                    value: "Besu",
                  ),
                  InfoText(
                    info: "Ultimo pago",
                    value: "2-2-2024",
                  ),
                  InfoText(
                    info: "Dias Restantes",
                    value: "15",
                  ),
                ],
              ),
            ),
            UserStatusWidget._UserStatusWidget()
          ],
        ),
      ),
    ]);
  }
}

class UserStatusWidget extends StatefulWidget {
  bool availableStatus;
  UserStatusWidget._UserStatusWidget({super.key, this.availableStatus = true});

  @override
  State<UserStatusWidget> createState() => _UserStatusWidgetState();
}

class _UserStatusWidgetState extends State<UserStatusWidget> {
  late bool availableStatus;

  @override
  void initState() {
    // TODO: implement initState
    availableStatus = widget.availableStatus;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: availableStatus ? Colors.green : Colors.red,
      ),
      padding: EdgeInsets.all(10),
      width: size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              availableStatus ? Icon(Icons.verified) : Icon(Icons.error),
              Text(availableStatus ? "Acceso Permitido" : "Acceso Denegado")
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: size.width * 0.06),
            child: Text("Ultima Entrada: 3:47pm-18-5-25 "),
          )
        ],
      ),
    );
  }
}
