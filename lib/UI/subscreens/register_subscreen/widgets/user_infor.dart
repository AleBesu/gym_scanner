import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/Providers/current_customer_provider.dart';
import 'package:gym_scanner/UI/subscreens/register_subscreen/widgets/scanner_camera_widget.dart';
import 'package:gym_scanner/UI/widgets/info_text.dart';
import 'package:gym_scanner/core/Date/date_time_format.dart';

import 'package:gym_scanner/domain/usual_customer_entity.dart';

class UserInfoWidget extends ConsumerWidget {
  UserInfoWidget({super.key});
  UsualCustomerEntity?
      lastUserEntity; /*this for save the last user Authenticated,because currentCustomerProvider is not a Future and i'm lazy to change that now */
  UniqueKey _loadUserKey = UniqueKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    final entity = ref.watch(currentUsualCustomerSelectedProvider);
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
                    const Text("Escanea un usuario")
                  ],
                ),
              )
            : FutureBuilder(
                key: _loadUserKey,
                future: Future.delayed(const Duration(milliseconds: 500)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (lastUserEntity == null ||
                      entity.id != lastUserEntity!.id) {
                    lastUserEntity = entity;
                    _loadUserKey = UniqueKey();
                  }
                  return Column(
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
                                      ? DecorationImage(
                                          image: entity.userImage!)
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
                              value: entity.availablesDays.toString(),
                            ),
                          ],
                        ),
                      ),
                      UserStatusWidget(
                        availableStatus: entity.availablesDays >= 1,
                        lastAccess: entity.lastAccessDateTime,
                      )
                    ],
                  );
                }),
      ),
    ]);
  }
}

class UserStatusWidget extends StatefulWidget {
  bool availableStatus;
  final DateTime? lastAccess;
  UserStatusWidget(
      {super.key, this.availableStatus = true, required this.lastAccess});

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
    //DateTime(1) when last access is for give access when has never entered

    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: !availableStatus
            ? Colors.red
            : checkIfLastAccessValueIsToday(widget.lastAccess ?? DateTime(1))
                ? Colors.amber
                : Colors.green,
      ),
      padding: const EdgeInsets.all(10),
      width: size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              !availableStatus
                  ? const Icon(Icons.error)
                  : checkIfLastAccessValueIsToday(
                          widget.lastAccess ?? DateTime(1))
                      ? Icon(Icons.warning)
                      : Icon(Icons.verified),
              Text(
                !availableStatus
                    ? "Acceso Denegado"
                    : checkIfLastAccessValueIsToday(
                            widget.lastAccess ?? DateTime(1))
                        ? 'Alerta'
                        : "Acceso Permitido",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: size.width * 0.06),
            child: InfoText(
                info: 'Última entrada',
                value: widget.lastAccess == null
                    ? "Nunca ha entrado"
                    : checkIfLastAccessValueIsToday(widget.lastAccess!)
                        ? "Hoy a la${widget.lastAccess!.hour == 1 ? '' : 's'}${dateTimeFormatOnlyHourAndMinutes(widget.lastAccess!)}"
                        : dateTimeFormatHourDayMonth(widget.lastAccess!)),
          )
        ],
      ),
    );
  }
}
