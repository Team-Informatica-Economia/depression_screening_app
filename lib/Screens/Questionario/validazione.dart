class Validazione {

  bool isValid(String value) {
    final regex = RegExp("^[A-Za-z' ]{3,}\$");
    final matches = regex.allMatches(value);
    for (Match match in matches) {
      if (match.start == 0 && match.end == value.length) {
        return true;
      }
    }
    return false;

  }
}