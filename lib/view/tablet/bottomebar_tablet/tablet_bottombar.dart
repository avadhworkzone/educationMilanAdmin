import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsivedashboard/common_widget/custom_text.dart';
import 'package:responsivedashboard/firbaseService/student_service/student_details_services.dart';
import 'package:responsivedashboard/firbaseService/user_service/user_service.dart';
import 'package:responsivedashboard/model/user_model.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/utils/const_utils.dart';
import 'package:responsivedashboard/utils/share_preference.dart';
import 'package:responsivedashboard/view/tablet/bottomebar_tablet/all_user_tab.dart';
import 'package:responsivedashboard/view/tablet/bottomebar_tablet/final_data_tab.dart';
import 'package:responsivedashboard/view/tablet/bottomebar_tablet/seeting_data_tab.dart';
import 'package:responsivedashboard/view/web/dashboard/common_method.dart';

import 'student_list_tablet.dart';

class TabletBottombar extends StatefulWidget {
  const TabletBottombar({Key? key}) : super(key: key);

  @override
  State<TabletBottombar> createState() => _TabletBottombarState();
}

List<UserResModel> allUserData1 = [];

class _TabletBottombarState extends State<TabletBottombar> {
  RxInt bottomSelector = PreferenceManagerUtils.getIndex().obs;
  List<Widget> screens = [
    StudentListDataTablet(),
    AllUserTab(
        // allUserData1: allUserData1,
        // filteredData: filteredData,
        ),
    AllUserTab(
        // allUserData1: allUserData1,
        // filteredData: filteredData,
        ),
    //TODO : change
    // FinalDataTab(
    //   filteredData: filteredData,
    // ),
    SeetingTabSceen(),
    // const EditEntryDataMob(),
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      // fetchData();
      //TODO : change
      // fetchDataOfStandard();
    });
    // standardsListFuture = firestoreService.getStandards();
  }

//   void fetchData() async {
//     try {
//       var stream = StudentService.getStudentData();
//       var userStream = UserService.getUserData();
//       await for (var data in stream) {
//         setState(() async {
//           //TODO : change
//           // filteredData.clear();
// //TODO : change
// //           yourDataList = data;
//           for (var element in data) {
//             if (element.isApproved == false) {
//               //TODO : change
//               //     filteredData.add(element);
//             }
//           }
//
//           await for (var data in userStream) {
//             setState(() {
//               userData = data;
//               userfilterData = List.from(data);
//               allUserData1 = data;
//             });
//           }
//         });
//       }
//     } catch (e) {
//       print("Error fetching data: $e");
//     }
//   }

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
      bottomNavigationBar: Container(
        height: 100.h,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -5),
          )
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            4,
            (index) {
              return Column(
                children: [
                  IconButton(
                    icon: Image.asset(
                      ConstUtils.bottomIcons[index],
                      color: bottomSelector.value == index
                          ? ColorUtils.primaryColor
                          : ColorUtils.black,
                      // scale: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        bottomSelector.value = index;
                        PreferenceManagerUtils.setIndex(index);
                      });
                    },
                  ),
                  CustomText(
                    ConstUtils.bottomName[index],
                    color: bottomSelector.value == index
                        ? ColorUtils.primaryColor
                        : ColorUtils.black,
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
