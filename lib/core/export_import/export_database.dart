import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:gym_scanner/core/get_random_string.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

Future<void> exportDataBase(String dataBaseName) async {
  String databasePath = join(await getDatabasesPath(), dataBaseName);
  File originalDatabase = File(databasePath);

  if (!await originalDatabase.exists()) {
    throw Exception("🔴 Error: La base de datos no existe");
  }

  // Directory? exportDirecty = await getDownloadsDirectory();

  // File originalDatabse = File(databasePath);

  // if (exportDirecty != null) {
  //   String exportPath = join(exportDirecty.path, "gym_core.db");
  //   await originalDatabse.copy(exportPath);
  // }

  await FilePicker.platform.saveFile(
      dialogTitle: "Exportar Base de Datos",
      fileName: 'register_gym ${getRandomString(lenght: 8)}.db',
      type: FileType.custom,
      bytes: await originalDatabase.readAsBytes(),
      allowedExtensions: ["db"]);
}
