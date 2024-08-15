// import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/text_input_formatter_helper.dart';
import '../helper/constant.dart';

class CustomTextField {
  static Widget underlineTextField(
    TextEditingController controller, {
    String? hintText,
    bool? obscureText,
    Widget? suffixIcon,
    String? suffixText,
    TextInputType? textInputType,
    bool enabled = true,
    bool? enableInteractiveSelection,
    FocusNode? focusNode,
    bool? isDecimalFormatter,
    Function(String)? onChange,
    Function(String)? onFieldSubmitted,
    Function(String?)? onSaved,
    Function()? onEditingComplete,
    int? maxLength,
    Color? color,
    Color? colorBorder,
    VoidCallback? onTap,
    double? borderWidth,
    bool required = true,
    List<TextInputFormatter>? inputFormatters,
    FormFieldValidator? validator,
  }) {
    return TextFormField(
      // The validator receives the text that the user has entered.
      style: TextStyle(color: color ?? Colors.black),
      decoration: InputDecoration(
        hintText: hintText ?? "",
        hintStyle: TextStyle(
          color: color,
        ),
        suffixIconColor: Constant.primaryColor,
        suffixIcon: suffixIcon,
        suffixText: suffixText,
        fillColor: Colors.white10,
        hoverColor: Constant.primaryColor,
        focusColor: Constant.primaryColor,
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorBorder ?? color ?? Colors.black45,
            width: borderWidth ?? 0.4,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorBorder ?? color ?? Colors.black45,
            width: borderWidth ?? 0.4,
          ),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorBorder ?? color ?? Colors.black45,
            width: borderWidth ?? 0.4,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorBorder ?? color ?? Constant.primaryColor,
            width: borderWidth ?? 0.4,
          ),
        ),
      ),
      obscureText: obscureText ?? false,
      controller: controller,
      keyboardType: textInputType ?? TextInputType.text,
      enabled: enabled ?? true,
      enableInteractiveSelection: enableInteractiveSelection ?? true,
      onTap: onTap,
      // will disable paste operation
      focusNode: focusNode,

      inputFormatters: [
        if (isDecimalFormatter ?? false) ThousandsSeparatorInputFormatter(),
        if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
        if (inputFormatters != null) ...[
          ...inputFormatters,
        ]
      ],
      validator: (validator ??
          (value) {
            if ((value == null || value.isEmpty) && required) {
              return 'Maaf, $hintText tidak boleh kosong';
              // return "Maaf".tr() +
              //     ", " +
              //     "mandatory_message".tr(args: [hintText?.tr() ?? ""]);
            }
            return null;
          }),
      onChanged: (str) {
        if (onChange != null) {
          onChange(str);
        }
      },
      onSaved: onSaved,
      onFieldSubmitted: onFieldSubmitted,
      onEditingComplete: onEditingComplete,
      textInputAction: onEditingComplete != null ? TextInputAction.next : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  static Widget normalTextField({
    required TextEditingController controller,
    String? hintText,
    String? labelText,
    bool? obscureText,
    Widget? suffixIcon,
    String? suffixText,
    TextInputType? textInputType,
    bool enabled = true,
    bool? enableInteractiveSelection,
    FocusNode? focusNode,
    bool? isDecimalFormatter,
    EdgeInsetsGeometry? padding,
    double? labelFontSize,
    double? hintFontSize,
    bool readOnly = false,
    Color? suffixIconColor,
    FontWeight? labelFontWeight,
    Color? labelColor,
    Color? fillColor,
    Color? hintColor,
    Color? borderColor,
    Color? validatorTextColor,
    int? maxLength,
    Widget? prefix,
    String? prefixText,
    Widget? prefixIcon,
    String? errorText,
    TextCapitalization? textCapitalization,
    Function()? onEditingComplete,
    Function()? onTap,
    String? Function(String?)? validator,
    Function(String)? onChange,
    bool required = true,
    List<TextInputFormatter>? inputFormatters,
    BorderRadius? borderRadius,
  }) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (labelText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Text(
                    labelText,
                    style: Constant.primaryTextStyle.copyWith(
                      color: labelColor,
                      fontSize: labelFontSize ?? 14,
                      fontWeight: labelFontWeight ?? Constant.medium,
                    ),
                  ),
                  required
                      ? Text(
                          '*',
                          style: Constant.primaryTextStyle.copyWith(
                            fontSize: labelFontSize ?? 14,
                            fontWeight: Constant.medium,
                            color: Colors.red,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          TextFormField(
            readOnly: readOnly,
            onTap: onTap,
            cursorColor: Constant.primaryColor,
            // The validator receives the text that the user has entered.
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              hintText: hintText ?? "",
              suffixIcon: suffixIcon,
              suffixText: suffixText,
              prefixText: prefixText,
              errorText: errorText,
              filled: true,
              fillColor: fillColor ?? Colors.grey.shade200,
              suffixIconColor: suffixIconColor ?? Constant.primaryColor,
              hoverColor: Constant.primaryColor,
              focusColor: Constant.primaryColor,
              errorStyle: TextStyle(color: validatorTextColor ?? Colors.red),
              prefixIcon: prefix,
              prefix: prefix == null ? const SizedBox(width: 12) : null,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: borderRadius ?? BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: borderRadius ?? BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Constant.primaryColor,
                  style: BorderStyle.solid,
                ),
                borderRadius: borderRadius ?? BorderRadius.circular(10),
              ),
            ),
            textInputAction:
                onEditingComplete != null ? TextInputAction.next : null,
            obscureText: obscureText ?? false,
            controller: controller,
            keyboardType: textInputType ?? TextInputType.text,
            enabled: enabled ?? true,
            enableInteractiveSelection: enableInteractiveSelection ?? true,
            // will disable paste operation
            focusNode: focusNode,
            inputFormatters: [
              if (isDecimalFormatter ?? false)
                ThousandsSeparatorInputFormatter(),
              if (maxLength != null)
                LengthLimitingTextInputFormatter(maxLength),
              if (inputFormatters != null) ...[
                ...inputFormatters,
              ]
            ],
            textCapitalization: textCapitalization ?? TextCapitalization.none,
            onEditingComplete: onEditingComplete,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (str) {
              if (onChange != null) {
                onChange(str);
              }
            },
            validator: validator ??
                (value) {
                  if ((value == null || value.isEmpty) && required) {
                    return "Maaf, ${labelText ?? hintText} wajib diisi";
                    // return "Maaf".tr() +
                    //     ", " +
                    //     "mandatory_message".tr(args: [hintText?.tr() ?? ""]);
                  }
                  return null;
                },
          ),
        ],
      ),
    );
  }

  static Widget borderTextField({
    required TextEditingController controller,
    String? hintText,
    String? labelText,
    bool? obscureText,
    Widget? suffixIcon,
    String? suffixText,
    TextInputType? textInputType,
    bool enabled = true,
    bool? enableInteractiveSelection,
    FocusNode? focusNode,
    bool? isDecimalFormatter,
    EdgeInsetsGeometry? padding,
    double? labelFontSize,
    bool readOnly = false,
    Color? suffixIconColor,
    FontWeight? labelFontWeight,
    FontWeight? hintFontWeight,
    Color? labelColor,
    Color? fillColor,
    Color? hintColor,
    Color? borderColor,
    Color? validatorTextColor,
    int? maxLength,
    Widget? prefix,
    Widget? prefixIcon,
    TextCapitalization? textCapitalization,
    Function()? onEditingComplete,
    Function()? onTap,
    String? Function(String?)? validator,
    Function(String)? onChange,
    Color? activeBorderColor,
    bool required = true,
    List<TextInputFormatter>? inputFormatters,
    BorderRadius? borderRadius,
  }) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (labelText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Text(
                    labelText,
                    style: Constant.primaryTextStyle.copyWith(
                      color: labelColor,
                      fontSize: labelFontSize ?? 14,
                      fontWeight: labelFontWeight ?? Constant.medium,
                    ),
                  ),
                  required
                      ? Text(
                          '*',
                          style: Constant.primaryTextStyle.copyWith(
                            fontSize: labelFontSize ?? 14,
                            fontWeight: Constant.medium,
                            color: Colors.red,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          TextFormField(
            readOnly: readOnly,
            onTap: onTap,
            // The validator receives the text that the user has entered.
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              hintText: hintText ?? "",
              suffixIcon: suffixIcon,
              suffixText: suffixText,
              filled: true,
              fillColor: fillColor ??
                  ((enabled ?? false) ? Colors.white : Constant.textHintColor),
              hoverColor: Constant.primaryColor,
              focusColor: Constant.primaryColor,
              errorStyle: TextStyle(color: validatorTextColor ?? Colors.red),
              hintStyle: TextStyle(
                  color: hintColor ?? Constant.textHintColor2,
                  fontWeight: hintFontWeight),
              prefixIcon: prefixIcon,
              prefix: prefix == null ? const SizedBox(width: 12) : null,
              border: OutlineInputBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 0.5,
                  color: borderColor ?? Constant.borderSearchColor,
                  style: BorderStyle.solid,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 0.5,
                  color: borderColor ?? Constant.borderSearchColor,
                  style: BorderStyle.solid,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 1,
                  color: activeBorderColor ?? Constant.primaryColor,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            textInputAction:
                onEditingComplete != null ? TextInputAction.next : null,
            obscureText: obscureText ?? false,
            controller: controller,
            keyboardType: textInputType ?? TextInputType.text,
            enabled: enabled ?? true,
            enableInteractiveSelection: enableInteractiveSelection ?? true,
            // will disable paste operation
            focusNode: focusNode,
            inputFormatters: [
              if (isDecimalFormatter ?? false)
                ThousandsSeparatorInputFormatter(),
              if (maxLength != null)
                LengthLimitingTextInputFormatter(maxLength),
              if (inputFormatters != null) ...[
                ...inputFormatters,
              ]
            ],
            textCapitalization: textCapitalization ?? TextCapitalization.none,
            onEditingComplete: onEditingComplete,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (str) {
              if (onChange != null) {
                onChange(str);
              }
            },
            validator: validator ??
                (value) {
                  if ((value == null || value.isEmpty) && required) {
                    return "Maaf, ${labelText ?? hintText} wajib diisi";
                    // return "Maaf".tr() +
                    //     ", " +
                    //     "mandatory_message".tr(args: [hintText?.tr() ?? ""]);
                  }
                  return null;
                },
          ),
        ],
      ),
    );
  }

  static Widget tableTextField({
    required TextEditingController controller,
    bool? obscureText,
    Widget? suffixIcon,
    String? suffixText,
    String? hintText,
    bool enabled = true,
    bool? enableInteractiveSelection,
    FocusNode? focusNode,
    bool? isDecimalFormatter,
    bool readOnly = false,
    Color? suffixIconColor,
    FontWeight? labelFontWeight,
    Color? fillColor,
    Color? hintColor,
    Color? borderColor,
    Color? validatorTextColor,
    Widget? prefix,
    Widget? prefixIcon,
    TextInputType? textInputType,
    TextCapitalization? textCapitalization,
    Function()? onEditingComplete,
    Function()? onTap,
    String? Function(String?)? validator,
    Function(String)? onChange,
    Color? activeBorderColor,
    bool required = false,
    bool noBorder = false,
    bool isDense = false,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      readOnly: readOnly,
      onTap: onTap,
      // The validator receives the text that the user has entered.
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        suffixIcon: suffixIcon,
        suffixText: suffixText,
        hintText: hintText,
        filled: true,
        isDense: isDense,
        fillColor:
            fillColor ?? (enabled ? Colors.white : Constant.textHintColor),
        hoverColor: Constant.primaryColor,
        focusColor: Constant.primaryColor,
        errorStyle: TextStyle(color: validatorTextColor ?? Colors.red),
        hintStyle: TextStyle(
            color: hintColor ?? Constant.textHintColor2, fontSize: 12),
        prefixIcon: prefix,
        prefix: prefix == null ? const SizedBox(width: 12) : null,
        border: noBorder
            ? InputBorder.none
            : OutlineInputBorder(
                borderSide: BorderSide(
                  color: borderColor ?? Constant.borderLightColor,
                ),
              ),
        enabledBorder: noBorder
            ? InputBorder.none
            : OutlineInputBorder(
                borderSide: BorderSide(
                  color: borderColor ?? Constant.borderLightColor,
                ),
              ),
        focusedBorder: noBorder
            ? InputBorder.none
            : OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.5,
                  color: activeBorderColor ?? Constant.primaryColor,
                ),
              ),
      ),
      textInputAction: onEditingComplete != null ? TextInputAction.next : null,
      obscureText: obscureText ?? false,
      controller: controller,
      keyboardType: textInputType ?? TextInputType.number,
      enabled: enabled,
      enableInteractiveSelection: enableInteractiveSelection ?? true,
      // will disable paste operation
      focusNode: focusNode,
      inputFormatters: [
        if (isDecimalFormatter ?? false) ThousandsSeparatorInputFormatter(),
        if (inputFormatters != null) ...[
          ...inputFormatters,
        ],
        LengthLimitingTextInputFormatter(1000000),
      ],
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      onEditingComplete: onEditingComplete,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (str) {
        if (onChange != null) {
          onChange(str);
        }
      },
      validator: validator ??
          (value) {
            if ((value == null || value.isEmpty) && required) {
              return "Maaf, ${'Ini'} wajib diisi";
            }
            return null;
          },
    );
  }

  static Widget borderTextArea({
    double? borderWidth,
    required TextEditingController controller,
    required FocusNode focusNode,
    String? hintText,
    String? labelText,
    bool? obscureText,
    Widget? suffixIcon,
    String? suffixText,
    TextInputType? textInputType,
    bool enabled = true,
    bool? enableInteractiveSelection,
    bool? isDecimalFormatter,
    EdgeInsetsGeometry? padding,
    double? labelFontSize,
    bool readOnly = false,
    Color? suffixIconColor,
    FontWeight? labelFontWeight,
    Color? labelColor,
    Color? hintColor,
    Color? borderColor,
    Color? fillColor,
    int? maxLength,
    Widget? prefix,
    Widget? prefixIcon,
    TextCapitalization? textCapitalization,
    Function()? onEditingComplete,
    Function()? onTap,
    String? Function(String?)? validator,
    Color? activeBorderColor,
    bool required = true,
    List<TextInputFormatter>? inputFormatters,
    BorderRadius? borderRadius,
  }) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (labelText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Text(
                    labelText,
                    style: Constant.primaryTextStyle.copyWith(
                      color: labelColor,
                      fontSize: labelFontSize ?? 14,
                      fontWeight: labelFontWeight ?? Constant.medium,
                    ),
                  ),
                  required
                      ? Text(
                          '*',
                          style: Constant.primaryTextStyle.copyWith(
                            fontSize: labelFontSize ?? 14,
                            fontWeight: Constant.medium,
                            color: Colors.red,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          Container(
            decoration: BoxDecoration(
              color: (enabled ?? false) ? Colors.white : Constant.textHintColor,
              border: Border.all(
                color: Constant.borderSearchColor,
                width: borderWidth ?? 0.5,
                style: BorderStyle.solid,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            padding: const EdgeInsets.all(Constant.paddingSize),
            child: TextField(
              readOnly: readOnly,
              onTap: onTap,
              focusNode: focusNode,
              maxLines: 5,
              controller: controller,
              autofocus: false,
              obscureText: obscureText ?? false,
              keyboardType: textInputType ?? TextInputType.text,
              enabled: enabled ?? true,
              enableInteractiveSelection: enableInteractiveSelection ?? true,
              decoration: InputDecoration.collapsed(
                hintText: hintText,
                focusColor: Colors.grey,
                filled: true,
                fillColor: fillColor ??
                    ((enabled ?? false)
                        ? Colors.white
                        : Constant.textHintColor),
                hoverColor: Constant.primaryColor,
                hintStyle:
                    TextStyle(color: hintColor ?? Constant.textHintColor2),
                enabled: enabled ?? true,
              ),
              inputFormatters: [
                if (isDecimalFormatter ?? false)
                  ThousandsSeparatorInputFormatter(),
                if (maxLength != null)
                  LengthLimitingTextInputFormatter(maxLength),
                if (inputFormatters != null) ...[
                  ...inputFormatters,
                ]
              ],
              textCapitalization: textCapitalization ?? TextCapitalization.none,
              onEditingComplete: onEditingComplete,
              textInputAction:
                  onEditingComplete != null ? TextInputAction.next : null,
            ),
          ),
        ],
      ),
    );
  }

  static Widget normalTextArea(
    FocusNode focusNode, {
    required TextEditingController controller,
    String? hint,
    bool required = true,
  }) {
    return Container(
      child: TextFormField(
        focusNode: focusNode,
        maxLines: 8,
        controller: controller,
        autofocus: false,
        decoration: InputDecoration(
          hintText: hint,
          fillColor: Colors.white10,
          hoverColor: Constant.primaryColor,
          focusColor: Constant.primaryColor,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black45,
            ),
          ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black45,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Constant.primaryColor,
            ),
          ),
        ),
        validator: (value) {
          if ((value == null || value.isEmpty) && required) {
            return 'Maaf, $hint tidak boleh kosong';

            // return "Maaf".tr() +
            //     ", " +
            //     "mandatory_message".tr(args: [hint?.tr() ?? ""]);
          }
          return null;
        },
      ),
    );
  }
}
