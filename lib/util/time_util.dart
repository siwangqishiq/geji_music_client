class TimeUtil {
  // String formatted = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  static int currentTimeMills(){
    return DateTime.now().millisecond;
  }

  static DateTime currentTime() {
    return DateTime.now();
  }

  static String formatDuration(int seconds) {
    if (seconds <= 0) return "00:01"; // 只兜底用

    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    if (hours > 0) {
      return "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(secs)}";
    } else {
      return "${twoDigits(minutes)}:${twoDigits(secs)}";
    }
  }
}