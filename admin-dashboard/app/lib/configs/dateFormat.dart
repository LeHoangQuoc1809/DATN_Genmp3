import 'package:intl/intl.dart';

class DateFormatConfig {
  static DateFormat outputFormatDisplay = DateFormat('dd/MM/yyyy - HH:mm:ss a');

  static DateFormat outputFormatApi = DateFormat('yyyy-MM-dd HH:mm:ss');

  static String DateFormatForDisplay(String strDateTime) {
    // Parse the string to DateTime
    DateTime dateTime = DateTime.parse(strDateTime);

    String formattedDate = outputFormatDisplay.format(dateTime);

    return formattedDate;
  }
}
