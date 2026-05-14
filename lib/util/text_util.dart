class TextUtil {
  static RegExp validPattern = RegExp(r'^[a-zA-Z0-9_]+$');

  static bool isEmpty(String? str){
    if(str == null){
      return true;
    }
    return str.trim().isEmpty;
  }

  static bool isNotEmpty(String? str) => !isEmpty(str);

  static bool isValidString(String input) {
    if (input.isEmpty) {
      return false;
    }
    return validPattern.hasMatch(input);
  }
}



