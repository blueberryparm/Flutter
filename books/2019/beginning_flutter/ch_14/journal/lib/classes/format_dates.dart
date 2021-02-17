import 'package:intl/intl.dart';

class FormatDates {
  String dateFormatShortMonthDayYear(String date) => DateFormat.yMMMEd().format(
        DateTime.parse(date),
      );

  String dateFormatDayNumber(String date) => DateFormat.d().format(
        DateTime.parse(date),
      );

  String dateFormatShortDayName(String date) => DateFormat.E().format(
        DateTime.parse(date),
      );
}
