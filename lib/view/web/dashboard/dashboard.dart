import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsivedashboard/common_widget/custom_text.dart';
import 'package:responsivedashboard/model/user_model.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/utils/image_utils.dart';
import 'package:responsivedashboard/utils/share_preference.dart';
import 'package:responsivedashboard/utils/static_data.dart';
import 'package:responsivedashboard/utils/string_utils.dart';
import 'package:responsivedashboard/view/web/dashboard/common_method.dart';
import 'package:responsivedashboard/view/web/dashboard/download_all_result_screen.dart';
import 'package:responsivedashboard/view/web/dashboard/drawer_screen/Student_List/student_data_class.dart';
import 'package:responsivedashboard/view/web/dashboard/drawer_screen/all_user_class.dart';
import 'package:responsivedashboard/view/web/dashboard/drawer_screen/final_data_screen.dart';
import 'package:responsivedashboard/view/web/dashboard/drawer_screen/setting_data_screen.dart';
import 'package:responsivedashboard/viewmodel/dashboard_viewmodel.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({Key? key}) : super(key: key);

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

List<UserResModel> allUserData1 = [];

class _DesktopScaffoldState extends State<DesktopScaffold> {
  DashboardViewModel dashboardViewModel = Get.find();
  RxInt onTitleTap = PreferenceManagerUtils.getIndex().obs;

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   fetchData();
    // });
  }

  void fetchData() async {
    try {
      // var stream = StudentService.getStudentData();
      // var userStream = UserService.getUserData();
      // await for (var data in stream) {
      //   dashboardViewModel.studentList.value = data;
      // }
      // await for (var data in userStream) {
      //   dashboardViewModel.userList.value = data;
      // }
      // await for (var data in stream) {
      //   setState(() async {
      //     filteredData.clear();
      //     yourDataList = data;
      //     for (var element in data) {
      //       if (element.isApproved == false) {
      //         filteredData.add(element);
      //       }
      //     }
      //     await for (var data in userStream) {
      //       setState(() {
      //         userData = data;
      //         userfilterData = List.from(data);
      //         allUserData1 = data;
      //       });
      //     }
      //   });
      // }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.white,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Drawer(
            backgroundColor: ColorUtils.primaryColor,
            elevation: 0,
            shape: null,
            child: ListView(
              children: [
                SizedBox(
                  height: Get.width * 0.01,
                ),

                /// Eduplus
                Center(
                  child: CustomText(
                    StringUtils.appName,
                    fontWeight: FontWeight.w400,
                    color: ColorUtils.white,
                    fontSize: 30.sp,
                    fontFamily: AssetsUtils.dMSerifDisplay,
                  ),
                ),

                /// Welcome Admin
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
                                image: AssetImage(AssetsUtils.logo), fit: BoxFit.fill)),
                      ),
                      SizedBox(
                        width: Get.width * 0.01,
                      ),
                      Expanded(
                        child: Column(
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
                              PreferenceManagerUtils.getLoginAdmin(),
                              fontWeight: FontWeight.w500,
                              color: ColorUtils.white,
                              fontSize: 20,
                              fontFamily: AssetsUtils.poppins,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: Get.width * 0.02,
                ),
                Column(
                  children: List.generate(StaticData.tabData.length, (index) {
                    return Column(
                      children: [
                        commonTab(
                            title: StaticData.tabData[index]['title'],
                            icon: StaticData.tabData[index]['icon'],
                            color: onTitleTap.value == index
                                ? Colors.white.withOpacity(0.2)
                                : Colors.transparent,
                            iconHeight: index == 3 ? Get.height * 0.04 : Get.height * 0.05,
                            onTap: () {
                              setState(() {
                                onTitleTap.value = index;
                                PreferenceManagerUtils.setIndex(index);
                              });
                            }),
                        SizedBox(
                          height: Get.width * 0.01,
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),

          /// Student list
          onTitleTap.value == 0
              ? const StudentList()
              : (onTitleTap.value == 1)
                  ? const AllUser()
                  : (onTitleTap.value == 2)
                      ? const FinalDataDrawerScreen()
                      : (onTitleTap.value == 3)
                          ? const DownloadAllResultScreen()
                          : (onTitleTap.value == 4)
                              ? const SettingDataScreen()
                              // : const PromotionScreen()
                              : const SizedBox()
          // : const Center(
          //     child: Text("Edit Entry Data",
          //         textAlign: TextAlign.center),
          //   )
        ],
      ),
    );
  }
}
