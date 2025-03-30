import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/subscreens/finance_subscreen/subscreen_finance.dart';
import 'dart:ui' as ui;
import 'package:gym_scanner/UI/subscreens/register_subscreen/sub_screen_registers_(scanner).dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  
  int currentIndex = 0;
  String texto = "valor vacio";

  List<Widget> bodyList = [const SubScreenRegisters(), const SubScreenFinance()];
  List<AppBar> appBarList = [
    AppBar(),
    AppBar(),
    AppBar(
      actions: [InkWell(
         onTap: () {
           
         },
        
        child: const Icon(Icons.dark_mode))],
    )
  ];
  @override
  Widget build(BuildContext context) {
       


    return Scaffold(
      appBar: appBarList[currentIndex],
      body: currentIndex <= bodyList.length - 1
          ? bodyList[currentIndex]
          : const Center(
              child: Text("Pantalla vacia"),
            ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.support_agent,
              ),
              label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
        ],
      ),
    );
  }
}
