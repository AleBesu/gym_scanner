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
        //the estructore of  _casualsCustomersStatisticsTable  is A List(table or too all years) with lists(each year) of lists of casualCustomer//
        db.execute('''
      CREATE TABLE $_casualsCustomersStatisticsTable( id INTEGER PRIMARY KEY AUTOINCREMENT ,ListOfcasualCustomerListJSON TEXT)

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

  Future<void> addUsualCustomerStatitic(UsualCustomerEntity usualCustomerEntity,
      {required int toAddMonthNumber}) async {
    await _fillMonthsWithoutRegister();
    final db = await database;
    final usualUserStatiticsTable = await db.query(_usualCustomerStaticsTable);

    List<List<List<UsualCustomerEntity>>> usualUserStatitics =
        await getUsualCustomerStatitics();

    //convert UsualCustomerStatitics in format for Introduce to database
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
    //for add the customer to selected Month,
    // toAddMonthNumber -1 because the number month format in DateTime.noew start in 1 but database start in 0
    usualUserStatiticsMaps.last[toAddMonthNumber - 1]
        .add(usualCustomerEntity.toMap());

    db.update(_usualCustomerStaticsTable,
        {'yearWithMonthsWithUsers': jsonEncode(usualUserStatiticsMaps.last)},
        where: 'id = ?', whereArgs: [usualUserStatiticsTable.last["id"]]);
  }

  Future<List<List<List<UsualCustomerEntity>>>>
      getUsualCustomerStatitics() async {
    await _fillMonthsWithoutRegister();
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
                return UsualCustomerEntity.fromMap(
                    Map<String, dynamic>.from(e));
              },
            ).toList();
          },
        ).toList();
      },
    ).toList();
  }

///////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

  Future<void> addCasualCustomerStatitic(CasualCustomer newCasualUser) async {
    await _fillDaysWithOutRegister();
    final db = await database;
    final casualUserTable = await db.query(
      _casualsCustomersStatisticsTable,
    );
    final yearList = await getCasualCustomerStatitics();
    List<CasualCustomer> lastDay = yearList.last.last;
    List<List<Map<String, dynamic>>> savedDaysOfLastYear = yearList.last
        .map(
          (day) => day
              .map(
                (casualCustomer) => casualCustomer.toMap(),
              )
              .toList(),
        )
        .toList();
    // lastDay.add(newCasualUser);
    final lastDayMaps = lastDay
        .map(
          (e) => e.toMap(),
        )
        .toList();

    // List<int> idList = await _getDaysIDList();
    savedDaysOfLastYear.last = [...lastDayMaps, newCasualUser.toMap()];
    db.update(
        _casualsCustomersStatisticsTable,
        {
          "ListOfcasualCustomerListJSON": jsonEncode(
            savedDaysOfLastYear,
          )
        },
        where: "id = ?",
        whereArgs: [casualUserTable.last["id"] as int]);
  }

  Future<List<List<List<CasualCustomer>>>> getCasualCustomerStatitics() async {
    final db = await database;

    await _fillDaysWithOutRegister();

    final casualUserTable = await db.query(
      _casualsCustomersStatisticsTable,
    );

    return casualUserTable.map(
      (year) {
        return (jsonDecode(year['ListOfcasualCustomerListJSON'].toString())
                as List)
            .toList()
            .map(
          (day) {
            return (day as List)
                .map(
                  (json) =>
                      CasualCustomer.fromJson(json as Map<String, dynamic>),
                )
                .toList();
          },
        ).toList();
      },
    ).toList();

    // List<String> diaryStaticsUserList = casualUserTable
    //     .map(
    //       (e) => e["casualCustomerListJSON"].toString(),
    //     )
    //     .toList();

    // return diaryStaticsUserList.map(
    //   (dayList) {
    //     return (jsonDecode(dayList) as List)
    //         .map(
    //           (casualUserJson) => CasualCustomer.fromJson(casualUserJson),
    //         )
    //         .toList();
    //   },
    // ).toList();
  }

  Future<void> _fillDaysWithOutRegister() async {
    final db = await database;

    List<Map<String, Object?>> casualUserTableValues = await db.query(
      _casualsCustomersStatisticsTable,
    );
    final importanDatesTable = await db.query('startDateTable');
    if (casualUserTableValues.isEmpty) {
      await db.insert(_casualsCustomersStatisticsTable, {
        'ListOfcasualCustomerListJSON': jsonEncode([[]])
      });
      casualUserTableValues = await db.query(
        _casualsCustomersStatisticsTable,
      );
    }
    List<Map<String, Object?>> datesRegistersTable =
        await db.query(_datesRegistersTable);
    final lastDateRegister =
        DateTime.parse(datesRegistersTable.last['lastDateRegitred'].toString());
    final daysWithoutRegistrer =
        DateTime.now().difference(lastDateRegister).inDays;

    if (DateTime.now().year > lastDateRegister.year) {
      db.insert(_casualsCustomersStatisticsTable, {
        'ListOfcasualCustomerListJSON': jsonEncode([[]])
      });
    }

    List<List<Map<String, dynamic>>> yearWithDaysListRegitred =
        casualUserTableValues.isNotEmpty
            ? (jsonDecode(casualUserTableValues
                    .last['ListOfcasualCustomerListJSON']
                    .toString()) as List)
                .map(
                (casualCustomerList) {
                  return (casualCustomerList as List)
                      .map(
                        (casualCustomerJson) =>
                            casualCustomerJson as Map<String, dynamic>,
                      )
                      .toList();
                },
              ).toList()
            : [];

    if (daysWithoutRegistrer >= 1) {
      await db.update(
          _casualsCustomersStatisticsTable,
          {
            'ListOfcasualCustomerListJSON': jsonEncode([
              ...yearWithDaysListRegitred,
              ...List.generate(
                daysWithoutRegistrer,
                (index) => [],
              )
            ]),
          },
          where: 'id = ?',
          whereArgs: [casualUserTableValues.last['id']]);

      await db.insert(_datesRegistersTable,
          {'lastDateRegitred': DateTime.now().toIso8601String()});
    }
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<DateTime> getStartDateTime() async {
    final db = await database;
    final startDateTable = await db.query('startDateTable');
    return DateTime.parse(startDateTable[0]['startTimeDate'].toString());
  }

  Future<void> _fillMonthsWithoutRegister() async {
    final db = await database;
    List<Map<String, Object?>> datesRegistersTable =
        await db.query(_datesRegistersTable);
    if (datesRegistersTable.isEmpty) {
      await db.insert(_datesRegistersTable,
          {'lastDateRegitred': DateTime.now().toIso8601String()});
      datesRegistersTable = await db.query(_datesRegistersTable);
    }
    final lastDateRegitred =
        DateTime.parse(datesRegistersTable.last['lastDateRegitred'].toString());
    List<Map<String, Object?>> usualUserStatitics =
        await db.query(_usualCustomerStaticsTable);

    if (DateTime.now().year > lastDateRegitred.year ||
        usualUserStatitics.isEmpty) {
      await db.insert(_usualCustomerStaticsTable, {
        'yearWithMonthsWithUsers': jsonEncode([
          ...List.generate(
            12,
            (index) => [],
          )
        ])
      });
      usualUserStatitics = await db.query(_usualCustomerStaticsTable);
      await db.insert(_datesRegistersTable,
          {'lastDateRegitred': DateTime.now().toIso8601String()});
    }
  }

  // Future<List<int>> _getDaysIDList() async {
  //   final db = await database;

  //   return casualUserTable
  //       .map(
  //         (map) => map["id"] as int,
  //       )
  //       .toList();
  // }
}
