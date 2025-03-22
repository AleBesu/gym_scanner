import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:gym_scanner/UI/subscreens/register_subscreen/sub_screen_registers_(scanner).dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  String texto = "valor vacio";

  List<Widget> bodyList = [const SubScreenRegisters()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gym App"),
      ),
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
