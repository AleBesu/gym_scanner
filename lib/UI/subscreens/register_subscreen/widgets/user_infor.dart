import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/Providers/current_customer_provider.dart';
import 'package:gym_scanner/UI/widgets/info_text.dart';
import 'package:gym_scanner/UI/subscreens/register_subscreen/widgets/statusUserWiidget.dart';
import 'package:gym_scanner/domain/customer_entity.dart';

class UserInfoWidget extends ConsumerWidget {
  const UserInfoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    final entity = ref.watch(currentCustomerProvider);
    return Stack(children: [
      Container(
        color: const Color.fromARGB(255, 54, 54, 54),
        width: size.width,
        height: size.height * 0.42,
      ),
      SizedBox(
        width: size.width,
        height: size.height * 0.42,
        child: entity == null
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person_search,
                      size: size.height * 0.1,
                    ),
                    Text("Escanea un usuario")
                  ],
                ),
              )
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          width: size.width / 3,
                          height: size.width / 3,
                          decoration: BoxDecoration(
                              image: entity.userImage != null
                                  ? DecorationImage(image: entity.userImage!)
                                  : null),
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
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.none,
                                  image: entity.qrCodeImage!)),
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
                          value: entity.name,
                        ),
                        InfoText(
                          info: "Ultimo pago",
                          value:
                              "${entity.lastPayment!.day}-${entity.lastPayment!.month}-${entity.lastPayment!.year}",
                        ),
                        InfoText(
                          info: "Dias Restantes",
                          // value: entity.availablesDays.toString(),
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
      padding: const EdgeInsets.all(10),
      width: size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              availableStatus
                  ? const Icon(Icons.verified)
                  : const Icon(Icons.error),
              Text(availableStatus ? "Acceso Permitido" : "Acceso Denegado")
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: size.width * 0.06),
            child: const Text("Ultima Entrada: 3:47pm-18-5-25 "),
          )
        ],
      ),
    );
  }
}
