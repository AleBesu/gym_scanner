DateTime getMiddleOfMonth(DateTime dateTimeToCalculate) {
  return DateTime(
      dateTimeToCalculate.year,
      dateTimeToCalculate.month,
      DateTime(dateTimeToCalculate.year, dateTimeToCalculate.month + 1, 0)
              .day ~/
          2);
}

DateTime getLastDayOfMonth(DateTime dateTimeToCalculate) {
  return DateTime(dateTimeToCalculate.year, dateTimeToCalculate.month + 1, 0);
}
