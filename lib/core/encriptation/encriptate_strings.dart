String encriptateStrings(List<String> stringsToEncript) {
  return stringsToEncript.map(
    (e) {
      return e.codeUnits.toString();
    },
  ).reduce(
    (a, b) => a + b,
  );
}
