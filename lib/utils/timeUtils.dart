abstract class TimeUtils {
  static int getDaysBetween(DateTime start, DateTime end) {
    Duration difference = end.difference(start);
    return difference.inDays;
  }

  static getHoursBetween(DateTime start, DateTime end) {
    Duration difference = end.difference(start);
    return difference.inHours;
  }
}
