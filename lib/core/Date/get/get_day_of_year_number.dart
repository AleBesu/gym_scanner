int getDayOfYearNumber(DateTime dateTimeToCalculate) {
  return dateTimeToCalculate
      .difference(DateTime(dateTimeToCalculate.year))
      .inDays;
}
