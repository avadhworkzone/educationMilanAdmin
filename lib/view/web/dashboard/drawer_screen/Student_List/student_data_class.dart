import 'dart:developer';

import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/enums/tooltip_direction_enum.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/handler_animation.dart';
import 'package:another_xlider/models/tooltip/tooltip.dart';
import 'package:another_xlider/models/tooltip/tooltip_box.dart';
import 'package:another_xlider/models/tooltip/tooltip_position_offset.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:responsivedashboard/common_widget/column_text.dart';
import 'package:responsivedashboard/common_widget/common_btn.dart';
import 'package:responsivedashboard/common_widget/common_tosat_msg.dart';
import 'package:responsivedashboard/common_widget/custom_text.dart';
import 'package:responsivedashboard/firbaseService/standard_service/standad_services.dart';
import 'package:responsivedashboard/firbaseService/student_service/student_details_services.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/utils/image_utils.dart';
import 'package:responsivedashboard/utils/share_preference.dart';
import 'package:responsivedashboard/utils/string_utils.dart';
import 'package:responsivedashboard/view/mobile/auth/login_mobile.dart';
import 'package:responsivedashboard/view/tablet/auth/login_tablet.dart';
import 'package:responsivedashboard/view/web/auth/desktop_login_form.dart';
import 'package:responsivedashboard/responsiveLayout/responsive_layout.dart';
import 'package:responsivedashboard/view/web/dashboard/common_method.dart';
import 'package:responsivedashboard/view/web/dashboard/drawer_screen/standaredvise_data_student.dart';
import 'package:responsivedashboard/viewmodel/dashboard_viewmodel.dart';

import '../../../../../common_widget/no_data_found.dart';
import '../../../../../utils/enum_utils.dart';
import 'student_data_ontap.dart';

// class StudentList extends StatefulWidget {
//   const StudentList({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<StudentList> createState() => _StudentListState();
// }
//
// class _StudentListState extends State<StudentList> {
//   bool isLoggingOut = false;
//
//   DashboardViewModel dashboardViewModel = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       flex: 2,
//       child: Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: Get.width * 0.02,
//         ),
//         child: ListView(
//           children: [
//             SizedBox(height: ScreenUtil().setWidth(10)),
//             SizedBox(
//               width: double.infinity,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: ScreenUtil().setWidth(10),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         CustomText(
//                           StringUtils.studentList,
//                           color: ColorUtils.black32,
//                           fontSize: 30,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         InkWell(
//                           onTap: () async {
//                             setState(() {
//                               isLoggingOut = true;
//                             });
//
//                             await signOut();
//                             setState(() {
//                               isLoggingOut = false;
//                             });
//
//                             Get.offAll(() => const ResponsiveLayout(
//                                   desktopBody: DesktopLoginForm(),
//                                   mobileBody: LoginMobile(),
//                                   tabletBody: LoginTablet(),
//                                 ));
//                           },
//                           child: isLoggingOut
//                               ? const CircularProgressIndicator()
//                               : commonButton(StringUtils.logOut),
//                         )
//                       ],
//                     ),
//                     SizedBox(height: ScreenUtil().setWidth(20)),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: Get.width * 0.02,
//             ),
//             FutureBuilder<List<StudentModel>>(
//                 future: StandardService.getStandards(),
//                 builder: (context, snapshot) {
//                   print("SnapShot == ${snapshot}");
//                   if (!snapshot.hasData) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   if (snapshot.hasError) {
//                     return noDataFound();
//                   }
//                   List<StudentModel> stdList = snapshot.data!;
//                   return GridView.builder(
//                     padding: EdgeInsets.only(right: 25.w),
//                     shrinkWrap: true,
//                     itemCount: stdList.length,
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 4,
//                         mainAxisSpacing: 40.h,
//                         childAspectRatio: 5,
//                         crossAxisSpacing: 16.w),
//                     itemBuilder: (context, index) {
//                       var element = stdList[index];
//                       return InkWell(
//                         onTap: () {
//                           // List<StudentModel> stdFilteredData = [];
//                           // stdFilteredData = stdList
//                           //     .where((val) =>
//                           //         val.standard == element.standard.toString() &&
//                           //         val.isApproved == false)
//                           //     .toList()
//                           //   ..sort((a, b) =>
//                           //       b.percentage!.compareTo(a.percentage!));
//                           // print("stdFilteredData == ${stdFilteredData}");
//                           // if (stdFilteredData.isNotEmpty) {
//                           Get.offAll(() => ResponsiveLayout(
//                                 desktopBody: StandardViseDataStudentScreen(
//                                   stdId: element.standard.toString(),
//                                 ),
//                                 mobileBody: OnTapStudentDataScreen(
//                                   studentId: element.standard.toString(),
//                                   yourDataList: stdList,
//                                 ),
//                                 tabletBody: OnTapStudentDataScreen(
//                                   studentId: element.standard.toString(),
//                                   yourDataList: stdList,
//                                 ),
//                               ));
//                           // } else {
//                           //   ToastUtils.showCustomToast(
//                           //       timeInSecForIosWeb: 2,
//                           //       context: context,
//                           //       gravity: ToastGravity.TOP,
//                           //       title: "No Data in This Standard");
//                           // }
//
//                           // finalDataApprovedDialog(element.standard.toString());
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15.r),
//                             border: Border.all(
//                                 color: ColorUtils.greyEA, width: 3.w),
//                             color: ColorUtils.greyF9,
//                           ),
//                           child: Center(
//                               child: CustomText(
//                             element.standard ?? "",
//                             fontSize: 19.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: AssetsUtils.poppins,
//                             color: ColorUtils.black3F,
//                           )),
//                         ),
//                       );
//                     },
//                   );
//                 })
//           ],
//         ),
//       ),
//     );
//   }
// }
///
class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}


