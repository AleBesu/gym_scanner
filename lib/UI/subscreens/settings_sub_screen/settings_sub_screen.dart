import 'package:flutter/material.dart';
import 'package:gym_scanner/core/export_import/export_database.dart';
import 'package:gym_scanner/core/export_import/import_database.dart';
import 'package:gym_scanner/data/local/customers_database.dart';

class SettingsSubScreen extends StatelessWidget {
  const SettingsSubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
                style: ButtonStyle(
                    foregroundColor: WidgetStatePropertyAll(Colors.white)),
                onPressed: () async {
                  exportDataBase(localDatabaseName);
                },
                child: Text("Exportar base de datos")),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: OutlinedButton(
                style: ButtonStyle(
                    foregroundColor: WidgetStatePropertyAll(Colors.white)),
                onPressed: () async {
                  importDatabase(context, localDatabaseName);
                },
                child: Text("Importar base de datos")),
          ),
        ],
      ),
    );
  }
}
