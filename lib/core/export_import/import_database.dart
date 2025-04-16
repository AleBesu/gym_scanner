import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gym_scanner/data/local/customers_database.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<void> importDatabase(BuildContext context, String databaseName) async {
  final result = await FilePicker.platform.pickFiles(
    dialogTitle: 'Importa la base de datos',
    // type: FileType.custom,
    // allowedExtensions: ['mp3'],
  );

  if (result != null) {
    //check if extension is correct and finish if not is
    if (result.files.first.extension != 'db') {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Extension incorrecta seleccione archivos con la extension db ",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
      return;
    }

    // final pickedDatabaseBytes = result.files.first.bytes;
    final pickedDatabaseFile = File(result.files.first.path!);

    //check if bytes of file is not null
    if (pickedDatabaseFile != null) {
      CustomersDatabase.instance.close();

      await File(join(await getDatabasesPath(), databaseName))
          .writeAsBytes(awai pickedDatabaseFile.readAsBytes());
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Base de datos inválida",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
    }
  }
}
