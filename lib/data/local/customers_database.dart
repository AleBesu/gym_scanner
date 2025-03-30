import 'package:gym_scanner/domain/customer_entity.dart';
import 'package:sqflite/sqflite.dart';

class CustomersDatabase {
  static CustomersDatabase instance = CustomersDatabase._private();
  final String _table = "customers";
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
          "CREATE TABLE $_table (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,userImagePath TEXT,qrCodeImagePath TEXT ,creationDate TEXT,lastPayment TEXT,expiratioDate TEXT)",
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> getElements() async {
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

  Future<void> deleteElements(List<int> elementsToDeleteID) async {
    final db = await database;

    for (int id in elementsToDeleteID) {
      await db.delete(_table, where: "id = ?", whereArgs: [id]);
    }
  }
}
