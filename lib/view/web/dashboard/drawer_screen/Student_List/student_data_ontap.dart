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
import 'package:get/get.dart';
import 'package:responsivedashboard/common_widget/column_text.dart';
import 'package:responsivedashboard/common_widget/common_btn.dart';
import 'package:responsivedashboard/common_widget/custom_text.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/utils/string_utils.dart';
import 'package:responsivedashboard/view/web/dashboard/common_method.dart';
import 'package:responsivedashboard/view/screens/dashboard.dart';
import 'package:responsivedashboard/view/screens/student_details_row.dart';

class OnTapStudentDataScreen extends StatefulWidget {
  final String studentId;
  final List<StudentModel> yourDataList;
  final List<StudentModel>? filteredData;

  const OnTapStudentDataScreen(
      {Key? key,
      required this.studentId,
      required this.yourDataList,
      this.filteredData})
      : super(key: key);

  @override
  State<OnTapStudentDataScreen> createState() => _OnTapStudentDataScreenState();
}

class _OnTapStudentDataScreenState extends State<OnTapStudentDataScreen> {
  TextEditingController searchController = TextEditingController();
  int _rowsPerPage = 10;
  RangeValues _currentRangeValues = const RangeValues(1, 100);
  List<StudentModel> filteredData = [];

  @override
  void initState() {
    super.initState();
    filteredData = widget.yourDataList
        .where((element) =>
            element.standard == widget.studentId && element.isApproved == false)
        .toList()
      ..sort((a, b) => b.percentage!.compareTo(a.percentage!));
  }

