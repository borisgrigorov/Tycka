abstract class TimeUtils {
  static int getDaysBetween(DateTime start, DateTime end) {
    Duration difference = end.difference(start);
    return difference.inDays;
  }

  static getHoursBetween(DateTime start, DateTime end) {
    Duration difference = end.difference(start);
    return difference.inHours;
  }

  static String getBetterDate(DateTime? date) {
    if (date == null) {
      return "...";
    }
    return "${date.day}/${date.month}/${date.year}, ${date.hour}:${date.minute}";
  }
}
