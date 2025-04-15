import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/Providers/usual_customers_list_provider.dart';
import 'package:gym_scanner/UI/main_screen.dart';
import 'package:gym_scanner/data/local/customers_database.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ref.read(usualCustomerListProvider.notifier).loadInfoFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    savedStartDateTime();

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        title: 'Core GYM',
        home: const MainScreen());
  }

  Future<void> loadData(WidgetRef ref) async {
    await ref.read(usualCustomerListProvider.notifier).loadInfoFromDatabase();
  }

  Future<void> savedStartDateTime() async {
    CustomersDatabase customersDatabase = CustomersDatabase.instance;
    final db = await customersDatabase.database;

    final importanDatesTable = await db.query('startDateTable');
    if (importanDatesTable.isEmpty) {
      await db.insert("startDateTable", {
        "startTimeDate": DateTime.now().toIso8601String(),
      });
    }
  }
}
