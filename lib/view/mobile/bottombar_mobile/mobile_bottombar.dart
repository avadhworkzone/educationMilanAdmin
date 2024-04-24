import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsivedashboard/common_widget/custom_text.dart';
import 'package:responsivedashboard/firbaseService/student_service/student_details_services.dart';
import 'package:responsivedashboard/firbaseService/user_service/user_service.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/utils/const_utils.dart';
import 'package:responsivedashboard/utils/share_preference.dart';
import 'package:responsivedashboard/view/mobile/bottombar_mobile/all_user_mob.dart';
import 'package:responsivedashboard/view/mobile/bottombar_mobile/final_data_mob.dart';
import 'package:responsivedashboard/view/mobile/bottombar_mobile/student_list_mob.dart';
import 'package:responsivedashboard/view/web/dashboard/common_method.dart';

import 'seeting_data_mob.dart';

class MobileBottombar extends StatefulWidget {
  const MobileBottombar({
    Key? key,
  }) : super(key: key);

  @override
  State<MobileBottombar> createState() => _MobileBottombarState();
}

class _MobileBottombarState extends State<MobileBottombar> {
  RxInt bottomSelector = PreferenceManagerUtils.getIndex().obs;

  List<Widget> screens = [
    StudentListDataMobile(),
    AllUserMob(
      allUserData1: allUserData1,
    ),
    FinalDataMob(
      filteredData: filteredData,
    ),
    const SeetingMobScreen(),
    // const EditEntryDataMob(
    // ),
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
    //TODO : change
    // fetchDataOfStandard();
  }

  void fetchData() async {
    try {
      // var stream = StudentService.getStudentData();
      var userStream = UserService.getUserData();
      // await for (var data in stream) {
      //   setState(() async {
      //     filteredData.clear();
      //     //TODO : change
      //     // yourDataList = data;
      //     for (var element in data) {
      //       if (element.isApproved == false) {
      //         filteredData.add(element);
      //       }
      //     }
      //
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
//TODO : change
  // void fetchDataOfStandard() async {
  //   try {
  //     var stream = StudentService.getStandardData();
  //     await for (var data in stream) {
  //       setState(() {
  //         yourStandardList = data;
  //         filteredStandardData = List.from(data);
  //         for (var element in data) {
  //           if (element.isApproved == true) {
  //             filteredData.add(element);
  //           }
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     print("Error fetching data: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[bottomSelector.value],
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 100.h,
          width: Get.width, // Adjusted height
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              4,
              (index) {
                return InkWell(
                  onTap: () {
                    print('Button $index pressed');
                    setState(() {
                      bottomSelector.value = index;
                      PreferenceManagerUtils.setIndex(index);
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        ConstUtils.bottomIcons[index],
                        color: bottomSelector.value == index
                            ? ColorUtils.primaryColor
                            : ColorUtils.black,
                        height: 70.h,
                        width: 70.w,
                      ),
                      CustomText(
                        ConstUtils.bottomName[index],
                        color: bottomSelector.value == index
                            ? ColorUtils.primaryColor
                            : ColorUtils.black,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
