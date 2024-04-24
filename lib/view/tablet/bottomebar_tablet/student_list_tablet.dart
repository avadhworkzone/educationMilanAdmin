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
import 'package:responsivedashboard/firbaseService/user_service/user_service.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/model/user_model.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/utils/share_preference.dart';
import 'package:responsivedashboard/utils/string_utils.dart';
import 'package:responsivedashboard/view/mobile/auth/login_mobile.dart';
import 'package:responsivedashboard/view/tablet/auth/login_tablet.dart';
import 'package:responsivedashboard/view/web/auth/desktop_login_form.dart';
import 'package:responsivedashboard/responsiveLayout/responsive_layout.dart';
import 'package:responsivedashboard/view/web/dashboard/common_method.dart';

class StudentListDataTablet extends StatefulWidget {
  final int? studentListTabIndex;
  final List<StudentModel>? filteredDataTab;
  final List<UserResModel>? allUserData1;
  const StudentListDataTablet(
      {Key? key,
      this.studentListTabIndex,
      this.filteredDataTab,
      this.allUserData1})
      : super(key: key);

  @override
  State<StudentListDataTablet> createState() => _HomeScreenState();
}

List<UserResModel> allUserData1 = [];

class _HomeScreenState extends State<StudentListDataTablet> {
  TextEditingController searchController = TextEditingController();
  int _rowsPerPage = 10;
  bool isLoggingOut = false;
  RangeValues _currentRangeValues = const RangeValues(1, 100);
  List<StudentModel> filteredData = [];
  final StandardService firestoreService = StandardService();

  @override
  void initState() {
    super.initState();
    fetchData();
    //TODO : change
    // fetchDataOfStandard();

    StandardService.getStandards();
  }

