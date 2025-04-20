import 'package:flutter/material.dart';

import 'package:gym_scanner/core/get_new_qr_file.dart';

import 'package:gym_scanner/domain/usual_customer_entity.dart';

Future<ImageProvider> generateUserQrImageFile(
    UsualCustomerEntity entity) async {
  final qrCodeFile = await getNewQrCodeFile(entity.id.toString());

  if (qrCodeFile != null) {
    return FileImage(qrCodeFile);
  } else {
    throw ("qrCodeFile Is Null");
  }
}
