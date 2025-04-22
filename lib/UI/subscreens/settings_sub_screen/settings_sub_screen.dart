import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/Providers/Statitics/casual_user_payment_statitics_provider.dart';
import 'package:gym_scanner/UI/Providers/theme_is_dark_provider.dart';
import 'package:gym_scanner/UI/subscreens/settings_sub_screen/dialogs/show_question_if_reset_statitic.dart';
import 'package:gym_scanner/core/export_import/export_database.dart';
import 'package:gym_scanner/core/export_import/import_database.dart';
import 'package:gym_scanner/data/local/customers_database.dart';

class SettingsSubScreen extends ConsumerWidget {
  const SettingsSubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
                style: const ButtonStyle(
                    foregroundColor: WidgetStatePropertyAll(Colors.white)),
                onPressed: () async {
                  importDatabase(context, localDatabaseName);
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Importar base de datos"),
                    Icon(Icons.file_download)
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
                style: const ButtonStyle(
                    foregroundColor: WidgetStatePropertyAll(Colors.white)),
                onPressed: () async {
                  exportDataBase(localDatabaseName);
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Exportar base de datos"),
                    Icon(Icons.upload)
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
                style: const ButtonStyle(
                    foregroundColor: WidgetStatePropertyAll(Colors.white)),
                onPressed: () async {
                  await showQuestionIfResetStatitics(context, ref);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Reiniciar estadisticas"),
                    Icon(Icons.refresh)
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class settingsSubScreenAppbar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const settingsSubScreenAppbar({super.key});

  @override
  ConsumerState<settingsSubScreenAppbar> createState() =>
      _settingsSubScreenAppbarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _settingsSubScreenAppbarState
    extends ConsumerState<settingsSubScreenAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "Administrar",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        // Padding(
        //   padding: const EdgeInsets.all(20),
        //   child:
        //   InkWell(
        //       onTap: () {
        //         ref.read(themeIsDarkProvider.notifier).update(
        //               (state) => !state,
        //             );
        //       },
        //       child: Icon(ref.watch(themeIsDarkProvider)
        //           ? Icons.dark_mode
        //           : Icons.light_mode)

        //           ),
        // )
      ],
    );
  }
}
