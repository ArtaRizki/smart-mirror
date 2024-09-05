import 'package:flutter/material.dart';

import '../helper/constant.dart';

class CustomDialog {
  static Future woFormDialog(
      {required BuildContext context,
        required String title,
        bool dismissable = false,
        required Widget logPopUp}) {
    return showDialog(
      context: context,
      barrierDismissible: dismissable,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => dismissable,
          child: AlertDialog(
            title: Text(title,
                style: Constant.iPrimaryMedium8.copyWith(fontSize: 16)),
            content: logPopUp,
          ),
        );
      },
    );
  }

  static Future mainDialog(
      {required BuildContext context,
        required String title,
        bool dismissable = false,
        required Widget content}) {
    return showDialog(
      context: context,
      barrierDismissible: dismissable,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => dismissable,
          child: AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            title: Text(
              title,
              style: Constant.iPrimaryMedium8.copyWith(fontSize: 16),
            ),
            content: content,
          ),
        );
      },
    );
  }

  static Future newDialog(
      {required BuildContext context,
        required Widget title,
        EdgeInsets? contentPadding,
        EdgeInsets? titlePadding,
        Color? barrierColor,
        bool dismissable = false,
        required Widget content}) {
    return showDialog(
      context: context,
      barrierDismissible: dismissable,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => dismissable,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: contentPadding,
            backgroundColor: Color(0xFF845647).withOpacity(0.3),
            titlePadding: titlePadding,
            title: title,
            content: content,
          ),
        );
      },
    );
  }
}
