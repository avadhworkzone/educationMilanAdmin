import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:responsivedashboard/common_widget/common_btn.dart';
import 'package:responsivedashboard/common_widget/common_tosat_msg.dart';
import 'package:responsivedashboard/common_widget/custom_text.dart';
import 'package:responsivedashboard/common_widget/no_data_found.dart';
import 'package:responsivedashboard/firbaseService/standard_service/standad_services.dart';
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
import 'package:responsivedashboard/view/web/dashboard/final_data_ontap.dart';
import 'package:responsivedashboard/viewmodel/dashboard_viewmodel.dart';

class FinalDataDrawerScreen extends StatefulWidget {
  const FinalDataDrawerScreen({Key? key}) : super(key: key);

  @override
  State<FinalDataDrawerScreen> createState() => _FinalDataDrawerScreenState();
}

class _FinalDataDrawerScreenState extends State<FinalDataDrawerScreen> {
  TextEditingController searchController = TextEditingController();
  DashboardViewModel dashboardViewModel = Get.find();
  bool isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // flex: 2,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: Get.width * 0.01,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Textfield Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Final Data
                      CustomText(
                        StringUtils.finalData,
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
                              Get.to(const ResponsiveLayout(
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
                      )
                    ],
                  ),
                  SizedBox(
                    height: Get.width * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          commonButton(StringUtils.addNew),
                          SizedBox(
                            width: Get.width * 0.01,
                          ),
                          InkWell(
                            onTap: () {},
                            child: const CustomText(
                              "1 row selected",
                              color: ColorUtils.black10,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),

                      /// Search Textfield
                      SizedBox(
                        width: 300.w,
                        child: TextFormField(
                          cursorColor: ColorUtils.grey66,
                          controller: searchController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                              color: ColorUtils.black,
                              fontFamily: "FiraSans",
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search_rounded,
                                color: ColorUtils.grey66),
                            contentPadding:
                                EdgeInsets.only(left: Get.width * 0.02),
                            hintText: "Search",
                            hintStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: ColorUtils.grey66),
                            errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: ColorUtils.red)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: ColorUtils.greyD0)),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1.0, color: ColorUtils.greyD0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            disabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1.0, color: ColorUtils.greyD0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                  width: 1.0, color: ColorUtils.greyD0),
                            ),
                          ),
                          onChanged: (value) {
                            // var data = widget.filteredData;
                            // if (value.isNotEmpty) {
                            //   data = dashboardViewModel.studentList
                            //       .where((element) => element.studentFullName!
                            //           .toLowerCase()
                            //           .contains(value))
                            //       .toList();
                            // } else {
                            //   data = dashboardViewModel.studentList;
                            // }
                            // setState(() {
                            //   dashboardViewModel.studentList.value = data;
                            //   PreferenceManagerUtils.setData(data);
                            // });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Get.width * 0.02,
                  ),

                  /// Gridview.builder
                  FutureBuilder<List<StudentModel>>(
                      future: StandardService.getStandards(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return noDataFound();
                        }
                        List<StudentModel> stdList = snapshot.data!;
                        return GridView.builder(
                          padding: EdgeInsets.only(right: 25.w),
                          shrinkWrap: true,
                          itemCount: stdList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 40.h,
                                  childAspectRatio: 5,
                                  crossAxisSpacing: 16.w),
                          itemBuilder: (context, index) {
                            var element = stdList[index];
                            return InkWell(
                              onTap: () {
                                List<StudentModel> standardFilterData = [];
                                // standardFilterData = dashboardViewModel
                                //     .studentList
                                //     .where((val) =>
                                //         val.standard ==
                                //             element.standard.toString() &&
                                //         val.isApproved == false)
                                //     .toList()
                                //   ..sort((a, b) =>
                                //       b.percentage!.compareTo(a.percentage!));
                                // if (standardFilterData.isNotEmpty) {
                                Get.offAll(
                                  () => ResponsiveLayout(
                                    desktopBody: OnTapFinalDataScreen(
                                      std: element.standard.toString(),
                                    ),
                                    mobileBody: OnTapFinalDataScreen(
                                      std: element.standard.toString(),
                                    ),
                                    tabletBody: OnTapFinalDataScreen(
                                      std: element.standard.toString(),
                                    ),
                                  ),
                                );
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
                                // height: 63.h,
                                // width: 187.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.r),
                                  border: Border.all(
                                      color: ColorUtils.greyEA, width: 3.w),
                                  color: ColorUtils.greyF9,
                                ),
                                child: Center(
                                    child: CustomText(
                                  element.standard ?? "",
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AssetsUtils.poppins,
                                  color: ColorUtils.black3F,
                                )),
                              ),
                            );
                          },
                        );
                      }),
                  SizedBox(
                    width: Get.width / 3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
