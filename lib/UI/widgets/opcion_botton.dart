import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  String text;
  Color backGroundColor;
  IconData? icon;
  final VoidCallback onPressed;
  OptionButton(
      {super.key,
      this.backGroundColor = Colors.white,
      this.text = "",
      this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: FilledButton(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(backGroundColor),
              iconColor: const WidgetStatePropertyAll(Colors.white),
              foregroundColor: const WidgetStatePropertyAll(Colors.white)),
          onPressed: onPressed,
          child: Stack(
            children: [
              Center(child: Text(text)),
              Align(
                alignment: Alignment.bottomLeft,
                child: Icon(icon),
              )
            ],
          )),
    );
  }
}
