class TextUtil {
  static bool isEmpty(String? str){
    if(str == null){
      return true;
    }
    return str.trim().isEmpty;
  }

  static bool isNotEmpty(String? str) => !isEmpty(str);
}



