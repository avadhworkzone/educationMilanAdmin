import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsivedashboard/common_widget/custom_text.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/utils/image_utils.dart';
import 'package:responsivedashboard/utils/share_preference.dart';
import 'package:responsivedashboard/utils/static_data.dart';
import 'package:responsivedashboard/utils/string_utils.dart';
import 'package:responsivedashboard/view/web/dashboard/common_method.dart';
import 'package:responsivedashboard/view/screens/student_data_list.dart';
import 'package:responsivedashboard/view/web/dashboard/drawer_screen/all_user_class.dart';
import 'package:responsivedashboard/view/web/dashboard/drawer_screen/final_data_screen.dart';
import 'package:responsivedashboard/view/web/dashboard/drawer_screen/setting_data_screen.dart';
import 'package:responsivedashboard/view/web/dashboard/year_wise_data.dart';
import 'package:responsivedashboard/viewmodel/dashboard_viewmodel.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({Key? key}) : super(key: key);

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  final DashboardViewModel dashboardViewModel = Get.find();
  RxInt onTitleTap = PreferenceManagerUtils.getIndex().obs;
  String familyName='Education ';
@override
  void initState() {
  getData();
    // TODO: implement initState
    super.initState();
  }

  getData()async{
    final familyDoc = await FirebaseFirestore.instance
        .collection('families')
        .doc(         PreferenceManagerUtils.getLoginAdmin(),)
        .get();

    final familyData = familyDoc.data();
    setState(() {
      familyName = familyData?['familyName'] ?? '';
  });}

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: ColorUtils.white,
      appBar: isMobile
          ? AppBar(
        title: Text(familyName,style: TextStyle(color: ColorUtils.white),),
        backgroundColor: ColorUtils.primaryColor,
      )
          : null,

      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMobile)
            SizedBox(
              width: 250.w,
              child: Drawer(
                backgroundColor: ColorUtils.primaryColor,
                elevation: 0,
                shape: null,
                child: buildDrawerContent(),
              ),
            ),

          /// Main Body Content
          Obx(() => _buildContentByTab(onTitleTap.value)),
        ],
      ),
      bottomNavigationBar: isMobile
          ? BottomNavigationBar(
        currentIndex: onTitleTap.value,
        // backgroundColor: ColorUtils.grey5B,
        onTap: (index) {
          setState(() {
            onTitleTap.value = index;
            PreferenceManagerUtils.setIndex(index);
          });
        },
        selectedItemColor: ColorUtils.primaryColor,
        unselectedItemColor: ColorUtils.grey9A,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(color: ColorUtils.primaryColor, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(color: ColorUtils.grey9A, fontWeight: FontWeight.w500),
        type: BottomNavigationBarType.fixed,
        items: List.generate(StaticData.tabData.length, (index) {
          final isSelected = onTitleTap.value == index;
          return BottomNavigationBarItem(
            icon: Image.asset(
              StaticData.tabData[index]['icon'],
              height: 26,
              width: 26,
              color: isSelected ? ColorUtils.primaryColor : ColorUtils.grey9A, // ✅ dynamic coloring
            ),
            label: StaticData.tabData[index]['title'],
          );
        }),
      )

          : null,
    );
  }

  Widget buildDrawerContent() {
    return ListView(
      children: [
        SizedBox(height: Get.height * 0.02),
        Center(
          child: CustomText(
            familyName,
            fontWeight: FontWeight.w400,
            color: ColorUtils.white,
            fontSize: 30.sp,
            fontFamily: AssetsUtils.dMSerifDisplay,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.01, vertical: Get.width * 0.01),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage(AssetsUtils.logo),
                        fit: BoxFit.fill)),
              ),
              SizedBox(width: Get.width * 0.01),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "Welcome",
                      fontWeight: FontWeight.w400,
                      color: ColorUtils.white,
                      fontSize: 14.sp,
                    ),
                    CustomText(
                      PreferenceManagerUtils.getLoginAdmin(),
                      fontWeight: FontWeight.w500,
                      color: ColorUtils.white,
                      fontSize: 16.sp,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(height: Get.height * 0.02),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: List.generate(StaticData.tabData.length, (index) {
              return Column(
                children: [
                  commonTab(
                    title: StaticData.tabData[index]['title'],
                    icon: StaticData.tabData[index]['icon'],
                    color: onTitleTap.value == index
                        ? Colors.white.withOpacity(0.2)
                        : Colors.transparent,
                    iconHeight:
                    index == 3 ? Get.height * 0.04 : Get.height * 0.05,
                    onTap: () {
                      onTitleTap.value = index;
                      PreferenceManagerUtils.setIndex(index);
                      if (Scaffold.of(context).isDrawerOpen) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  SizedBox(height: Get.height * 0.01),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildContentByTab(int index) {
    switch (index) {
      case 0:
        return const StudentList();
      case 1:
        return const AllUser();
      case 2:
        return const FinalDataDrawerScreen();
      case 3:
        return const YearWiseExportScreen();
      case 4:
        return const SettingDataScreen();
      default:
        return const Center(child: Text("No screen selected"));
    }
  }
}
