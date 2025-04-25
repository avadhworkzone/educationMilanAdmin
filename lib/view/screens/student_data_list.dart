import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsivedashboard/common_widget/common_btn.dart';
import 'package:responsivedashboard/common_widget/custom_text.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/utils/share_preference.dart';
import 'package:responsivedashboard/utils/string_utils.dart';
import 'package:responsivedashboard/view/screens/standaredvise_data_student.dart';
import 'package:responsivedashboard/view/web/auth/desktop_login_form.dart';
import 'package:responsivedashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:responsivedashboard/firbaseService/student_service/student_details_services.dart';
import 'package:responsivedashboard/firbaseService/standard_service/standad_services.dart';

import '../../common_widget/no_data_found.dart';
import '../../utils/enum_utils.dart';
import '../web/dashboard/common_method.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  bool isLoggingOut = false;
  final DashboardViewModel dashboardViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
        child: ListView(
          children: [
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: ColorUtils.primaryColor,borderRadius: BorderRadius.circular(10)

              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      StringUtils.studentList,
                      color: ColorUtils.white,
                      fontSize:isMobile?40.sp: 30.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    InkWell(
                      onTap: () async {
                        setState(() => isLoggingOut = true);
                        await signOut();
                        setState(() => isLoggingOut = false);
                        Get.offAll(() => DesktopLoginForm());
                      },
                      child: isLoggingOut
                          ? const CircularProgressIndicator()
                          : commonButton(StringUtils.logOut),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            /// Standards grid
            FutureBuilder<List<String>>(
              future: StandardService.getStandardsByFamily(         PreferenceManagerUtils.getLoginAdmin(),),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return noDataFound();
                }

                final stdList = snapshot.data!;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: stdList.length,
                  padding: EdgeInsets.only(right: 25.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 40.h,
                    crossAxisSpacing: 25.w,
                    childAspectRatio: 4,
                  ),
                  itemBuilder: (context, index) {
                    final standard = stdList[index];

                    return InkWell(
                      onTap: () {
                        Get.offAll(() => StandardViseDataStudentScreen(stdId: standard));
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
                                standard,
                                fontSize: isMobile?40.sp:22.sp,
                                fontWeight: FontWeight.bold,
                                // fontFamily: 'Poppins',
                                color: ColorUtils.black3F,
                              ),
                            ),
                          ),
                          Positioned(
                            top: -7.h,
                            right: -7.w,
                            child: StreamBuilder<List<StudentModel>>(
                              stream: StudentService.getStudentData(
                                standard: standard,
                                isApproved: false,
                                statusEnum: StatusEnum.pending,
                              ),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return const SizedBox();
                                }
                                return CountPendingStudentResult(count: snapshot.data!.length);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CountPendingStudentResult extends StatelessWidget {
  final num count;

  const CountPendingStudentResult({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    return Container(
      height:isMobile?20.h: 30.h,
      width: isMobile?20.h: 30.w,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: ColorUtils.red,
      ),
      child: Center(
        child: CustomText(
          "$count",
          color: ColorUtils.white,
        ),
      ),
    );
  }
}