class _StudentListState extends State<StudentList> {
  bool isLoggingOut = false;
  String? selectedMedium = 'English';
  DashboardViewModel dashboardViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
        child: ListView(
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  StringUtils.studentList,
                  color: ColorUtils.black32,
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
                InkWell(
                  onTap: () async {
                    setState(() => isLoggingOut = true);
                    await signOut();
                    setState(() => isLoggingOut = false);
                    Get.offAll(() => const ResponsiveLayout(
                      desktopBody: DesktopLoginForm(),
                      mobileBody: LoginMobile(),
                      tabletBody: LoginTablet(),
                    ));
                  },
                  child: isLoggingOut
                      ? const CircularProgressIndicator()
                      : commonButton(StringUtils.logOut),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              margin: EdgeInsets.only(top: 10.h),
              decoration: BoxDecoration(
                color: ColorUtils.greyF9,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: ColorUtils.primaryColor.withOpacity(0.6),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.language, color: ColorUtils.primaryColor),
                  SizedBox(width: 10.w),
                  CustomText(
                    "Select Medium:",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorUtils.black,
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedMedium,
                      isExpanded: true,
                      decoration: InputDecoration.collapsed(hintText: ''),
                      hint: Text("Choose Medium"),
                      items: ['English', 'Gujarati'].map((medium) {
                        return DropdownMenuItem<String>(
                          value: medium,
                          child: Text(medium),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => selectedMedium = value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (selectedMedium != null)
              FutureBuilder<List<StudentModel>>(
                future: StandardService.getStandards(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return noDataFound();
                  }

                  List<StudentModel> all = snapshot.data!;
                  List<StudentModel> kgList = all.where((e) {
                    // print('${e.standard}');

                    final std = e.standard ?? "";
                    return std.contains("Junior KG") || std.contains("Senior KG");
                  }).where((e) => e.standard?.contains(
                      selectedMedium == 'English' ? "(Eng)" : "(Guj)") ??
                      false).toList();

                  List<StudentModel> otherList = all.where((e) {
                    final std = e.standard ?? "";
                    return !std.contains("Junior KG") &&
                        !std.contains("Senior KG") &&
                        std.contains(selectedMedium == 'English' ? "(Eng)" : "(Guj)");
                  }).toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (kgList.isNotEmpty) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: CustomText(
                            "KG Standards",
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorUtils.primaryColor,
                          ),
                        ),
                        _buildStandardGrid(kgList),
                        SizedBox(height: 20.h),
                      ],
                      if (otherList.isNotEmpty) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: CustomText(
                            "Other Standards",
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorUtils.primaryColor,
                          ),
                        ),
                        _buildStandardGrid(otherList),
                      ],
                      if (kgList.isEmpty && otherList.isEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 40.h),
                          child: Center(child: CustomText("No standards found.")),
                        )
                    ],
                  );
                },
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Center(
                  child: CustomText("Please select a medium to continue."),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStandardGrid(List<StudentModel> stdList) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(right: 25.w),
      itemCount: stdList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 40.h,
        crossAxisSpacing: 16.w,
        childAspectRatio: 5,
      ),
      itemBuilder: (context, index) {
        var element = stdList[index];

        return InkWell(
          onTap: () {
            Get.offAll(() => ResponsiveLayout(
              desktopBody: StandardViseDataStudentScreen(
                stdId: element.standard.toString(),
              ),
              mobileBody: OnTapStudentDataScreen(
                studentId: element.standard.toString(),
                yourDataList: stdList,
              ),
              tabletBody: OnTapStudentDataScreen(
                studentId: element.standard.toString(),
                yourDataList: stdList,
              ),
            ));
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: ColorUtils.greyEA, width: 3.w),
                  color: ColorUtils.greyF9,
                ),
                child: Center(
                  child: CustomText(
                    element.standard ?? "",
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AssetsUtils.poppins,
                    color: ColorUtils.black3F,
                  ),
                ),
              ),
              Positioned(
                top: -7.h,
                right: -7.w,
                child: StreamBuilder<List<StudentModel>>(
                    stream: StudentService.getStudentData(
                        standard: element.standard.toString(),
                        isApproved: false,
                        statusEnum: StatusEnum.pending),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.hasError) {
                        return const SizedBox();
                      }
                      if ((snapshot.data?.length ?? 0) == 0) {
                        return const SizedBox();
                      }
                      return CountPendingStudentResult(
                        count: snapshot.data!.length,
                      );
                    }),
              ),
            ],
          ),
        );
      },
    );
  }


}

class CountPendingStudentResult extends StatelessWidget {
  const CountPendingStudentResult({
    super.key,
    required this.count,
  });

  final num count;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      width: 30.w,
      decoration:
      const BoxDecoration(shape: BoxShape.circle, color: ColorUtils.red),
      child: Center(
        child: CustomText(
          "$count",
          color: ColorUtils.white,
        ),
      ),
    );
  }
}

