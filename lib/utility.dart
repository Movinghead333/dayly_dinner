import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Utility {
  static String getCurrentDateAsString() {
    DateTime now = DateTime.now();
    return '${now.day}.${now.month}.${now.year}';
  }

  static DateTime? parseStringDateToDateTime(String dateString) {
    try {
      return DateFormat('dd.MM.yyyy').parseStrict(dateString);
    } on FormatException {
      return null;
    }
  }

  static String parseDateTimeToGerDateString(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  /// Shows a toast message with set parameters and [message] as text.
  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xFF9E9E9E),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
