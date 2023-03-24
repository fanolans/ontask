import 'package:intl/intl.dart';

String formatDateTime(DateTime? dateTime) {
  if (dateTime == null) return '';
  var format = DateFormat('EEE, M/d/y');
  return format.format(dateTime);
}
