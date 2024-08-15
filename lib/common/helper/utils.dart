// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:smart_mirror/helper/currencies.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:path/path.dart' as path;

// class Utils {
//   /// Simplify DateFormat with NullSafety
//   static String? nullableDateFormat(DateFormat format, DateTime? date) {
//     String? result;
//     try {
//       if (date != null) result = format.format(date);
//     } catch (e) {
//       print(e);
//     }
//     return result;
//   }

//   static String formatCurrency(num val,
//       {int decimalDigits = 0, Currency currency = Currency.IDR}) {
//     print(decimalDigits);

//     try {
//       if (currency == Currency.IDR) {
//         return new NumberFormat("#,##0", "in_ID").format(val);
//       } else {
//         if (decimalDigits > 0) {
//           return new NumberFormat("#,##0.##", "en_US").format(val);
//         } else {
//           return new NumberFormat("#,##0", "en_US").format(val);
//         }
//       }
//     } catch (e) {
//       print(e);
//       return '0';
//     }
//   }

//   static String setDigitStr(double num) {
//     RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
//     return num.toString().replaceAll(regex, '');
//   }

//   static num? parseCurrencyString(String amount,
//       {Currency currency = Currency.IDR, int decimalDigits = 0}) {
//     try {
//       final result = NumberFormat.compactCurrency(
//               decimalDigits: decimalDigits, locale: currency.locale)
//           .parse(amount);
//       if (decimalDigits == 0) return result.toInt();
//       return result;
//     } catch (e) {}
//     return null;
//   }

//   static String thousandSeparator(int val) {
//     print(val);
//     return NumberFormat.currency(
//             locale: "in_ID", symbol: "Rp. ", decimalDigits: 0)
//         .format(val);
//   }

//   static String digitOnly(String s) {
//     return s.replaceAll(new RegExp(r'[^0-9]'), '');
//   }

//   static cleanFile(File? file) async {
//     //Prevent storage cache fraud
//     if (file != null && file.existsSync()) {
//       File f = File(file.path);
//       if (await f.exists()) f.delete();
//     }
//   }

//   static String capitalize(String s) =>
//       s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

//   static Uri forceHttps(Uri uri) {
//     return uri.replace(scheme: 'https');
//   }

//   static http.MultipartFile multipartFile(String param, Uint8List uint8list,
//       {String? filename}) {
//     return http.MultipartFile.fromBytes(param, uint8list, filename: filename);
//   }

//   static Future<http.MultipartFile> multipartFileV2(String param, XFile file,
//       {String? filename}) async {
//     return http.MultipartFile.fromBytes(param, await file.readAsBytes(),
//         filename: filename ?? path.basename(file.path));
//   }

//   static dateForApi(String date, {DateFormat? currentformat}) {
//     DateTime? dt;
//     print(date);
//     if (currentformat != null) {
//       dt = currentformat.parse(date);
//     } else
//       dt = DateTime.tryParse(date);
//     if (dt == null)
//       return '';
//     else
//       return DateFormat('yyyy-MM-dd HH:mm:ss').format(dt);
//   }

//   static isOdd(int length) {
//     return (length % 2) == 0;
//   }

//   static List stringToList(String json) {
//     try {
//       return jsonDecode(json) ?? [];
//     } catch (e) {
//       return [];
//     }
//   }

//   static String FormatTime(TimeOfDay time) {
//     DateTime date = DateTime(2021, 1, 1, time.hour, time.minute);
//     return DateFormat.Hm().format(date);
//   }

//   static bool IsKeyboardVisible(BuildContext context) {
//     return MediaQuery.of(context).viewInsets.bottom != 0;
//   }

//   static Color? parseColor(String? hex) {
//     if (hex == null) return null;
//     try {
//       return Color(int.parse('0xff${hex.replaceAll('#', '')}'));
//     } catch (e) {
//       print(e);
//     }
//     return null;
//   }

//   static void hideKeyboard() {
//     return FocusManager.instance.primaryFocus?.unfocus();
//   }

//   static String parseError(Object? error) {
//     return error.toString().replaceAll('Exception: ', '');
//   }
// }
