class DateTimeHelper {
  static String calculateTimeDifference(DateTime start, DateTime end) {
    Duration difference = end.difference(start);

    // Calculate days, hours, minutes, and seconds
    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    int seconds = difference.inSeconds % 60;

    if (difference.inSeconds < 60) {
      return '$seconds seconds';
    } else if (difference.inSeconds < 3600) {
      return '$minutes minutes';
    } else if (difference.inSeconds < 86400) {
      return '$hours hours';
    } else {
      return '$days days';
    }
  }
}