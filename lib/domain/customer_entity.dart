import 'package:flutter/material.dart';

class CustomerEntity {
  int? id;
  String name;
  ImageProvider? userImage;
  ImageProvider? qrCodeImage;
  DateTime? creationDate;
  DateTime? lastPayment;
  DateTime? expiratioDate;

  CustomerEntity(this.name,
      {this.userImage,
      this.qrCodeImage,
      this.id,
      this.creationDate,
      this.expiratioDate});

  int get availablesDays {
    return expiratioDate!.difference(DateTime.now()).inDays + 1;
  }
}
