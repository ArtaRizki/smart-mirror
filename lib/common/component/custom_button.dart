import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../helper/constant.dart';

class CustomButton {
  static Widget mainButton(String text, VoidCallback onClick,
      {Color? color,
      EdgeInsetsGeometry? margin,
      bool stretched = true,
      bool enabled = true,
      EdgeInsetsGeometry? contentPadding,
      TextStyle? textStyle,
      double? fontSize,
      BorderRadiusGeometry? borderRadius}) {
    return Padding(
      padding: margin ?? EdgeInsets.all(0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(color ??
              (enabled == true ? Constant.primaryColor : Constant.grayColor)),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: borderRadius ?? BorderRadius.circular(25))),
          elevation: WidgetStateProperty.all<double>(0),
        ),
        onPressed: enabled ? onClick : null,
        child: Container(
          padding: contentPadding ?? EdgeInsets.all(16),
          alignment: stretched ? Alignment.center : null,
          child: Text(
            text,
            style: textStyle ??
                TextStyle(
                  fontWeight: Constant.medium,
                  fontSize: fontSize ?? 16,
                  color: Colors.white,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  static Widget mainButtonSpinner(
    String text,
    VoidCallback onClick, {
    Color? color,
    EdgeInsetsGeometry? margin,
    bool stretched = true,
    bool enabled = true,
    EdgeInsetsGeometry? contentPadding,
    TextStyle? textStyle,
    double? fontSize,
    BorderRadiusGeometry? borderRadius,
  }) {
    return Padding(
      padding: margin ?? EdgeInsets.all(0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(color ??
              (enabled == true ? Constant.primaryColor : Constant.grayColor)),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: borderRadius ?? BorderRadius.circular(25))),
          elevation: WidgetStateProperty.all<double>(0),
        ),
        onPressed: enabled ? onClick : null,
        child: Container(
          padding: contentPadding ?? EdgeInsets.all(16),
          alignment: stretched ? Alignment.center : null,
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: !EasyLoading.isShow
                    ? SizedBox()
                    : Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: SizedBox(
                            width: 24,
                            height: 20,
                            child: FittedBox(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    text,
                    style: textStyle ??
                        TextStyle(
                          fontWeight: Constant.medium,
                          fontSize: fontSize ?? 16,
                          color: Colors.white,
                        ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget mainButtonWithIcon(
      Widget icon, String text, VoidCallback onClick,
      {Color? color,
      EdgeInsetsGeometry? margin,
      bool stretched = true,
      EdgeInsetsGeometry? contentPadding,
      TextStyle? textStyle,
      double? fontSize,
      BorderRadiusGeometry? borderRadius}) {
    return Padding(
      padding: margin ?? EdgeInsets.all(0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.all<Color>(color ?? Constant.primaryColor),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: borderRadius ?? BorderRadius.circular(25))),
          elevation: WidgetStateProperty.all<double>(0),
        ),
        onPressed: onClick,
        child: Container(
          padding: contentPadding ?? EdgeInsets.all(16),
          alignment: stretched ? Alignment.center : null,
          child: Row(
            children: [
              icon,
              SizedBox(width: 4),
              Text(
                text,
                style: textStyle ??
                    TextStyle(
                      fontWeight: Constant.medium,
                      fontSize: fontSize ?? 16,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget smallMainButton(String text, VoidCallback onClick,
      {Color? color,
      EdgeInsetsGeometry? margin,
      bool stretched = true,
      EdgeInsetsGeometry? contentPadding,
      TextStyle? textStyle,
      double? fontSize,
      BorderRadiusGeometry? borderRadius}) {
    return Padding(
      padding: margin ?? EdgeInsets.all(0),
      child: InkWell(
        onTap: onClick,
        child: Container(
          decoration: BoxDecoration(
              color: color ?? Constant.primaryColor,
              borderRadius: borderRadius ?? BorderRadius.circular(15)),
          padding: contentPadding ?? EdgeInsets.all(16),
          alignment: stretched ? Alignment.center : null,
          child: Text(
            text,
            style: textStyle ??
                TextStyle(
                  fontWeight: Constant.medium,
                  fontSize: fontSize ?? 16,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  static Widget smallMainButtonWithIcon(
      Widget icon, String text, VoidCallback onClick,
      {Color? color,
      EdgeInsetsGeometry? margin,
      bool stretched = true,
      EdgeInsetsGeometry? contentPadding,
      TextStyle? textStyle,
      double? fontSize,
      BorderRadiusGeometry? borderRadius}) {
    return Padding(
      padding: margin ?? EdgeInsets.all(0),
      child: InkWell(
        onTap: onClick,
        child: Container(
          decoration: BoxDecoration(
              color: color ?? Constant.primaryColor,
              borderRadius: borderRadius ?? BorderRadius.circular(25)),
          padding: contentPadding ?? EdgeInsets.all(16),
          alignment: stretched ? Alignment.center : null,
          child: Row(
            children: [
              icon,
              SizedBox(width: 2),
              Text(
                text,
                style: textStyle ??
                    TextStyle(
                      fontWeight: Constant.medium,
                      fontSize: fontSize ?? 16,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget secondaryButton(String text, VoidCallback onClick,
      {EdgeInsetsGeometry? margin,
      bool stretched = true,
      double? borderWidth,
      EdgeInsetsGeometry? contentPadding,
      // EdgeInsetsGeometry? contentPadding,
      TextStyle? textStyle,
      double? fontSize,
      Color? borderColor,
      Color? textColor,
      BorderRadiusGeometry? borderRadius}) {
    return Padding(
      padding: margin ?? EdgeInsets.all(0),
      child: ElevatedButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(contentPadding ??
              EdgeInsets.symmetric(vertical: 16, horizontal: 14)),
          backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(25),
              side: BorderSide(
                  color: borderColor ?? Constant.primaryColor,
                  width: borderWidth ?? 2),
            ),
          ),
          elevation: WidgetStateProperty.all<double>(0),
        ),
        onPressed: onClick,
        child: Container(
          alignment: stretched ? Alignment.center : null,
          child: Center(
            child: Text(
              text,
              style: textStyle ??
                  TextStyle(
                    fontWeight: Constant.medium,
                    fontSize: fontSize ?? 16,
                    color: textColor ?? Constant.primaryColor,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  static Widget secondaryButtonWithicon(
    Widget icon,
    String text,
    VoidCallback onClick, {
    Color? borderColor,
    EdgeInsetsGeometry? margin,
    bool stretched = true,
    EdgeInsetsGeometry? contentPadding,
    TextStyle? textStyle,
    double? fontSize,
    double? borderWidth,
    BorderRadiusGeometry? borderRadius,
    MainAxisAlignment? mainAxisAlignment,
  }) {
    return Padding(
      padding: margin ?? EdgeInsets.all(0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(25),
              side: BorderSide(
                color: borderColor ?? Constant.primaryColor,
                width: borderWidth ?? 2,
              ),
            ),
          ),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
          elevation: WidgetStateProperty.all<double>(0),
        ),
        onPressed: onClick,
        child: Container(
          padding: contentPadding ?? EdgeInsets.all(16),
          alignment: stretched ? Alignment.center : null,
          child: Row(
            mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
            children: [
              icon,
              SizedBox(width: 4),
              Text(
                text,
                style: textStyle ??
                    TextStyle(
                      color: borderColor,
                      fontWeight: Constant.medium,
                      fontSize: fontSize ?? 16,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget secondaryButtonBlack(String text, VoidCallback onClick,
      {EdgeInsetsGeometry? margin, BorderRadiusGeometry? borderRadius}) {
    return Padding(
      padding: margin ?? EdgeInsets.all(0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(12.0),
              side: BorderSide(color: Colors.black),
            ),
          ),
          elevation: WidgetStateProperty.all<double>(0),
        ),
        onPressed: onClick,
        child: Container(
          padding: EdgeInsets.all(12),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontWeight: Constant.medium,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  static Widget logoutButton(String text, VoidCallback onClick,
      {EdgeInsetsGeometry? margin}) {
    return Padding(
      padding: margin ?? EdgeInsets.all(0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(color: Colors.red),
            ),
          ),
          elevation: WidgetStateProperty.all<double>(0),
        ),
        onPressed: onClick,
        child: Container(
          padding: EdgeInsets.all(12),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.red,
              fontWeight: Constant.medium,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  static Widget absentButton(
    String tag,
    Color color,
    VoidCallback callback,
  ) {
    return ElevatedButton(
      child: Container(
        width: 80,
        child: Text(
          tag,
          style: TextStyle(
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      onPressed: callback,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          color,
        ),
        padding: WidgetStateProperty.all<EdgeInsets>(
          EdgeInsets.only(
            right: 8,
            left: 8,
          ),
        ),
        elevation: WidgetStateProperty.all(1),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
    );
  }
}
