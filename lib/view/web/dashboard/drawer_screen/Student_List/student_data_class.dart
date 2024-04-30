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
import 'student_data_ontap.dart';

class StudentList extends StatefulWidget {
  const StudentList({
    Key? key,
  }) : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  bool isLoggingOut = false;

  DashboardViewModel dashboardViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.02,
        ),
        child: ListView(
          children: [
            SizedBox(height: ScreenUtil().setWidth(10)),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            setState(() {
                              isLoggingOut = true;
                            });

                            await signOut();
                            setState(() {
                              isLoggingOut = false;
                            });

                            Get.offAll(() => const ResponsiveLayout(
                                  desktopBody: DesktopLoginForm(),
                                  mobileBody: LoginMobile(),
                                  tabletBody: LoginTablet(),
                                ));
                          },
                          child: isLoggingOut
                              ? const CircularProgressIndicator()
                              : commonButton(StringUtils.logOut),
                        )
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setWidth(20)),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: Get.width * 0.02,
            ),
            FutureBuilder<List<StudentModel>>(
                future: StandardService.getStandards(),
                builder: (context, snapshot) {
                  print("SnapShot == ${snapshot}");
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return noDataFound();
                  }
                  List<StudentModel> stdList = snapshot.data!;
                  // return Wrap(
                  //   children: List.generate(stdList.length, (index) {
                  //     var element = stdList[index];
                  //
                  //     return Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: InkWell(
                  //         onTap: () {
                  //           // List<StudentModel> stdFilteredData = [];
                  //           // stdFilteredData = stdList
                  //           //     .where((val) =>
                  //           //         val.standard == element.standard.toString() &&
                  //           //         val.isApproved == false)
                  //           //     .toList()
                  //           //   ..sort((a, b) =>
                  //           //       b.percentage!.compareTo(a.percentage!));
                  //           // print("stdFilteredData == ${stdFilteredData}");
                  //           // if (stdFilteredData.isNotEmpty) {
                  //           Get.offAll(() => ResponsiveLayout(
                  //                 desktopBody: StandardViseDataStudentScreen(
                  //                   stdId: element.standard.toString(),
                  //                 ),
                  //                 mobileBody: OnTapStudentDataScreen(
                  //                   studentId: element.standard.toString(),
                  //                   yourDataList: stdList,
                  //                 ),
                  //                 tabletBody: OnTapStudentDataScreen(
                  //                   studentId: element.standard.toString(),
                  //                   yourDataList: stdList,
                  //                 ),
                  //               ));
                  //           // } else {
                  //           //   ToastUtils.showCustomToast(
                  //           //       timeInSecForIosWeb: 2,
                  //           //       context: context,
                  //           //       gravity: ToastGravity.TOP,
                  //           //       title: "No Data in This Standard");
                  //           // }
                  //
                  //           // finalDataApprovedDialog(element.standard.toString());
                  //         },
                  //         child: Container(
                  //           width: 300,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(15.r),
                  //             border: Border.all(
                  //                 color: ColorUtils.greyEA, width: 3.w),
                  //             color: ColorUtils.greyF9,
                  //           ),
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Center(
                  //                 child: CustomText(
                  //               element.standard ?? "",
                  //               fontSize: 19.sp,
                  //               fontWeight: FontWeight.w600,
                  //               fontFamily: AssetsUtils.poppins,
                  //               color: ColorUtils.black3F,
                  //             )),
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   }),
                  // );
                  return GridView.builder(
                    padding: EdgeInsets.only(right: 25.w),
                    shrinkWrap: true,
                    itemCount: stdList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 40.h,
                        childAspectRatio: 5,
                        crossAxisSpacing: 16.w),
                    itemBuilder: (context, index) {
                      var element = stdList[index];
                      return InkWell(
                        onTap: () {
                          // List<StudentModel> stdFilteredData = [];
                          // stdFilteredData = stdList
                          //     .where((val) =>
                          //         val.standard == element.standard.toString() &&
                          //         val.isApproved == false)
                          //     .toList()
                          //   ..sort((a, b) =>
                          //       b.percentage!.compareTo(a.percentage!));
                          // print("stdFilteredData == ${stdFilteredData}");
                          // if (stdFilteredData.isNotEmpty) {
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
                          // } else {
                          //   ToastUtils.showCustomToast(
                          //       timeInSecForIosWeb: 2,
                          //       context: context,
                          //       gravity: ToastGravity.TOP,
                          //       title: "No Data in This Standard");
                          // }

                          // finalDataApprovedDialog(element.standard.toString());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                                color: ColorUtils.greyEA, width: 3.w),
                            color: ColorUtils.greyF9,
                          ),
                          child: Center(
                              child: CustomText(
                            element.standard ?? "",
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: AssetsUtils.poppins,
                            color: ColorUtils.black3F,
                          )),
                        ),
                      );
                    },
                  );
                })
          ],
        ),
      ),
    );
  }
}
