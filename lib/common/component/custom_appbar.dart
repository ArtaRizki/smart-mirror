import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helper/constant.dart';

class CustomAppBar {
  /// custom appbar
  static AppBar appBar(
    BuildContext context,
    String title, {
    List<Widget>? action,
    Color? color,
    Color? foregroundColor,
    PreferredSizeWidget? bottom,
    TextStyle? textStyle,
    ShapeBorder? border,
    IconThemeData? iconThemeData,
    bool isLeading = true,
    bool isCenter = false,
    double? titleSpacing,
    Widget? flexibleSpace,
    Widget? leading,
    Function()? onBack,
  }) {
    return AppBar(
      leading: isLeading
          ? leading ??
              IconButton(
                  onPressed: onBack ?? () => Navigator.pop(context),
                  icon: const Icon(Icons.keyboard_arrow_left))
          : null,
      title: Text(
        title,
        style: textStyle ??
            TextStyle(
              fontWeight: Constant.semibold,
              color: foregroundColor ?? Colors.black,
              fontSize: 17,
            ),
      ),
      flexibleSpace: flexibleSpace,
      iconTheme: iconThemeData,
      titleSpacing: titleSpacing ?? 0,
      shape: border,
      elevation: 0,
      backgroundColor: color ?? Colors.white,
      foregroundColor: foregroundColor ?? Colors.black,
      surfaceTintColor: color ?? Colors.white,
      bottom: bottom,
      automaticallyImplyLeading: isLeading,
      centerTitle: isCenter,
      actions: action,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Constant.primaryColor,
        systemNavigationBarColor: Constant.primaryColor,
        systemNavigationBarDividerColor: Constant.primaryColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  static PreferredSizeWidget searchAppBar(
    BuildContext context,
    Widget title, {
    List<Widget>? action,
    Color? color,
    Color? foregroundColor,
    PreferredSizeWidget? bottom,
    TextStyle? textStyle,
    ShapeBorder? border,
    IconThemeData? iconThemeData,
    bool isLeading = true,
    bool isCenter = false,
    double? titleSpacing,
    Widget? flexibleSpace,
    Widget? leading,
  }) {
    return AppBar(
      leading: isLeading
          ? leading ??
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.keyboard_arrow_left))
          : null,
      title: title,
      flexibleSpace: flexibleSpace,
      iconTheme: iconThemeData,
      titleSpacing: titleSpacing ?? 0,
      shape: border,
      elevation: 0,
      backgroundColor: color ?? Colors.white,
      foregroundColor: foregroundColor ?? Colors.black,
      bottom: bottom,
      automaticallyImplyLeading: isLeading,
      centerTitle: isCenter,
      actions: action,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness:
            Brightness.dark, //<-- For Android SEE HERE (dark icons)
        statusBarBrightness:
            Brightness.dark, //<-- For iOS SEE HERE (dark icons)
      ),
    );
  }
}
