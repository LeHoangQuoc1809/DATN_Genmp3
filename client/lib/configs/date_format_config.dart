import 'package:intl/intl.dart';

class DateFormatConfig {
  static DateFormat outputFormatDisplay = DateFormat('dd/MM/yyyy - HH:mm:ss a');
  static DateFormat outputFormatDisplayNoTime = DateFormat('dd/MM/yyyy');

  static DateFormat outputFormatApi = DateFormat('yyyy-MM-dd HH:mm:ss');

  static DateFormat inputFormat = DateFormat('dd-MM-yyyy');

  static String DateFormatForDisplay(String strDateTime) {
    // Parse the string to DateTime
    DateTime dateTime = DateTime.parse(strDateTime);

    String formattedDate = outputFormatDisplay.format(dateTime);

    return formattedDate;
  }

  static String DateFormatForDisplayNoTime(String strDateTime) {
    // Parse the string to DateTime
    DateTime dateTime = DateTime.parse(strDateTime);

    String formattedDate = outputFormatDisplayNoTime.format(dateTime);

    return formattedDate;
  }

  static DateTime DateFormatForCreateUser(String strDateTime) {
    // Parse the string to DateTime
    DateTime dateTime = inputFormat.parseStrict(strDateTime);
    return dateTime;
  }

  static DateTime DateFormatForUserResponse(String strDateTime) {
    // Parse the string to DateTime
    DateTime dateTime = DateTime.parse(strDateTime);
    return dateTime;
  }
}
