import 'dart:io';

import 'package:flutter/material.dart';

class UsualCustomerEntity {
  int? id;
  String name;
  ImageProvider? userImage;
  ImageProvider? qrCodeImage;
  DateTime? creationDate;
  DateTime? lastPayment;
  DateTime? expiratioDate;
  DateTime? lastAccessDateTime;

  UsualCustomerEntity(this.name,
      {required this.userImage,
      this.qrCodeImage,
      this.id,
      this.lastPayment,
      this.creationDate,
      this.expiratioDate,
      this.lastAccessDateTime}) {}

  int get availablesDays {
    return expiratioDate!.difference(DateTime.now()).inDays + 1;
  }

  factory UsualCustomerEntity.fromMap(Map<String, dynamic> map) {
    return UsualCustomerEntity(
      map["name"],
      id: map["id"],
      userImage: _getImage(map["userImagePath"]),
      qrCodeImage: _getImage(map["qrCodeImagePath"]),
      creationDate: DateTime.parse(map["creationDate"]),
      lastPayment: DateTime.parse(map["lastPayment"]),
      expiratioDate: DateTime.parse(map["expiratioDate"]),
      lastAccessDateTime: DateTime.parse(map['lastAccessDateTime']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "userImagePath": _setImage(userImage!),
      "qrCodeImagePath": _setImage(qrCodeImage!),
      "creationDate": creationDate!.toIso8601String(),
      "lastPayment": lastPayment!.toIso8601String(),
      "expiratioDate": expiratioDate!.toIso8601String(),
      'lastAccessDateTime': lastAccessDateTime!.toIso8601String(),
    };
  }

  String _setImage(ImageProvider imageProvider) {
    if (imageProvider is AssetImage) {
      return "asset/${imageProvider.assetName}";
    }

    return "file/${(imageProvider as FileImage).file.path}";
  }
}

///////////////////////////////////////////////////
ImageProvider _getImage(String userImageInfo) {
  if (userImageInfo.contains("asset/")) {
    userImageInfo = userImageInfo.replaceFirst("asset/", "");
    return AssetImage(userImageInfo);
  }
  userImageInfo = userImageInfo.replaceFirst("file/", "");
  return FileImage(File(userImageInfo));
}
