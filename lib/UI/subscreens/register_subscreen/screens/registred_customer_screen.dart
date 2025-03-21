import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/Providers/customers_list_provider.dart';
import 'package:gym_scanner/UI/widgets/alert_dialogs/show_image.dart';
import 'package:gym_scanner/domain/customer_entity.dart';

class RegistredCustomerScreen extends ConsumerWidget {
  const RegistredCustomerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersList = ref.watch(customerListProvider);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: customersList.length < 1
          ? Center(
              child: Text(
                "No hay usuario registrados",
              ),
            )
          : ListView.builder(
              itemCount: customersList.length,
              itemBuilder: (BuildContext context, int index) {
                return _RegisterCustomerWidget(customersList[index]);
              },
            ),
    );
  }
}

class _RegisterCustomerWidget extends StatelessWidget {
  final CustomerEntity entity;
  const _RegisterCustomerWidget(this.entity);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.15,
      child: Card(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
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
            width: size.width * 0.45,
            child: ListTile(
              title: Text(entity.name),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Días restantes : ${entity.expiratioDate!.difference(DateTime.now()).inDays + 1}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("Desde: ${entity.availablesDays}")
                ],
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.06,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  showImage(context, image: entity.qrCodeImage!);
                },
                child: Icon(
                  Icons.qr_code,
                  size: size.height * 0.07,
                ),
              ),
              const InkWell(
                child: Icon(
                  Icons.download,
                ),
              )
            ],
          ),
        ],
      )),
    );
  }
}
