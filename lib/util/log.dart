import 'package:logger/logger.dart';

class Log{

  static Logger logger = Logger();

  static void i(String tag, String msg){
    logger.i("$tag $msg");
  }

  static void w(String tag, String msg){
    logger.w("$tag $msg");
  }

  static void e(String tag, String msg){
    logger.e("$tag $msg");
  }
}