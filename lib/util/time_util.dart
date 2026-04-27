class TimeUtil {
  // String formatted = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  static int currentTimeMills(){
    return DateTime.now().millisecond;
  }

  static DateTime currentTime() {
    return DateTime.now();
  }
}