  void fetchData() async {
    try {
      // var stream = StudentService.getStudentData();
      var userStream = UserService.getUserData();
//       await for (var data in stream) {
//         setState(() async {
//           filteredData.clear();
// //TODO : change
//           // yourDataList = data;
//           for (var element in data) {
//             if (element.isApproved == false) {
//               filteredData.add(element);
//             }
//           }
//
//           await for (var data in userStream) {
//             setState(() {
//               userData = data;
//               userfilterData = List.from(data);
//               allUserData1 = data;
//               PreferenceManagerUtils.setData(data);
//             });
//           }
//         });
//       }
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
    return ListView(
      children: [
        SizedBox(
          height: Get.width * 0.01,
        ),

        /// Textfield Row
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
                    CustomText(
                      StringUtils.allResult,
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
                    Row(
                      children: [
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
                                  borderSide:
                                      BorderSide(color: ColorUtils.red)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: ColorUtils.greyD0)),
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
                              //TODO : change
                              // var data = filteredData;
                              // if (value.isNotEmpty) {
                              //   data = yourDataList
                              //       .where((element) => element.studentFullName!
                              //           .toLowerCase()
                              //           .contains(value))
                              //       .toList();
                              // } else {
                              //   data = yourDataList;
                              // }
                              // setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(width: 5),
                        IconButton(
                            onPressed: () {
                              filterDataDialog();
                            },
                            icon: const Icon(Icons.filter_alt))
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 20.h),
        //TODO : change
        // GridView.builder(
        //   padding: EdgeInsets.only(right: 25.w),
        //   shrinkWrap: true,
        //   itemCount: yourStandardList.length,
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //       crossAxisCount: 5,
        //       mainAxisSpacing: 40.h,
        //       childAspectRatio: 5,
        //       crossAxisSpacing: 15.w),
        //   itemBuilder: (context, index) {
        //     var element = yourStandardList[index];
        //     return InkWell(
        //       onTap: () {
        //         List<StudentModel> stdFilteredData = [];
        //         stdFilteredData = yourDataList
        //             .where((val) =>
        //                 val.standard == element.standard.toString() &&
        //                 val.isApproved == false)
        //             .toList()
        //           ..sort((a, b) => b.percentage!.compareTo(a.percentage!));
        //         print("stdFilteredData == ${stdFilteredData}");
        //         if (stdFilteredData.isNotEmpty) {
        //           Get.offAll(() => ResponsiveLoginLayout(
        //                 desktopBodyLogin: OnTapFinalDataScreen(
        //                   studentId: element.standard.toString(),
        //                   yourDataList: yourDataList,
        //                 ),
        //                 mobileBodyLogin: OnTapFinalDataScreen(
        //                   studentId: element.standard.toString(),
        //                   yourDataList: yourDataList,
        //                 ),
        //                 tabletBodyLogin: StandardViseDataStudentScreen(
        //                   stdId: element.standard.toString(),
        //                   yourDataList: stdFilteredData,
        //                 ),
        //               ));
        //         } else {
        //           ToastUtils.showCustomToast(
        //               timeInSecForIosWeb: 2,
        //               context: context,
        //               gravity: ToastGravity.TOP,
        //               title: "No Data in This Standard");
        //         }
        //         // finalDataApprovedDialog(element.standard.toString());
        //       },
        //       child: Container(
        //         // height: 63.h,
        //         // width: 187.w,
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(15.r),
        //           border: Border.all(color: ColorUtils.greyEA, width: 3.w),
        //           color: ColorUtils.greyF9,
        //         ),
        //         child: Center(
        //             child: CustomText(
        //           element.standard ?? "",
        //           fontSize: 19.sp,
        //           fontWeight: FontWeight.w600,
        //           fontFamily: AssetsUtils.poppins,
        //           color: ColorUtils.black3F,
        //         )),
        //       ),
        //     );
        //   },
        // ),
      ],
    );
  }

  ///===================filter data===============///

  void filterDataDialog() {
    double selectedMinValue = _currentRangeValues.start;
    double selectedMaxValue = _currentRangeValues.end;
    showDialog(
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: StatefulBuilder(builder: (context, update) {
            return SizedBox(
              width: 200.w,
              height: 200.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FlutterSlider(
                    onDragStarted: (handlerIndex, lowerValue, upperValue) {},
                    values: const [0, 0],
                    handlerAnimation:
                        const FlutterSliderHandlerAnimation(scale: 1),
                    disabled: false,
                    rangeSlider: true,
                    tooltip: FlutterSliderTooltip(
                      format: (String value) {
                        return '${double.parse(value).toInt()}';
                      },
                      positionOffset:
                          FlutterSliderTooltipPositionOffset(top: 20.0),
                      direction: FlutterSliderTooltipDirection.top,
                      alwaysShowTooltip: true,
                      disableAnimation: true,
                      boxStyle: FlutterSliderTooltipBox(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: ColorUtils.greyE7))),
                    ),
                    max: 100,
                    min: 0,
                    jump: true,
                    trackBar: FlutterSliderTrackBar(
                      inactiveTrackBarHeight: 24,
                      activeTrackBarHeight: 24,
                      inactiveTrackBar: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xFFE4E6E7),
                      ),
                      activeTrackBar: const BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(20)),
                          color: Colors.purple),
                    ),
                    handler: FlutterSliderHandler(
                        decoration: const BoxDecoration(),
                        child: const CircleAvatar(
                          radius: 13,
                          backgroundColor: ColorUtils.primaryColor,
                          child: CircleAvatar(
                              radius: 8, backgroundColor: ColorUtils.white),
                        )),
                    rightHandler: FlutterSliderHandler(
                        decoration: const BoxDecoration(),
                        child: const CircleAvatar(
                          radius: 10,
                          backgroundColor: ColorUtils.primaryColor,
                        )),
                    onDragging: (handlerIndex, lowerValue, upperValue) {
                      selectedMinValue = lowerValue;
                      selectedMaxValue = upperValue;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 5.w),
                        child: InkWell(
                          onTap: () {
                            Get.back();
                            _applyFilter(selectedMinValue, selectedMaxValue);
                          },
                          child: commonButton(StringUtils.done),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
        );
      },
      context: context,
    );
  }

  void _applyFilter(double minPercentage, double maxPercentage) {
    setState(() {
      _currentRangeValues = RangeValues(minPercentage, maxPercentage);
    });

    filteredData = filteredData
        .where((element) =>
            element.percentage! >= minPercentage &&
            element.percentage! <= maxPercentage)
        .toList();

    filteredData.sort((a, b) => a.percentage!.compareTo(b.percentage!));

    setState(() {});
  }
}
