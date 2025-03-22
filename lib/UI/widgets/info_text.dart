import 'package:flutter/material.dart';

class InfoText extends StatelessWidget {
  String info, value;

  InfoText({super.key, required this.info, this.value = ""});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        text: TextSpan(text: "$info: ", children: [
          TextSpan(
              text: value, style: const TextStyle(fontWeight: FontWeight.bold))
        ]),
      ),
    );
  }
}
