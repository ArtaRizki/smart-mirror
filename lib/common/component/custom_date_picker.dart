import 'package:flutter/material.dart';

import '../helper/constant.dart';

class CustomDatePicker {
  static Future<DateTime?> pickDate(
    BuildContext context,
    DateTime? date, {
    DatePickerMode? datePickerMode,
    DatePickerEntryMode? datePickerEntryMode,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      initialDatePickerMode: datePickerMode ?? DatePickerMode.day,
      initialEntryMode: datePickerEntryMode ?? DatePickerEntryMode.calendar,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2101),
      builder: (BuildContext? context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Constant.primaryColor,
            colorScheme: ColorScheme.light(primary: Constant.primaryColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != date) return picked;
    return null;
  }

  static Future<DateTime?> pickDateAndTime(
    BuildContext context,
    DateTime? date, {
    DatePickerMode? datePickerMode,
    DatePickerEntryMode? datePickerEntryMode,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    DateTime? datePicked = await pickDate(context, date,
        datePickerMode: datePickerMode,
        datePickerEntryMode: datePickerEntryMode,
        firstDate: firstDate,
        lastDate: lastDate);
    if (datePicked == null) return null;

    if (!context.mounted) return datePicked;
    final TimeOfDay? pTime = await pickTime(context,
        initialDate: TimeOfDay.fromDateTime(datePicked));
    return pTime == null
        ? datePicked
        : DateTime(
            datePicked.year,
            datePicked.month,
            datePicked.day,
            pTime.hour,
            pTime.minute,
          );

    // print("DATETIME INIT TIME : $pTime");
    // if (value != date)
    //   return DateTime(
    //     value.year,
    //     value.month,
    //     value.day,
    //     pTime.hour,
    //     pTime.minute,
    //   );
  }

  static Future<DateTimeRange?> pickDateRange(
    BuildContext context,
  ) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (BuildContext? context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Constant.primaryColor,
            colorScheme: ColorScheme.light(
              primary: Constant.primaryColor,
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) return picked;
    return null;
  }

  static Future<TimeOfDay?> pickTime(BuildContext context,
      {TimeOfDay? initialDate}) async {
    // print("DATETIME INIT : $initialDate");
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;
    return showTimePicker(
      context: context,
      initialTime: initialDate != null
          ? initialDate
          : TimeOfDay(hour: hour, minute: minute),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
  }
}
