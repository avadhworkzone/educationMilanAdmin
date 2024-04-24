import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/color_utils.dart';
import 'custom_text.dart';

commonText(String title) {
  return CustomText(
    title,
    color: ColorUtils.grey8A,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );
}
