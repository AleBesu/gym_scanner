import 'dart:convert';

import 'package:gym_scanner/domain/casual_user.dart';
import 'package:gym_scanner/domain/customer_entity.dart';
import 'package:sqflite/sqflite.dart';

class CustomersDatabase {
  static CustomersDatabase instance = CustomersDatabase._private();
  final String _table = "customers";
  final String _casualsCustomersStatisticsTable = "casualsCustomersStatistics";
  final String _usualCustomerStaticsTable = 'usualCustomerStaticsTable';
  final String _datesRegistersTable = 'datesRegistersTable';
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
      CREATE TABLE $_casualsCustomersStatisticsTable( id INTEGER PRIMARY KEY AUTOINCREMENT ,casualCustomerListJSON TEXT)

''');
        db.execute('''
       CREATE TABLE $_usualCustomerStaticsTable(
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       yearWithMonthsWithUsers TEXT
       
       
       
       )





''');

        db.execute('''
CREATE TABLE startDateTable (
startTimeDate TEXT




)




''');
        db.execute('''
CREATE TABLE datesRegistersTable(
lastDateRegitred TEXT


) 



''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> getUsualCustomersList() async {
    final db = await database;
    // db.delete(_table);
    return await db.query(
      "customers",
      orderBy: "id DESC",
    );
  }

  Future<void> addUsualCustomer(UsualCustomerEntity entity) async {
    final db = await database;

    await db.insert("customers", entity.toMap());
  }

  Future<void> deleteUsualCustomer(List<int> elementsToDeleteID) async {
    final db = await database;

    for (int id in elementsToDeleteID) {
      await db.delete(_table, where: "id = ?", whereArgs: [id]);
    }
  }

  Future<void> addUsualCustomerStatitic(
      UsualCustomerEntity usualCustomerEntity) async {
    _fillMonthsWithoutRegister();
    final db = await database;
    final usualUserStatiticsTable = await db.query(_usualCustomerStaticsTable);

    List<List<List<UsualCustomerEntity>>> usualUserStatitics =
        await getUsualCustomerStatitics();
    final usualUserStatiticsMaps = usualUserStatitics.map(
      (year) {
        return year.map(
          (month) {
            return month
                .map(
                  (e) => e.toMap(),
                )
                .toList();
          },
        ).toList();
      },
    ).toList();
    usualUserStatiticsMaps.last.last.add(usualCustomerEntity.toMap());

    db.update(_usualCustomerStaticsTable,
        {'yearWithMonthsWithUsers': jsonEncode(usualUserStatiticsMaps.last)},
        where: 'id = ?', whereArgs: [usualUserStatiticsTable.last["id"]]);
  }

  Future<void> addCasualCustomerStatitic(CasualCustomer newCasualUser) async {
    _fillDaysWithOutRegister();
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

  Future<List<List<List<UsualCustomerEntity>>>>
      getUsualCustomerStatitics() async {
    _fillMonthsWithoutRegister();
    final db = await database;
    final usualUserStatitics = await db.query(_usualCustomerStaticsTable);
    // print(usualUserStatitics);
    return usualUserStatitics.map(
      (e) {
        List year = jsonDecode(e['yearWithMonthsWithUsers'].toString()) as List;

        return year.map(
          (month) {
            return (month as List).map(
              (e) {
                print(e);
                return UsualCustomerEntity.fromMap(
                    Map<String, dynamic>.from(e));
              },
            ).toList();
          },
        ).toList();
      },
    ).toList();
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
              (casualUserJson) => CasualCustomer.fromJson(casualUserJson),
            )
            .toList();
      },
    ).toList();
  }

  Future<void> _fillMonthsWithoutRegister() async {
    final db = await database;
    final datesRegistersTable = await db.query(_datesRegistersTable);
    final usualCustomerStaticsTab =
        await db.query(_casualsCustomersStatisticsTable);

    if (datesRegistersTable.isEmpty) {
      await db.insert(_datesRegistersTable,
          {'lastDateRegitred': DateTime.now().toIso8601String()});
    }

    if (DateTime.tryParse(
            datesRegistersTable[0]['lastDateRegitred'].toString()) !=
        null) {
      final lastDateRegitred =
          DateTime.parse(datesRegistersTable[0]['lastDateRegitred'].toString());

      if ((await db.query(_usualCustomerStaticsTable)).isEmpty) {
        await db.insert(_usualCustomerStaticsTable, {
          'yearWithMonthsWithUsers': jsonEncode([[]])
        });
      }

      if (DateTime.now().month > lastDateRegitred.month ||
          DateTime.now().year > lastDateRegitred.year) {
        final timeToAdd = (DateTime.now().year - lastDateRegitred.year) * 12 +
            (DateTime.now().month - lastDateRegitred.month);

        for (int i = 0; i < timeToAdd; i++) {
          // monthsListWithUsualCustomerLists

          db.insert(_usualCustomerStaticsTable, {
            'yearWithMonthsWithUsers': jsonEncode([[]])
          });
        }
      }
    } else {
      throw ('lastMonth cannot be null');
    }
  }

  Future<void> _fillDaysWithOutRegister() async {
    final db = await database;

    final casualUserTable = await db.query(
      _casualsCustomersStatisticsTable,
    );
    final importanDatesTable = await db.query('startDateTable');

    if (casualUserTable.length <
        DateTime.now()
                .difference(DateTime.parse(
                    importanDatesTable[0]['startTimeDate'].toString()))
                .inDays +
            1) {
      ///////////////////////////////////
      int diasSinRegistrar = DateTime.now()
              .difference(DateTime.parse(
                  importanDatesTable[0]['startTimeDate'].toString()))
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
