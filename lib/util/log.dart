import 'package:logger/logger.dart';

class Log{
  static final logger = Logger(
     printer: PrettyPrinter(
      dateTimeFormat: DateTimeFormat.dateAndTime
    )
  );
  

  static void i(String tag, String msg){
    logger.i("$tag $msg", stackTrace: StackTrace.empty);
  }

  static void w(String tag, String msg){
    logger.w("$tag $msg", stackTrace: StackTrace.empty);
  }

  static void e(String tag, String msg){
    logger.e("$tag $msg", stackTrace: StackTrace.empty);
  }
}