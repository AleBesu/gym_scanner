import 'package:flutter/material.dart';
import 'package:gym_scanner/core/encriptation/encriptate_strings.dart';
import 'package:gym_scanner/core/get_new_qr_file.dart';

import 'package:gym_scanner/domain/customer_entity.dart';

Future<ImageProvider> generateUserQrImageFile(CustomerEntity entity) async {
  final qrCodeFile =
      await getNewQrCodeFile(encriptateStrings([entity.id.toString()]));

  if (qrCodeFile != null) {
    return FileImage(qrCodeFile);
  } else {
    throw ("qrCodeFile Is Null");
  }
}
