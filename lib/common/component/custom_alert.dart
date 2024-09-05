import 'package:flutter/material.dart';

import '../helper/constant.dart';

class CustomAlert {
  /// Show Snackbar [Global Function]
  static void showSnackBar(
    BuildContext context,
    String text,
    bool isError, {
    SnackBarAction? action,
  Duration? duration,
    Color? color,
  }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    final snackBar = SnackBar(
      backgroundColor: (isError) ? Colors.red : color ?? Constant.primaryColor,
      margin: const EdgeInsets.all(22),
      action: action,
      duration: duration ?? const Duration(seconds: 2),
      content: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      behavior: SnackBarBehavior.floating,
    );
    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
