import 'package:flutter/material.dart';

void showImage(BuildContext context,
    {required ImageProvider image, bool background = false}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Image(
          image: image,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.none,
        ),
      );
    },
  );
}
