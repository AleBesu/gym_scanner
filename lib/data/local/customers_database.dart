import 'dart:convert';

import 'package:gym_scanner/domain/casual_user.dart';
import 'package:gym_scanner/domain/customer_entity.dart';
import 'package:sqflite/sqflite.dart';

class CustomersDatabase {
  static CustomersDatabase instance = CustomersDatabase._private();
  final String _table = "customers";
  final String _casualsCustomersStatisticsTable = "casualsCustomersStatistics";

  CustomersDatabase._private();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    return await getNewDataBase();
  }

  Future<Database> getNewDataBase() async {
    return openDatabase(
      "${await getDatabasesPath()}localdatase.db",
      version: 1,
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE $_table (id INTEGER NOT NULL,name TEXT,userImagePath TEXT,qrCodeImagePath TEXT ,creationDate TEXT,lastPayment TEXT,expiratioDate TEXT)",
        );

        db.execute('''
      CREATE TABLE $_casualsCustomersStatisticsTable( id INTEGER PRIMARY KEY AUTOINCREMENT ,startTimeDate TEXT,casualCustomerListJSON TEXT)
    



''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> getCustomersList() async {
    final db = await database;
    // db.delete(_table);
    return await db.query(
      "customers",
      orderBy: "id DESC",
    );
  }

  Future<void> addCustomer(CustomerEntity entity) async {
    final db = await database;

    await db.insert("customers", entity.toMap());
  }

  Future<void> deleteCustomer(List<int> elementsToDeleteID) async {
    final db = await database;

    for (int id in elementsToDeleteID) {
      await db.delete(_table, where: "id = ?", whereArgs: [id]);
    }
  }

  Future<List<List<CasualCustomer>>> getCasualCustomerStatitics() async {
    final db = await database;

    await _fillDaysWithOutRegister();

    final casualUserTable = await db.query(
      _casualsCustomersStatisticsTable,
    );
    List<String> diaryStaticsUserList = casualUserTable
        .map(
          (e) => e["casualCustomerListJSON"].toString(),
        )
        .toList();

    return diaryStaticsUserList.map(
      (dayList) {
        return (jsonDecode(dayList) as List)
            .map(
              (CasualUserJson) => CasualCustomer.fromJson(CasualUserJson),
            )
            .toList();
      },
    ).toList();
  }

  Future<void> addCasualCustomer(CasualCustomer newCasualUser) async {
    final db = await database;

    final daysList = await getCasualCustomerStatitics();
    List<CasualCustomer> lastDay = daysList.last;
    lastDay.add(newCasualUser);
    final lastDayMaps = lastDay
        .map(
          (e) => e.toMap(),
        )
        .toList();

    List<int> idList = await _getDaysIDList();

    db.update(_casualsCustomersStatisticsTable,
        {"casualCustomerListJSON": jsonEncode(lastDayMaps)},
        where: "id = ?", whereArgs: [idList.last]);
  }

  Future<void> _fillDaysWithOutRegister() async {
    final db = await database;

    final casualUserTable = await db.query(
      _casualsCustomersStatisticsTable,
    );
    print(DateTime.now()
        .difference(
            DateTime.parse(casualUserTable[0]["startTimeDate"].toString()))
        .inDays);
    if (casualUserTable.length <
        DateTime.now()
            .difference(
                DateTime.parse(casualUserTable[0]["startTimeDate"].toString()))
            .inDays) {
      ///////////////////////////////////
      int diasSinRegistrar = DateTime.now()
              .difference(DateTime.parse(
                  casualUserTable[0]["startTimeDate"].toString()))
              .inDays -
          casualUserTable.length +
          1;

      for (int i = 0; i < diasSinRegistrar; i++) {
        await db.insert(_casualsCustomersStatisticsTable,
            {"casualCustomerListJSON": jsonEncode([])});
      }
    }
  }

  Future<List<int>> _getDaysIDList() async {
    final db = await database;
    final casualUserTable = await db.query(
      _casualsCustomersStatisticsTable,
    );

    return casualUserTable
        .map(
          (map) => map["id"] as int,
        )
        .toList();
  }
}
