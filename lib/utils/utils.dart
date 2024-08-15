import 'dart:io';

// import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' as Material;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../common/component/custom_button.dart';
import '../common/component/custom_textfield.dart';
import '../common/helper/constant.dart';
import '../common/helper/text_input_formatter_helper.dart';

extension numberExtension on num {
  bool get isInteger => (this % 1) == 0;
  bool get isFloating => (this % 1) != 0;
}

class Utils {
  static String? get mapStyle => '[]';

  // AppBar
  static AppBar appBar(
    String title, {
    TextStyle? titleTextStyle,
    Color? backgroundColor,
    Widget? leading,
    Widget? action,
  }) {
    return AppBar(
      title: Text(title),
      titleTextStyle: titleTextStyle,
      elevation: 0,
      backgroundColor: backgroundColor ?? Constant.primaryColor,
      leading: leading,
      actions: <Widget>[
        if (action != null) action,
      ],
    );
  }

  static bool emailValidator(String email) {
    final regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+");
    return regex.hasMatch(email);
  }

  static Future<List> pickDate(BuildContext context,
      {bool time = false, DateFormat? format}) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.utc(DateTime.now().year),
      lastDate: DateTime.utc(DateTime.now().year + 1),
      builder: (BuildContext? context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Constant.primaryColor,
            colorScheme: ColorScheme.light(
              primary: Constant.primaryColor,
            ),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (date == null) return ['', null];
    if (time) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        initialTime: TimeOfDay.fromDateTime(date),
      );
      if (time == null) return ['', null];
      date = date.add(Duration(hours: time.hour, minutes: time.minute));
    }
    if (format == null) {
      format = DateFormat.d("id_ID").add_MMM().add_y();
      if (time) format = format.add_Hm();
    }

    return [Utils.NullableDateFormat(format, date) ?? '', date];
  }

  static InkWell RoundedButton(
      {Material.VoidCallback? onpressed, Widget? child}) {
    return InkWell(
      onTap: onpressed ?? () {},
      child: Material.Card(
          shape: const CircleBorder(),
          child: Padding(
            child: child ??
                Icon(
                  Icons.chevron_left,
                  color: Constant.primaryColor,
                ),
            padding: EdgeInsets.all(8),
          )),
    );
  }

  static Center notFoundImage({String? text}) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage(
              "assets/images/main-image-not-found.png",
            ),
            width: 275,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            text ?? "Data tidak ditemukan!",
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  /// EasyLoading
  ///
  /// This utils purpose for accomodating loading and show toast
  ///
  /// How to use: Utils.showLoading();
  ///

  // show toast
  static showToast(String msg, {Duration? duration}) async {
    return await EasyLoading.showToast(msg,
        toastPosition: EasyLoadingToastPosition.bottom, duration: duration);
  }

  // show loading
  static showLoading() async {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..textColor = Colors.black
      ..progressColor = Colors.white
      ..indicatorSize = 42
      ..maskType = EasyLoadingMaskType.black
      ..indicatorType = EasyLoadingIndicatorType.dualRing
      ..backgroundColor = Constant.backgroundColor
      ..dismissOnTap = true
      ..indicatorColor = Constant.primaryColor;
    return await EasyLoading.show(dismissOnTap: true);
  }

  // show success
  static showSuccess({String msg = ""}) async {
    EasyLoading.instance
      ..successWidget = Column(
        children: [
          Container(
            // margin: EdgeInsets.symmetric(vertical: 24),
            child: Transform.scale(
              scale: 1.2,
              child: Lottie.asset(
                'assets/lottie/success2.json',
                repeat: false,
                width: 100,
                height: 100,
              ),
            ),
          ),
          const Text("Sukses",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Visibility(
            visible: msg != "",
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(msg, style: const TextStyle(fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      )
      ..backgroundColor = Colors.white
      ..dismissOnTap = false
      ..loadingStyle = EasyLoadingStyle.custom
      ..maskType = EasyLoadingMaskType.black
      ..indicatorType = EasyLoadingIndicatorType.dualRing
      // ..textStyle = TextStyle(fontWeight: FontWeight.bold)
      ..textColor = Colors.black
      ..indicatorColor = Constant.primaryColor;
    return EasyLoading.showSuccess("");
    // return await EasyLoading.show(dismissOnTap: true);
  }

  // show failed
  static showFailed({String msg = ""}) async {
    EasyLoading.instance
      ..errorWidget = Column(
        children: [
          Container(
            // margin: EdgeInsets.symmetric(vertical: 24),
            child: Transform.scale(
              scale: 1.2,
              child: Lottie.asset(
                'assets/lottie/failed.json',
                repeat: false,
                width: 100,
                height: 100,
              ),
            ),
          ),
          const Text("Gagal",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Visibility(
            visible: msg != "",
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(msg, style: const TextStyle(fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      )
      ..backgroundColor = Colors.white
      ..dismissOnTap = false
      ..loadingStyle = EasyLoadingStyle.custom
      // ..textStyle = TextStyle(fontWeight: FontWeight.bold)
      ..textColor = Colors.black
      ..indicatorColor = Constant.primaryColor;

    return EasyLoading.showError("");
    // return await EasyLoading.show(dismissOnTap: true);
  }

  /// TextField for Form
  static Widget Txt(String label, TextEditingController controller,
      {Widget? prefix,
      Widget? suffix,
      VoidCallback? onClick,
      bool readOnly = false,
      Widget? prefixIcon,
      Widget? suffixIcon,
      bool price = false,
      bool forDetail = false,
      Material.TextInputType? inputType,
      List<Material.Widget>? nextWidget,
      double nextWidgetMargin = 5,
      Function(String)? onChange}) {
    List<Widget> widgets = [];
    if (forDetail) {
      controller.text = ((prefix is Text &&
                  !controller.text.startsWith(prefix.data.toString()))
              ? prefix.data ?? ''
              : '') +
          ((controller.text.isEmpty && price) ? '0' : controller.text) +
          ((suffix is Text && !controller.text.endsWith(suffix.data.toString()))
              ? suffix.data ?? ''
              : '');
    }
    widgets.add(TextField(
      onTap: onClick,
      onChanged: onChange,
      readOnly: readOnly,
      textInputAction: Material.TextInputAction.next,
      keyboardType: inputType,
      style: (forDetail)
          ? const Material.TextStyle(fontSize: Constant.fontSizeRegular)
          : null,
      controller: controller,
      inputFormatters: (price)
          ? [FilteringTextInputFormatter.digitsOnly, CurrencyInputFormatter()]
          : [],
      decoration: InputDecoration(
          prefix: (forDetail) ? null : prefix,
          suffix: (forDetail) ? null : suffix,
          border: (forDetail) ? Material.InputBorder.none : null,
          isDense: (forDetail),
          isCollapsed: (forDetail),
          prefixIcon: (forDetail) ? null : prefixIcon,
          suffixIcon: (forDetail) ? null : suffixIcon,
          suffixIconConstraints: BoxConstraints.loose(const Size(108, 38))),
    ));
    if (nextWidget != null) {
      widgets.addAll(nextWidget
          .map((e) => Padding(
                padding: Material.EdgeInsets.only(top: nextWidgetMargin),
                child: e,
              ))
          .toList());
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: Constant.standartMarginSize),
      child: Wrap(
        children: [
          Padding(
            padding: (forDetail)
                ? const Material.EdgeInsets.only(bottom: 8)
                : Material.EdgeInsets.zero,
            child: Text(
              label,
              style: (forDetail)
                  ? const TextStyle(
                      fontWeight: Material.FontWeight.bold,
                      fontSize: Constant.fontSizeRegular)
                  : null,
            ),
          ),
          Row(
            crossAxisAlignment: Material.CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                children: widgets,
              )),
              if (forDetail && suffixIcon != null)
                Material.SizedBox(
                  width: 120,
                  child: suffixIcon,
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Simplify DateFormat with NullSafety
  static String? NullableDateFormat(DateFormat format, DateTime? date) {
    String? result;
    try {
      if (date != null) result = format.format(date);
    } catch (e) {
      print(e);
    }
    return result;
  }

  static convertDateddMMMyyyy(String date) {
    return DateFormat("dd MMM yyyy").format(DateTime.parse(date));
  }

  static convertDateddMMMMyyyy(String date) {
    return DateFormat("dd MMMM yyyy").format(DateTime.parse(date));
  }

  // dismiss loading
  static dismissLoading() async {
    return await EasyLoading.dismiss();
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  /// SnackBar
  ///
  /// This utils purpose for accomodating SnackBar
  ///
  /// How to use: Utils.showLoading();
  ///

  static SnackBar displaySnackBar(String message,
      {Color? bgColor, String? actionMessage, VoidCallback? onClick}) {
    return SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 14.0),
      ),
      action: (actionMessage != null)
          ? SnackBarAction(
              textColor: Colors.white,
              label: actionMessage,
              onPressed: () {
                return onClick!();
              },
            )
          : null,
      duration: const Duration(seconds: 2),
      backgroundColor: bgColor ?? Colors.red,
    );
  }

  /// Button
  ///
  /// This utils purpose for accomodating SnackBar
  ///
  /// How to use: Utils.showLoading();
  ///

  static mainButton(String str, VoidCallback onClick,
      {double? width, double? height, double? textSize, double? padding}) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Constant.primaryColor),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        elevation: WidgetStateProperty.all<double>(0),
      ),
      onPressed: onClick,
      child: Container(
        padding: EdgeInsets.all(padding ?? 12),
        width: width,
        height: height,
        alignment: Alignment.center,
        child: Text(
          str,
          style: TextStyle(
            fontSize: textSize ?? Constant.fontSizeRegular,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  static secondaryButton(String str, VoidCallback onClick) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: Constant.primaryColor),
          ),
        ),
        elevation: WidgetStateProperty.all<double>(0),
      ),
      onPressed: () {
        return onClick();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Text(
          str,
          style: TextStyle(
            color: Constant.primaryColor,
            fontSize: Constant.fontSizeRegular,
          ),
        ),
      ),
    );
  }

  /// TextField
  ///
  /// This utils purpose for build textfield
  ///
  /// How to use: Utils.showLoading();
  ///

  static mainTextField(
      String hint, TextEditingController controller, bool obscureText,
      {TextAlign? align,
      TextInputType? inputType,
      bool? isSeparator,
      int? limit,
      Widget? prefixIcon,
      bool? isFocus,
      Function? onTap,
      Function(String)? onChanged}) {
    return TextField(
      onChanged: (str) {
        if (onChanged != null) {
          onChanged(str);
        }
      },
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      focusNode: (isFocus ?? true) ? null : AlwaysDisabledFocusNode(),
      obscureText: obscureText,
      controller: controller,
      textAlign: align ?? TextAlign.left,
      keyboardType: inputType ?? TextInputType.text,
      inputFormatters: [
        if (limit != null) LengthLimitingTextInputFormatter(limit),
        if (isSeparator != null) ThousandsSeparatorInputFormatter(),
      ],
      decoration: InputDecoration(
        isDense: true,
        prefixIcon: (prefixIcon != null) ? prefixIcon : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        prefixStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 15,
        ),
        hintText: hint,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Constant.primaryColor,
          ),
        ),
      ),
    );
  }

  static Future showPaketUmrohHajiChoiceDialog({
    required BuildContext context,
    List<Widget>? actions,
    required VoidCallback umrohCallback,
    required VoidCallback hajiCallback,
  }) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
        actionsPadding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
        title: Center(
          child: Text(
            "Pilih Paket",
            style: Constant.primaryTextStyle.copyWith(
              fontWeight: Constant.bold,
            ),
          ),
        ),
        content: Material.Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Pilih paket Anda",
                style: Constant.primaryTextStyle.copyWith(fontSize: 14)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: umrohCallback,
                  child: Column(
                    children: [
                      Container(
                          child: Image.asset(
                        'assets/icons/Paket Umroh_1.png',
                        width: 60,
                      )),
                      SizedBox(height: 8),
                      Text(
                        'Paket Umroh',
                        style: Constant.primaryTextStyle.copyWith(
                            fontSize: 12, fontWeight: Constant.semibold),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: hajiCallback,
                  child: Column(
                    children: [
                      Container(
                          child: Image.asset(
                        'assets/icons/Paket haji_1.png',
                        width: 60,
                      )),
                      SizedBox(height: 8),
                      Text(
                        'Paket Haji',
                        style: Constant.primaryTextStyle.copyWith(
                            fontSize: 12, fontWeight: Constant.semibold),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        actions: const []
        // [
        //   Row(
        //     children: [
        //       Expanded(
        //         flex: 5,
        //           child: CustomButton.mainButton(
        //               "Paket Umroh", umrohCallback, fontSize: 12)),
        //       SizedBox(width: 10),
        //       Expanded(
        //         flex: 5,
        //           child: CustomButton.mainButton("Paket Haji", hajiCallback)),
        //     ],
        //   ),
        // ],
        );

    // show the dialog
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Future showYesNoDialog({
    required BuildContext context,
    required String title,
    required String desc,
    List<Widget>? actions,
    required VoidCallback yesCallback,
    required VoidCallback noCallback,
    String yesText = "Ya",
    String noText = "Tidak",
  }) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      actionsPadding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      contentPadding: const EdgeInsets.all(20),
      title: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: Constant.primaryTextStyle.copyWith(fontWeight: Constant.bold),
        ),
      ),
      content: Text(
        desc,
        style: Constant.primaryTextStyle.copyWith(fontSize: 14),
        textAlign: TextAlign.center,
      ),
      actions: actions ??
          [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(child: CustomButton.secondaryButton(noText, noCallback)),
              const SizedBox(width: 10),
              Expanded(child: CustomButton.mainButton(yesText, yesCallback)),
            ]),
          ],
    );

    // show the dialog
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Future showYesNoDialogWithWarning({
    required BuildContext context,
    required String title,
    required String desc,
    List<Widget>? actions,
    required VoidCallback yesCallback,
    required VoidCallback noCallback,
    String yesText = "Ya",
    String noText = "Tidak",
  }) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      actionsPadding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      contentPadding: const EdgeInsets.all(20),
      title: Column(
        children: [
          const Icon(
            Icons.error_outlined,
            color: Colors.red,
            size: 48,
          ),
          Constant.xSizedBox8,
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style:
                  Constant.primaryTextStyle.copyWith(fontWeight: Constant.bold),
            ),
          ),
        ],
      ),
      content: Text(
        desc,
        style: Constant.primaryTextStyle.copyWith(fontSize: 14),
        textAlign: TextAlign.center,
      ),
      actions: actions ??
          [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(child: CustomButton.secondaryButton(noText, noCallback)),
              const SizedBox(width: 10),
              Expanded(
                  child: CustomButton.mainButton(yesText, yesCallback,
                      color: Colors.red)),
            ]),
          ],
    );

    // show the dialog
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Future showYesNoWithNoteDialog({
    required BuildContext context,
    required String title,
    required String desc,
    List<Widget>? actions,
    required VoidCallback yesCallback,
    required VoidCallback noCallback,
    required String yesText,
    String noText = "Cancel",
  }) {
    String note = "";
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      actionsPadding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      contentPadding: const EdgeInsets.all(20),
      title: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: Constant.primaryTextStyle.copyWith(fontWeight: Constant.bold),
        ),
      ),
      content: Material.Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            desc,
            style: Constant.primaryTextStyle.copyWith(fontSize: 14),
          ),
          Constant.xSizedBox16,
          CustomTextField.borderTextArea(
              controller: TextEditingController(),
              hintText: "Note",
              textInputType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              focusNode: FocusNode(),
              required: true,
              readOnly: false,
              padding: EdgeInsets.zero),
        ],
      ),
      actions: actions ??
          [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: CustomButton.secondaryButton(noText, noCallback)),
                const SizedBox(width: 10),
                Expanded(
                    child: CustomButton.mainButton(yesText, yesCallback,
                        color: yesText == "Approve"
                            ? Constant.greenColor
                            : Constant.redColor)),
              ],
            ),
          ],
    );

    // show the dialog
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Material.Card Card(Widget child,
      {Color color = Colors.white,
      double elevation = 1,
      Material.EdgeInsets? margin,
      double border = 12,
      ShapeBorder? shape,
      bool? chainvertical = false}) {
    margin ??= chainvertical!
          ? Material.EdgeInsets.only(top: 12, left: 12, right: 12)
          : Material.EdgeInsets.all(12);
    shape ??= Material.RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(border));
    return Material.Card(
      shape: shape,
      elevation: elevation,
      margin: margin,
      child: child,
    );
  }

  static String ApiUrl(String path) {
    return Constant.BASE_API_FULL + path;
  }

  static Material.ClipRRect RoundedImage(Image image, double radius) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: image,
    );
  }

  static num? parseCurrencyString(String amount) {
    try {
      final result =
          NumberFormat.compactCurrency(decimalDigits: 2).parse(amount);
      return result;
    } catch (e) {}
    return null;
  }

  static String formatCurrency2(num? val,
      {int decimalDigits = 2, bool floating = true}) {
    if (val == null) return '';
    if (Intl.systemLocale == 'id_ID') {
      return toCurrencyString(val.toString(),
          mantissaLength: val.isFloating ? decimalDigits : 0,
          thousandSeparator: ThousandSeparator.Period);
    } else {
      return toCurrencyString(val.toString(),
          mantissaLength: val.isFloating ? decimalDigits : 0);
    }
  }

  static String formatThousandsToK(num? val) {
    return NumberFormat.compact().format(val);
  }

  static String formatCurrency(num val, {int decimalDigits = 0}) {
    try {
      return NumberFormat.simpleCurrency(
              locale: "en_ID", name: "", decimalDigits: decimalDigits)
          .format(val);
    } catch (e) {
      print(e);
      return '0';
    }
  }

  static String thousandSeparator(int val) {
    return NumberFormat.currency(
            locale: "in_ID", symbol: "Rp ", decimalDigits: 0)
        .format(val);
  }

  static String digitOnly(String s) {
    return s.replaceAll(RegExp(r'[^0-9]'), '');
  }

  static cleanFile(File? file) async {
    //Prevent storage cache fraud
    if (file != null && file.existsSync()) {
      File f = File(file.path);
      if (await f.exists()) f.delete();
    }
  }

  static Widget StatusBadge(String s,
      {double maxwidth = double.infinity, Material.TextAlign? textAlign}) {
    return Container(
        constraints: Material.BoxConstraints(maxWidth: maxwidth),
        color: const Color(0xfff8ebc7),
        padding: const EdgeInsets.all(10),
        child: Text(
          s,
          style: const Material.TextStyle(
            fontSize: Constant.fontSizeRegular,
            fontWeight: FontWeight.bold,
          ),
          textAlign: textAlign,
        ));
  }

  static Uri forceHttps(Uri uri) {
    return uri.replace(scheme: 'https');
  }

  static String setExt(String url) {
    String e = "";
    if (url.toLowerCase().contains(".pdf")) {
      e = "pdf";
    } else if (url.toLowerCase().contains(".docx")) {
      e = "docx";
    } else if (url.toLowerCase().contains(".xlsx")) {
      e = "xlsx";
    } else if (url.toLowerCase().contains(".jpg")) {
      e = "jpg";
    } else if (url.toLowerCase().contains(".png")) {
      e = "png";
    } else {
      e = "jpeg";
    }
    return e;
  }

  static Material.Widget ListLoading() {
    return Container(
        alignment: Alignment.center,
        child: const Material.CircularProgressIndicator());
  }

  static http.MultipartFile MultipartFile(String s, Uint8List uint8list,
      {String? filename}) {
    return http.MultipartFile.fromBytes(s, uint8list, filename: filename);
  }

  static DateForApi(String date, {DateFormat? currentformat}) {
    DateTime? dt;
    print(date);
    if (currentformat != null) {
      dt = currentformat.parse(date);
    } else {
      dt = DateTime.tryParse(date);
    }
    if (dt == null) {
      return '';
    } else {
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(dt);
    }
  }

  static isOdd(int length) {
    return (length % 2) == 0;
  }

  static String capitalize(String s) {
    if (s.length <= 1) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      print(true);
      return newValue;
    }

    double value = double.parse(newValue.text);

    final formatter = NumberFormat.simpleCurrency(
        locale: "in_ID", name: "", decimalDigits: 0);

    String newText = formatter.format(value);

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
