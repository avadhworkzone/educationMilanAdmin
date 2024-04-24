import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/color_utils.dart';

class ToastUtils {
  static void showCustomToast({
    required BuildContext context,
    required String title,
    ToastGravity gravity = ToastGravity.BOTTOM,
    int timeInSecForIosWeb = 1,
    Color textColor = ColorUtils.white,
    double fontSize = 16.0,
    Color backgroundColor = ColorUtils.purple93,
  }) {
    Fluttertoast.showToast(
      msg: title,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: timeInSecForIosWeb,
      textColor: textColor,
      fontSize: fontSize,
      backgroundColor: backgroundColor,
    );
  }
}
