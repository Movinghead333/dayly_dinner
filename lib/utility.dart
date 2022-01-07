class Utility {
  static String getCurrentDateAsString() {
    DateTime now = DateTime.now();
    return '${now.day}.${now.month}.${now.year}';
  }
}
