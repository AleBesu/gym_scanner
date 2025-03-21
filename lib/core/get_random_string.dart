import 'dart:ffi';
import 'dart:math';

String getRandomString({required int lenght}) {
  String alphabetLowCase =
      "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
  List<String> letterList = [];
  for (var i = 0; i < lenght; i++) {
    letterList.add(alphabetLowCase[
        Random().nextInt(alphabetLowCase.split("").length - 1)]);
  }

  return letterList.join();
}
