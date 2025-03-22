import 'dart:io';
import 'package:gym_scanner/core/get_random_string.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:qr/qr.dart';

Future<File?> getNewQrCodeFile(String text) async {
  final qrcode = QrCode.fromData(
      data: text, errorCorrectLevel: QrErrorCorrectLevel.levels.last);
  final qrImage = QrImage(qrcode);

  final image =
      img.Image(height: qrcode.moduleCount, width: qrcode.moduleCount);
  for (int x = 0; x < qrcode.moduleCount; x++) {
    for (int y = 0; y < qrcode.moduleCount; y++) {
      if (qrImage.isDark(x, y)) {
        image.setPixel(x, y, img.ColorUint8.rgb(0, 0, 0));
      } else {
        image.setPixel(x, y, img.ColorUint8.rgb(255, 255, 255)); // Blanco
      }
    }
  }
  final rescaledImage = img.copyResize(image,
      height: image.height * 20,
      width: image.width * 20,
      interpolation: img.Interpolation.nearest);
  final img.Image whiteBackGround = img.Image(
      width: (rescaledImage.width * 1.1).toInt(),
      height: (rescaledImage.height * 1.1).toInt());

  for (var x = 0; x < whiteBackGround.width; x++) {
    for (var y = 0; y < whiteBackGround.height; y++) {
      whiteBackGround.setPixel(x, y, img.ColorRgb8(255, 255, 255));
    }
  }

  Directory documentsDirecty = await getApplicationDocumentsDirectory();
  final makedImage = img.compositeImage(
    whiteBackGround,
    rescaledImage,
    dstX: (whiteBackGround.width - rescaledImage.width) ~/ 2,
    dstY: (whiteBackGround.height - rescaledImage.height) ~/ 2,
  );

  String fileName = String.fromCharCodes([]);
  File qrFilePng =
      File("${documentsDirecty.path}qr_code${getRandomString(lenght: 15)}.png");
  await qrFilePng.writeAsBytes(img.encodePng(makedImage));

  return qrFilePng;
}
