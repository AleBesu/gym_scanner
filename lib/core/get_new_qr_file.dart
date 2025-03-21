import 'dart:io';
import 'dart:math';
import 'package:gym_scanner/core/get_random_string.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr/qr.dart';

Future<File?> getNewQrCodeFile(String text) async {
  final qrcode =
      QrCode.fromData(data: text, errorCorrectLevel: QrErrorCorrectLevel.M);
  final qrImage = QrImage(qrcode);

  final image = Image(height: qrcode.moduleCount, width: qrcode.moduleCount);
  for (int x = 0; x < qrcode.moduleCount; x++) {
    for (int y = 0; y < qrcode.moduleCount; y++) {
      if (qrImage.isDark(x, y)) {
        image.setPixel(x, y, ColorUint8.rgb(0, 0, 0));
      } else {
        image.setPixel(x, y, ColorUint8.rgb(255, 255, 255)); // Blanco
      }
    }
  }

  Directory documentsDirecty = await getApplicationDocumentsDirectory();
  String fileName = String.fromCharCodes([]);
  File qrFilePng =
      File("${documentsDirecty.path}qr_code${getRandomString(lenght: 15)}.png");
  await qrFilePng.writeAsBytes(encodePng(image));

  return qrFilePng;
}
