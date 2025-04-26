import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsivedashboard/common_widget/common_btn.dart';
import 'package:responsivedashboard/common_widget/custom_text.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/utils/string_utils.dart';
import 'package:responsivedashboard/view/web/auth/desktop_login_form.dart';
import 'package:responsivedashboard/view/web/dashboard/common_method.dart';
import 'package:responsivedashboard/view/screens/add_standard.dart';

import '../../../screens/signInPage.dart';

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({Key? key}) : super(key: key);

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  bool isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: ListView(
        children: [
          SizedBox(
            height: Get.width * 0.01,
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.01,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Setting Data
                      CustomText(
                        StringUtils.settingData,
                        color: ColorUtils.black32,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                      Row(
                        children: [
                          // commonButton(StringUtils.matchOut),
                          SizedBox(
                            width: Get.width * 0.01,
                          ),
                          InkWell(
                            onTap: () async {
                              setState(() {
                                isLoggingOut = true;
                              });
                              await signOut();
                              setState(() {
                                isLoggingOut = false;
                              });
                              Get.offAll(() => const SignUpScreenForm());
                            },
                            child: isLoggingOut
                                ? const CircularProgressIndicator()
                                : commonButton(StringUtils.logOut),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  // ADD STANDARED
                  InkWell(
                    onTap: () {
                      addPromotionDialog(context);
                    },
                    child: commonButton(StringUtils.addNew),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
