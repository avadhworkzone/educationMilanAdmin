import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsivedashboard/common_widget/custom_assets.dart';
import 'package:responsivedashboard/common_widget/custom_text.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/utils/string_utils.dart';
import 'package:responsivedashboard/view/mobile/auth/login_mobile.dart';
import 'package:responsivedashboard/view/mobile/bottombar_mobile/all_user_mob.dart';
import 'package:responsivedashboard/view/tablet/auth/login_tablet.dart';
import 'package:responsivedashboard/view/tablet/bottomebar_tablet/all_user_tab.dart';
import 'package:responsivedashboard/view/web/dashboard/dashboard.dart';
import 'package:responsivedashboard/view/web/dashboard/desktop_user.dart';
import '../utils/image_utils.dart';
import '../view/web/auth/desktop_login_form.dart';
import '../responsiveLayout/responsive_layout.dart';

var defaultBackgroundColor = ColorUtils.white;
var appBarColor = Colors.grey[900];

var myAppBar = AppBar(
  backgroundColor: appBarColor,
  title: const Text(' '),
  centerTitle: false,
);

var myDrawer = Drawer(
  backgroundColor: ColorUtils.primaryColor,
  elevation: 0,
  shape: null,
  child: ListView(
    children: [
      SizedBox(
        height: Get.width * 0.01,
      ),

      /// Eduplus
      Row(
        children: [
          LocalAssets(
            imagePath: AssetsUtils.logo,
            width: Get.width * 0.05,
            height: Get.height * 0.05,
          ),
          CustomText(
            StringUtils.appName,
            fontWeight: FontWeight.w400,
            color: ColorUtils.white,
            fontSize: 30.sp,
            fontFamily: AssetsUtils.dMSerifDisplay,
          )
        ],
      ),

      /// Welcome Admin
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.01, vertical: Get.width * 0.01),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: ColorUtils.white,
              child: CircleAvatar(
                radius: 28,
                // backgroundColor: ColorUtils.red,
                child: LocalAssets(imagePath: AssetsUtils.photo),
              ),
            ),
            SizedBox(
              width: Get.width * 0.01,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  "welcome",
                  fontWeight: FontWeight.w400,
                  color: ColorUtils.white,
                  fontSize: 15,
                  fontFamily: AssetsUtils.poppins,
                ),
                CustomText(
                  "ADMIN",
                  fontWeight: FontWeight.w500,
                  color: ColorUtils.white,
                  fontSize: 20,
                  fontFamily: AssetsUtils.poppins,
                ),
              ],
            )
          ],
        ),
      ),

      SizedBox(
        height: Get.width * 0.02,
      ),

      /// Student List
      InkWell(
        onTap: () {
          // Get.to(const DesktopScaffold());
          Get.to(const ResponsiveLayout(
            desktopBody: DesktopLoginForm(),
            mobileBody: LoginMobile(),
            tabletBody: LoginTablet(),
          ));
        },
        child: Row(
          children: [
            LocalAssets(
              imagePath: AssetsUtils.vector,
              width: Get.width * 0.05,
              height: Get.height * 0.05,
            ),
            CustomText(
              "Student list",
              fontWeight: FontWeight.w500,
              color: ColorUtils.white,
              fontSize: 16.sp,
              fontFamily: AssetsUtils.poppins,
            ),
          ],
        ),
      ),
      SizedBox(
        height: Get.width * 0.01,
      ),

      /// All User
      InkWell(
        onTap: () {
          // Get.to(const DesktopAllUser());
          Get.to(ResponsiveLayout(
            desktopBody: const DesktopAllUser(),
            mobileBody: AllUserMob(allUserData1: allUserData1),
            tabletBody: const AllUserTab(),
          ));
        },
        child: Row(
          children: [
            LocalAssets(
              imagePath: AssetsUtils.person,
              width: Get.width * 0.05,
              height: Get.height * 0.05,
            ),
            CustomText(
              "All User",
              fontWeight: FontWeight.w500,
              color: ColorUtils.white,
              fontSize: 16.sp,
              fontFamily: AssetsUtils.poppins,
            ),
          ],
        ),
      ),

      SizedBox(
        height: Get.width * 0.01,
      ),

      /// Final Data
      Row(
        children: [
          LocalAssets(
            imagePath: AssetsUtils.graph,
            width: Get.width * 0.05,
            height: Get.height * 0.05,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                "Final Data",
                fontWeight: FontWeight.w500,
                color: ColorUtils.white,
                fontSize: 16.sp,
                fontFamily: AssetsUtils.poppins,
              ),
            ],
          )
        ],
      ),
      SizedBox(
        height: Get.width * 0.01,
      ),

      /// Edit Entry Data
      Row(
        children: [
          LocalAssets(
            imagePath: AssetsUtils.pencil,
            width: Get.width * 0.05,
            height: Get.height * 0.05,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                "Edit Entry Data",
                fontWeight: FontWeight.w500,
                color: ColorUtils.white,
                fontSize: 16.sp,
                fontFamily: AssetsUtils.poppins,
              ),
            ],
          )
        ],
      ),

      /// ADS
      Row(
        children: [
          LocalAssets(
            imagePath: AssetsUtils.adsIcon,
            width: Get.width * 0.05,
            height: Get.height * 0.05,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                "Promotion",
                fontWeight: FontWeight.w500,
                color: ColorUtils.white,
                fontSize: 16.sp,
                fontFamily: AssetsUtils.poppins,
              ),
            ],
          )
        ],
      ),
    ],
  ),
);
