class DateFormatter {
  final DateTime date;
  DateFormatter({this.date});

  String get formattedDate {
    if (date == null) {
      return '';
    }
    String year = date.year.toString();
    String month = date.month.toString();
    String day = date.day.toString();
    String hours = date.hour.toString();
    String minutes = date.minute.toString();
    String formattedDate = '$year-$month-$day / $hours:$minutes';
    return formattedDate;
  }
}
