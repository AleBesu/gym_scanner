int getDayOfYearNumber(DateTime dateTimeToCalculate) {
  return dateTimeToCalculate
      .difference(DateTime.utc(dateTimeToCalculate.year))
      .inDays;
}

DateTime dayOfYearToDateTime(int dayOfYear) {
  return DateTime(DateTime.now().year).add(Duration(days: dayOfYear - 1));
}
