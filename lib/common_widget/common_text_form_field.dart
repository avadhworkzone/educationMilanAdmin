import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/color_utils.dart';
import 'custom_text.dart';

typedef OnChangeString = void Function(String value);

class CommonTextField extends StatelessWidget {
  final TextEditingController? textEditController;
  final String? title;
  final String? initialValue;
  final bool? isValidate;
  final bool? readOnly;
  final TextInputType? keyBoardType;
  final String? regularExpression;
  final int? inputLength;
  final String? hintText;
  final String? validationMessage;

  final String? preFixIconPath;
  final int? maxLine;
  final Widget? sIcon;
  final Widget? pIcon;
  final bool? obscureValue;
  final bool? underLineBorder;
  final bool? showLabel;
  final OnChangeString? onChange;
  final Color? titleColor;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const CommonTextField({
    super.key,
    this.regularExpression,
    this.inputFormatters,
    this.validator,
    this.title,
    this.textEditController,
    this.isValidate = true,
    this.keyBoardType,
    this.inputLength,
    this.readOnly = false,
    this.underLineBorder = false,
    this.showLabel = false,
    this.hintText,
    this.validationMessage,
    this.maxLine,
    this.sIcon,
    this.pIcon,
    this.preFixIconPath,
    this.onChange,
    this.initialValue = '',
    this.obscureValue,
    this.titleColor = ColorUtils.charlestonGreen,
  });

  /// PLEASE IMPORT GET X PACKAGE
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        title == null || title!.isEmpty
            ? const SizedBox.shrink()
            : CustomText(
                title ?? '',
                color: ColorUtils.primary,
                fontSize: 12.sp,
              ),
        title == null || title!.isEmpty
            ? const SizedBox.shrink()
            : SizedBox(
                height: 2.5.w,
              ),
        TextFormField(
          controller: textEditController,
          style: TextStyle(
            color: ColorUtils.black,
            fontSize: 15,
          ),
          keyboardType: keyBoardType ?? TextInputType.text,
          maxLines: maxLine ?? 1,
          onChanged: onChange,
          enabled: !readOnly!,
          readOnly: readOnly!,
          validator: validator,
          obscureText: obscureValue ?? false,
          textInputAction:
              maxLine == 4 ? TextInputAction.none : TextInputAction.done,
          cursorColor: ColorUtils.grey5B,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            hintText: hintText,
            errorStyle: TextStyle(
              color: Colors.red,
              fontSize: 9.sp,
            ),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            // focusedBorder:  OutlineInputBorder(
            //   borderSide: BorderSide(
            //     width: 1,
            //     color: ColorUtils.purple2D,
            //   ),
            //   borderRadius: BorderRadius.all(Radius.circular(12.0)),
            // ),
            disabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Colors.transparent, width: 1),
            ),
            prefixIcon: pIcon,
            suffixIcon: sIcon,
            counterText: '',
            filled: true,
            fillColor: ColorUtils.greyF6,
            labelStyle: TextStyle(
                fontSize: 14.sp,
                color: ColorUtils.greyBE,
                fontWeight: FontWeight.w600),
            hintStyle: TextStyle(
              color: ColorUtils.greyBE,
              fontSize: 15,
            ),
            errorMaxLines: 2,
          ),
        ),
      ],
    );
  }
}
