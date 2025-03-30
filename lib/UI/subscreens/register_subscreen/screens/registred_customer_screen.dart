import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/Providers/customers_list_provider.dart';
import 'package:gym_scanner/UI/widgets/dialogs/show_image.dart';
import 'package:gym_scanner/UI/widgets/selecter/selectable_elements.dart';
import 'package:gym_scanner/core/Date/date_time_format.dart';
import 'package:gym_scanner/core/list_where_index.dart';
import 'package:gym_scanner/domain/customer_entity.dart';
import 'package:share_plus/share_plus.dart';

class RegistredCustomerScreen extends ConsumerWidget {
  const RegistredCustomerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    final customersList = ref.watch(customerListProvider);
    final selectedElements = ref.watch(selectedElementIndexListProvider);
    return PopScope(
      canPop: !ref.watch(isSelectingModeProvider),
      onPopInvoked: (didPop) {
        if (ref.watch(isSelectingModeProvider)) {
          ref.read(selectedElementIndexListProvider.notifier).state = [];
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            if (ref.watch(isSelectingModeProvider))
              selectedElements.length < customersList.length
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: () {
                            ref
                                .read(selectedElementIndexListProvider.notifier)
                                .update(
                              (state) {
                                return List.generate(
                                  customersList.length,
                                  (index) => index,
                                );
                              },
                            );
                          },
                          child: const Icon(Icons.done_all)),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: () {
                            ref
                                .read(selectedElementIndexListProvider.notifier)
                                .update(
                              (state) {
                                return [];
                              },
                            );
                          },
                          child: const Icon(Icons.remove_done)),
                    ),
            if (ref.watch(isSelectingModeProvider))
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Alerta",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: size.height * 0.01,
                              horizontal: size.width * 0.06,
                            ),
                            content: Text(
                                "Desea eliminar ${selectedElements.length} usuarios?"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Cancelar",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  )),
                              TextButton(
                                  onPressed: () async {
                                    await ref
                                        .read(customerListProvider.notifier)
                                        .removeForID(listWhereIndex(
                                                customersList,
                                                indexList: selectedElements)
                                            .map(
                                          (e) {
                                            final entity = e as CustomerEntity;

                                            return entity.id!;
                                          },
                                        ).toList());

                                    ref
                                        .read(selectedElementIndexListProvider
                                            .notifier)
                                        .state = [];

                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Confirmar",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ],
                          );
                        },
                      );
                    },
                    child: const Icon(Icons.delete)),
              ),
          ],
        ),
        body: customersList.isEmpty
            ? const Center(child: const CircularProgressIndicator())
            : ListView.builder(
                itemCount: customersList.length,
                itemBuilder: (BuildContext context, int index) {
                  return SelectableWidget(
                      index: index,
                      child: _RegisterCustomerWidget(customersList[index]));
                },
              ),
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
                    "Días restantes: ${entity.availablesDays}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("Desde: ${dateTimeFormat(entity.creationDate!)}")
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
              SizedBox(
                height: size.height * 0.007,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () async {
                      await Share.shareXFiles(
                          [XFile((entity.qrCodeImage as FileImage).file.path)]);
                    },
                    child: const Icon(
                      Icons.share,
                    ),
                  ),
                  const Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: InkWell(
                      child: Icon(
                        Icons.download,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      )),
    );
  }
}