  @override
  Widget build(BuildContext context) {

    // var filteredData = widget.yourDataList
    //     .where((element) =>
    //         element.standard == widget.studentId && element.isApproved == true)
    //     .toList()..sort((a, b) => b.percentage!.compareTo(a.percentage!));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorUtils.primaryColor,
          leading: IconButton(
              onPressed: () {
                Get.offAll(() => const  DesktopScaffold());
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: ColorUtils.white,
              )),
          title: CustomText(
            "Selected Final Data",
            color: ColorUtils.white,
            fontSize: 20.w,
          ),
        ),
        body: ListView(
          children: [
            Column(
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
                                  contentPadding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(20)),
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
                                  if (value.isNotEmpty) {
                                    filteredData = widget.yourDataList
                                        .where((element) =>
                                            element.studentFullName!
                                                .toLowerCase()
                                                .contains(value) &&
                                            element.standard ==
                                                widget.studentId &&
                                            element.isApproved == false)
                                        .toList()
                                      ..sort((a, b) => b.percentage!
                                          .compareTo(a.percentage!));
                                  } else {
                                    filteredData = widget.yourDataList
                                        .where((element) =>
                                            element.standard ==
                                                widget.studentId &&
                                            element.isApproved == false)
                                        .toList()
                                      ..sort((a, b) => b.percentage!
                                          .compareTo(a.percentage!));
                                  }
                                  setState(() {});
                                },
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  filterDataDialog();
                                },
                                icon: const Icon(Icons.filter_alt))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: double.infinity,
                          child: Theme(
                            data: ThemeData.light()
                                .copyWith(cardColor: Colors.white),
                            child: PaginatedDataTable(
                              initialFirstRowIndex: 0,
                              onPageChanged: (int rowIndex) {
                                log("rowIndex :- $rowIndex");
                                log("filteredData length :- ${filteredData.length}");
                                int remainingRows =
                                    filteredData.length - rowIndex;
                                print("remainingRows :- $remainingRows");
                                setState(() {
                                  _rowsPerPage =
                                      remainingRows >= 10 ? 10 : remainingRows;
                                  log("_rowsPerPage :- $_rowsPerPage");
                                });
                              },
                              source: YourDataTableSource(
                                  filteredData,
                                  deleteUserWithReason,
                                  commonDialogEdit,
                                  commonCheckUncheck,
                                  // commonRejectDialog,
                                  context),
                              dataRowMaxHeight: 60.w,
                              dataRowMinHeight: 40.w,
                              // headingRowColor: MaterialStateColor.resolveWith(
                              //     (Set<MaterialState> states) {
                              //   if (states.contains(MaterialState.selected)) {
                              //     return Colors.blue;
                              //   }
                              //   return Colors.white;
                              // }),
                              rowsPerPage: _rowsPerPage,
                              columnSpacing: 8,
                              columns: [
                                DataColumn(
                                    label: commonText(
                                  StringUtils.number,
                                )),
                                DataColumn(
                                    label: commonText(
                                  StringUtils.mobileNumber,
                                )),
                                DataColumn(
                                    label: commonText(
                                  StringUtils.date,
                                )),
                                DataColumn(
                                    label: commonText(
                                  StringUtils.studentName,
                                )),
                                DataColumn(
                                    label: commonText(
                                  StringUtils.villageName,
                                )),
                                DataColumn(
                                    label: commonText(
                                  StringUtils.percentage,
                                )),
                                DataColumn(
                                    label: commonText(
                                  StringUtils.imageUrl,
                                )),
                                DataColumn(
                                    label: commonText(
                                  StringUtils.delete,
                                )),
                                DataColumn(
                                    label: commonText(
                                  StringUtils.edit,
                                )),
                                DataColumn(
                                    label: commonText(
                                  "Accept",
                                )),
                                // DataColumn(
                                //     label: commonText(
                                //   "Reject",
                                // )),
                              ],
                            ),
                          )),
                    ],
                  ),
                )

                // Container(
                //   padding: const EdgeInsets.all(8.0),
                //   decoration: const BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.all(Radius.circular(10)),
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       SizedBox(
                //           width: double.infinity,
                //           child: Theme(
                //             data: ThemeData.light().copyWith(cardColor: Colors.white),
                //             child: PaginatedDataTable(
                //               initialFirstRowIndex: 0,
                //               onPageChanged: (int rowIndex) {
                //                 log("rowIndex :- $rowIndex");
                //                 log("filteredData length :- ${filteredData.length}");
                //                 int remainingRows = filteredData.length - rowIndex;
                //                 print("remainingRows :- $remainingRows");
                //
                //                 setState(() {
                //                   _rowsPerPage = remainingRows >= 10 ? 10 : remainingRows;
                //                   log("_rowsPerPage :- $_rowsPerPage");
                //                 });
                //               },
                //               source: FinalDataTableSource(filteredData, commonDeleteDialog, commonDialogEdit, context),
                //               dataRowMaxHeight: 60.w,
                //               dataRowMinHeight: 40.w,
                //               // headingRowColor: MaterialStateColor.resolveWith(
                //               //     (Set<MaterialState> states) {
                //               //   if (states.contains(MaterialState.selected)) {
                //               //     return Colors.blue;
                //               //   }
                //               //   return Colors.white;
                //               // }),
                //               rowsPerPage: _rowsPerPage,
                //               columnSpacing: 8,
                //               columns: [
                //                 DataColumn(
                //                     label: commonText(
                //                       StringUtils.number,
                //                     )),
                //                 DataColumn(
                //                     label: commonText(
                //                       StringUtils.resultTitle,
                //                     )),
                //                 DataColumn(
                //                     label: commonText(
                //                       StringUtils.date,
                //                     )),
                //                 DataColumn(
                //                     label: commonText(
                //                       StringUtils.studentName,
                //                     )),
                //                 DataColumn(
                //                     label: commonText(
                //                       StringUtils.villageName,
                //                     )),
                //                 DataColumn(
                //                     label: commonText(
                //                       StringUtils.percentage,
                //                     )),
                //                 DataColumn(
                //                     label: commonText(
                //                       StringUtils.imageUrl,
                //                     )),
                //                 DataColumn(
                //                     label: commonText(
                //                       StringUtils.edit,
                //                     )),
                //                 DataColumn(
                //                     label: commonText(
                //                       StringUtils.delete,
                //                     )),
                //               ],
                //             ),
                //           )),
                //     ],
                //   ),
                // ),
              ],
            ),
          ],
        )
        // ListView.builder(
        //   itemCount: filteredData.length,
        //   itemBuilder: (context, index) {
        //     final dataApprove = filteredData[index];
        //     return Column(
        //       children: [
        //         CustomText(
        //           dataApprove.studentFullName.toString(),
        //           color: ColorUtils.black32,
        //           fontSize: 13.sp,
        //           fontWeight: FontWeight.w600,
        //         )
        //       ],
        //     );
        //   },
        // ),
        );
  }

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
                        padding:
                            EdgeInsets.only(right: ScreenUtil().setWidth(5)),
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
      filteredData = widget.yourDataList
          .where((element) =>
              element.standard == widget.studentId &&
              element.isApproved == false &&
              element.percentage! >= minPercentage &&
              element.percentage! <= maxPercentage)
          .toList()
        ..sort((a, b) => b.percentage!.compareTo(a.percentage!));
    });
  }
}
