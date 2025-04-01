import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/main_screen.dart';
import 'package:gym_scanner/data/local/customers_database.dart';
import 'package:gym_scanner/domain/casual_user.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    loadStartTime();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        title: 'Core GYM',
        home: const MainScreen());
  }

  Future<void> loadStartTime() async {
    CustomersDatabase customersDatabase = CustomersDatabase.instance;
    final db = await customersDatabase.database;

    final casualsCustomersStatistics =
        await db.query("casualsCustomersStatistics");

    if (casualsCustomersStatistics.isEmpty) {
      await db.insert("casualsCustomersStatistics", {
        "startTimeDate": DateTime.now().toIso8601String(),
        "casualUserListJSON": jsonEncode([])
      });
    }
    // final startTimeDate = casualsCustomersStatistics[0]["startTimeDate"];

    // if (startTimeDate == null) {
    //   db.update("casualsCustomersStatistics",
    //       {"startTimeDate": DateTime.now().toIso8601String()},
    //       where: "startTimeDate = ?", whereArgs: [null]);
    // }
  }
}
