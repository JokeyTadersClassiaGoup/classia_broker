import 'package:intl/intl.dart';

String dateTimeToString(DateTime dateTime) {
  final date = DateFormat('d MMM yyyy').format(dateTime);
  final time = DateFormat('h:mm a').format(dateTime);
  String value = '$date at $time';

  return value;
}

String ipoDate(DateTime dateTime) {
  final date = DateFormat('d MMM yyyy').format(dateTime);
  return date;
}
