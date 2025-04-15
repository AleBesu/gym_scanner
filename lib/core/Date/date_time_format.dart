String dateTimeFormatDayMonthYear(DateTime dateTime) {
  return "${dateTime.day}-${dateTime.month}-${dateTime.year}";
}

String dateTimeFormatHourDayMonth(DateTime dateTime) {
  int hourformat12h = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;

  return " ${hourformat12h}:${dateTime.minute < 10 ? 0.toString() + dateTime.minute.toString() : dateTime.minute}${dateTime.hour >= 12 ? 'PM' : 'AM'} ${dateTime.day}-${dateTime.month}-${dateTime.year}";
}

String dateTimeFormatOnlyHourAndMinutes(DateTime dateTime) {
  int hourformat12h = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;

  return " ${hourformat12h}:${dateTime.minute < 10 ? 0.toString() + dateTime.minute.toString() : dateTime.minute}${dateTime.hour >= 12 ? 'PM' : 'AM'}";
}
