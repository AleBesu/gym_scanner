import 'dart:convert';

String getEncriptedValue(String rawCode) {
  List<int> listaDeCodes = List<int>.from(jsonDecode(rawCode));

  return String.fromCharCodes(listaDeCodes);
}
