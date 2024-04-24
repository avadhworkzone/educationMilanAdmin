import 'package:flutter/cupertino.dart';

import '../utils/color_utils.dart';
import 'custom_text.dart';

commonButton(String? name,
    {double? horizontalPadding, double? verticalPadding}) {
  return Container(
    decoration: BoxDecoration(
        color: const Color(0XFF251E90), borderRadius: BorderRadius.circular(5)),
    child: Padding(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 8.0,
          vertical: verticalPadding ?? 8.0),
      child: CustomText(
        name ?? "",
        color: ColorUtils.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
