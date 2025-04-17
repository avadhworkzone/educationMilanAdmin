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
import 'package:responsivedashboard/firbaseService/student_service/student_details_services.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/responsiveLayout/responsive_layout.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/utils/enum_utils.dart';
import 'package:responsivedashboard/utils/pdf_service.dart';
import 'package:responsivedashboard/utils/string_utils.dart';
import 'package:responsivedashboard/view/mobile/bottombar_mobile/mobile_bottombar.dart';
import 'package:responsivedashboard/view/tablet/bottomebar_tablet/tablet_bottombar.dart';
import 'package:responsivedashboard/view/web/dashboard/common_method.dart';
import 'package:responsivedashboard/view/web/dashboard/dashboard.dart';
import 'package:responsivedashboard/view/web/dashboard/final_data_row_data.dart';

import '../../../common_widget/no_data_found.dart';

class OnTapFinalDataScreen extends StatefulWidget {
  final String std;

  const OnTapFinalDataScreen({Key? key, required this.std}) : super(key: key);

  @override
  State<OnTapFinalDataScreen> createState() => _OnTapFinalDataScreenState();
}

// class _OnTapFinalDataScreenState extends State<OnTapFinalDataScreen> {
//   TextEditingController searchController = TextEditingController();
//   final RangeValues _currentRangeValues = const RangeValues(1, 100);
//   int _rowsPerPage = 10;
//   List<StudentModel> studentList = [];
//
//   Future<void> downloadReport() async {
//     try {
//       final finalStudData = await StudentService.getFinalStudentDataFuture(standard: widget.std);
//
//       PdfService.generateReportPdf(reportList: finalStudData, std: widget.std);
//
//
//     } on Exception catch (e) {
//       print("****PDF ERROR****$e");
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: ColorUtils.primaryColor,
//           leading: IconButton(
//               onPressed: () {
//                 Get.offAll(() => const ResponsiveLayout(
//                       desktopBody: DesktopScaffold(),
//                       mobileBody: MobileBottombar(),
//                       tabletBody: TabletBottombar(),
//                     ));
//               },
//               icon: const Icon(
//                 Icons.arrow_back_ios,
//                 color: ColorUtils.white,
//               )),
//           title: CustomText(
//             widget.std,
//             color: ColorUtils.white,
//             fontSize: 20.w,
//           ),
//         ),
//         body: ListView(
//           children: [
//             Column(
//               children: [
//                 SizedBox(
//                   height: Get.width * 0.01,
//                 ),
//
//                 /// Textfield Row
//
//                 SizedBox(
//                   width: double.infinity,
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: Get.width * 0.01,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Row(
//                         //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         //   children: [
//                         //     CustomText(
//                         //       StringUtils.allResult,
//                         //       color: ColorUtils.black32,
//                         //       fontSize: 30,
//                         //       fontWeight: FontWeight.w500,
//                         //     ),
//                         //   ],
//                         // ),
//                         SizedBox(
//                           height: Get.width * 0.02,
//                         ),
//                         Row(
//                           //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             // Row(
//                             //   children: [
//                             //     commonButton(StringUtils.addNew),
//                             //     SizedBox(
//                             //       width: Get.width * 0.01,
//                             //     ),
//                             //     InkWell(
//                             //       onTap: () {},
//                             //       child: const CustomText(
//                             //         "1 row selected",
//                             //         color: ColorUtils.black10,
//                             //         fontSize: 14,
//                             //         fontWeight: FontWeight.w400,
//                             //       ),
//                             //     ),
//                             //   ],
//                             // ),
//                             Spacer(),
//
//                             /// Search Textfield
//                             SizedBox(
//                               width: 300.w,
//                               child: TextFormField(
//                                 cursorColor: ColorUtils.grey66,
//                                 controller: searchController,
//                                 keyboardType: TextInputType.emailAddress,
//                                 style: const TextStyle(
//                                     color: ColorUtils.black,
//                                     fontFamily: "FiraSans",
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w400),
//                                 decoration: InputDecoration(
//                                   prefixIcon:
//                                       const Icon(Icons.search_rounded, color: ColorUtils.grey66),
//                                   contentPadding: EdgeInsets.only(left: Get.width * 0.02),
//                                   hintText: "Search",
//                                   hintStyle: const TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w400,
//                                       color: ColorUtils.grey66),
//                                   errorBorder: const OutlineInputBorder(
//                                       borderSide: BorderSide(color: ColorUtils.red)),
//                                   border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                       borderSide: const BorderSide(color: ColorUtils.greyD0)),
//                                   focusedBorder: const OutlineInputBorder(
//                                     borderSide: BorderSide(width: 1.0, color: ColorUtils.greyD0),
//                                     borderRadius: BorderRadius.all(Radius.circular(8)),
//                                   ),
//                                   disabledBorder: const OutlineInputBorder(
//                                     borderSide: BorderSide(width: 1.0, color: ColorUtils.greyD0),
//                                     borderRadius: BorderRadius.all(Radius.circular(8)),
//                                   ),
//                                   enabledBorder: const OutlineInputBorder(
//                                     borderRadius: BorderRadius.all(Radius.circular(8)),
//                                     borderSide: BorderSide(width: 1.0, color: ColorUtils.greyD0),
//                                   ),
//                                 ),
//                                 onChanged: (value) {
//                                   // if (value.isNotEmpty) {
//                                   //   filteredData = widget.yourDataList
//                                   //       .where((element) =>
//                                   //           element.studentFullName!
//                                   //               .toLowerCase()
//                                   //               .contains(value) &&
//                                   //           element.standard ==
//                                   //               widget.studentId &&
//                                   //           element.isApproved == false)
//                                   //       .toList()
//                                   //     ..sort((a, b) => b.percentage!
//                                   //         .compareTo(a.percentage!));
//                                   // } else {
//                                   //   filteredData = widget.yourDataList
//                                   //       .where((element) =>
//                                   //           element.standard ==
//                                   //               widget.studentId &&
//                                   //           element.isApproved == false)
//                                   //       .toList()
//                                   //     ..sort((a, b) => b.percentage!
//                                   //         .compareTo(a.percentage!));
//                                   // }
//                                   // setState(() {});
//                                 },
//                               ),
//                             ),
//                             IconButton(
//                                 onPressed: () {
//                                   filterDataDialog();
//                                 },
//                                 icon: const Icon(Icons.filter_alt)),
//                             IconButton(
//                                 onPressed: downloadReport,
//                                 icon: const Icon(Icons.download_for_offline))
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 Container(
//                   padding: const EdgeInsets.all(8.0),
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       StreamBuilder<List<StudentModel>>(
//                           stream: StudentService.getStudentData(
//                               isApproved: true,
//                               standard: widget.std,
//                               statusEnum: StatusEnum.approve),
//                           builder: (context, snapshot) {
//                             if (!snapshot.hasData) {
//                               return const Center(child: CircularProgressIndicator());
//                             }
//                             if (snapshot.hasError) {
//                               return noDataFound();
//                             }
//                             studentList = snapshot.data!;
//                             return SizedBox(
//                                 width: double.infinity,
//                                 child: Theme(
//                                   data: ThemeData.light().copyWith(cardColor: Colors.white),
//                                   child: PaginatedDataTable(
//                                     initialFirstRowIndex: 0,
//                                     onPageChanged: (int rowIndex) {
//                                       log("rowIndex :- $rowIndex");
//                                       log("filteredData length :- ${studentList.length}");
//                                       int remainingRows = studentList.length - rowIndex;
//                                       print("remainingRows :- $remainingRows");
//
//                                       setState(() {
//                                         _rowsPerPage = remainingRows >= 10 ? 10 : remainingRows;
//                                         log("_rowsPerPage :- $_rowsPerPage");
//                                       });
//                                     },
//                                     source: FinalDataTableSource(studentList, deleteUserWithReason,
//                                         commonDialogEdit, context),
//                                     dataRowMaxHeight: 60.w,
//                                     dataRowMinHeight: 40.w,
//                                     // headingRowColor: MaterialStateColor.resolveWith(
//                                     //     (Set<MaterialState> states) {
//                                     //   if (states.contains(MaterialState.selected)) {
//                                     //     return Colors.blue;
//                                     //   }
//                                     //   return Colors.white;
//                                     // }),
//                                     rowsPerPage: _rowsPerPage,
//                                     columnSpacing: 8,
//                                     columns: [
//                                       DataColumn(
//                                           label: commonText(
//                                         StringUtils.number,
//                                       )),
//                                       DataColumn(
//                                           label: commonText(
//                                         StringUtils.mobileNumber,
//                                       )),
//                                       DataColumn(
//                                           label: commonText(
//                                         StringUtils.date,
//                                       )),
//                                       DataColumn(
//                                           label: commonText(
//                                         StringUtils.studentName,
//                                       )),
//                                       DataColumn(
//                                           label: commonText(
//                                         StringUtils.villageName,
//                                       )),
//                                       DataColumn(
//                                           label: commonText(
//                                         StringUtils.percentage,
//                                       )),
//                                       DataColumn(
//                                           label: commonText(
//                                         StringUtils.imageUrl,
//                                       )),
//                                       DataColumn(
//                                           label: commonText(
//                                         StringUtils.delete,
//                                       )),
//                                       DataColumn(
//                                           label: commonText(
//                                         StringUtils.edit,
//                                       )),
//                                     ],
//                                   ),
//                                 ));
//                           }),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         )
//         // ListView.builder(
//         //   itemCount: filteredData.length,
//         //   itemBuilder: (context, index) {
//         //     final dataApprove = filteredData[index];
//         //     return Column(
//         //       children: [
//         //         CustomText(
//         //           dataApprove.studentFullName.toString(),
//         //           color: ColorUtils.black32,
//         //           fontSize: 13.sp,
//         //           fontWeight: FontWeight.w600,
//         //         )
//         //       ],
//         //     );
//         //   },
//         // ),
//         );
//   }
//
//   void filterDataDialog() {
//     double selectedMinValue = _currentRangeValues.start;
//     double selectedMaxValue = _currentRangeValues.end;
//     showDialog(
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Colors.white,
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(
//               Radius.circular(10.0),
//             ),
//           ),
//           child: StatefulBuilder(builder: (context, update) {
//             return SizedBox(
//               width: 200.w,
//               height: 200.h,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   FlutterSlider(
//                     onDragStarted: (handlerIndex, lowerValue, upperValue) {},
//                     values: const [0, 0],
//                     handlerAnimation: const FlutterSliderHandlerAnimation(scale: 1),
//                     disabled: false,
//                     rangeSlider: true,
//                     tooltip: FlutterSliderTooltip(
//                       format: (String value) {
//                         return '${double.parse(value).toInt()}';
//                       },
//                       positionOffset: FlutterSliderTooltipPositionOffset(top: 20.0),
//                       direction: FlutterSliderTooltipDirection.top,
//                       alwaysShowTooltip: true,
//                       disableAnimation: true,
//                       boxStyle: FlutterSliderTooltipBox(
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               shape: BoxShape.rectangle,
//                               borderRadius: BorderRadius.circular(10),
//                               border: Border.all(color: ColorUtils.greyE7))),
//                     ),
//                     max: 100,
//                     min: 0,
//                     jump: true,
//                     trackBar: FlutterSliderTrackBar(
//                       inactiveTrackBarHeight: 24,
//                       activeTrackBarHeight: 24,
//                       inactiveTrackBar: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: const Color(0xFFE4E6E7),
//                       ),
//                       activeTrackBar: const BoxDecoration(
//                           borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
//                           color: Colors.purple),
//                     ),
//                     handler: FlutterSliderHandler(
//                         decoration: const BoxDecoration(),
//                         child: const CircleAvatar(
//                           radius: 13,
//                           backgroundColor: ColorUtils.primaryColor,
//                           child: CircleAvatar(radius: 8, backgroundColor: ColorUtils.white),
//                         )),
//                     rightHandler: FlutterSliderHandler(
//                         decoration: const BoxDecoration(),
//                         child: const CircleAvatar(
//                           radius: 10,
//                           backgroundColor: ColorUtils.primaryColor,
//                         )),
//                     onDragging: (handlerIndex, lowerValue, upperValue) {
//                       selectedMinValue = lowerValue;
//                       selectedMaxValue = upperValue;
//                     },
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.only(right: ScreenUtil().setWidth(5)),
//                         child: InkWell(
//                           onTap: () {
//                             Get.back();
//                             _applyFilter(selectedMinValue, selectedMaxValue);
//                           },
//                           child: commonButton(StringUtils.done),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             );
//           }),
//         );
//       },
//       context: context,
//     );
//   }
//
//   void _applyFilter(double minPercentage, double maxPercentage) {
//     // setState(() {
//     //   _currentRangeValues = RangeValues(minPercentage, maxPercentage);
//     //   filteredData = widget.yourDataList
//     //       .where((element) =>
//     //           element.standard == widget.studentId &&
//     //           element.isApproved == false &&
//     //           element.percentage! >= minPercentage &&
//     //           element.percentage! <= maxPercentage)
//     //       .toList()
//     //     ..sort((a, b) => b.percentage!.compareTo(a.percentage!));
//     // });
//   }
// }
class _OnTapFinalDataScreenState extends State<OnTapFinalDataScreen> {
  TextEditingController searchController = TextEditingController();
  final RangeValues _currentRangeValues = const RangeValues(1, 100);
  int _rowsPerPage = 10;
  List<StudentModel> studentList = [];
  String selectedExportType = 'Excel';
  bool isDownloading = false;

  Future<void> downloadReport() async {
    setState(() => isDownloading = true);
    try {
      final finalStudData = await StudentService.getFinalStudentDataFuture(standard: widget.std);
      if (selectedExportType == 'PDF') {
        await PdfService.generateReportPdf(reportList: finalStudData, std: widget.std);
      } else {
        await PdfService.generateReportExcel(reportList: finalStudData, std: widget.std);
      }
    } catch (e) {
      print("****Export ERROR****$e");
    } finally {
      setState(() => isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorUtils.primaryColor,
          leading: IconButton(
              onPressed: () {
                Get.offAll(() => const ResponsiveLayout(
                  desktopBody: DesktopScaffold(),
                  mobileBody: MobileBottombar(),
                  tabletBody: TabletBottombar(),
                ));
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: ColorUtils.white,
              )),
          title: CustomText(
            widget.std,
            color: ColorUtils.white,
            fontSize: 20.w,
          ),
        ),
        body: ListView(
          children: [
            Column(
              children: [
                SizedBox(height: Get.width * 0.01),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.01),
                  child: Row(
                    children: [
                      Spacer(),
                      SizedBox(
                        width: 300.w,
                        child: TextFormField(
                          controller: searchController,
                          cursorColor: ColorUtils.grey66,
                          onChanged: (value) => setState(() {}),
                          style: const TextStyle(
                              color: ColorUtils.black,
                              fontFamily: "FiraSans",
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search_rounded, color: ColorUtils.grey66),
                            hintText: "Search",
                            hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: ColorUtils.grey66),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: ColorUtils.greyD0)),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(width: 1.0, color: ColorUtils.greyD0),
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(width: 1.0, color: ColorUtils.greyD0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorUtils.greyD0),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: DropdownButton<String>(
                          value: selectedExportType,
                          underline: SizedBox(),
                          icon: Icon(Icons.arrow_drop_down),
                          items: ['PDF', 'Excel'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedExportType = newValue!;
                            });
                          },
                        ),
                      ),
                      // IconButton(
                      //     onPressed: () {
                      //       filterDataDialog();
                      //     },
                      //     icon: const Icon(Icons.filter_alt)),
                      isDownloading
                          ? const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                          : IconButton(
                          onPressed: downloadReport,
                          icon: const Icon(Icons.download_for_offline))
                    ],
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
                      StreamBuilder<List<StudentModel>>(
                          stream: StudentService.getStudentData(
                              isApproved: true,
                              standard: widget.std,
                              statusEnum: StatusEnum.approve),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return noDataFound();
                            }
                            studentList = snapshot.data!
                                .where((s) => s.studentFullName!.toLowerCase().contains(searchController.text.toLowerCase()))
                                .toList().where((element){
  final dateStr = element.createdDate;
                                if (dateStr
                                    == null || dateStr.isEmpty) return false;
                                try {
                                  final date = DateTime.parse(dateStr);
                                  return date.year == 2025;
                                } catch (e) {
                                  return false;
                                }                            },).toList();

                            return SizedBox(
                              width: double.infinity,
                              child: Theme(
                                data: ThemeData.light().copyWith(cardColor: Colors.white),
                                child: PaginatedDataTable(
                                  initialFirstRowIndex: 0,
                                  onPageChanged: (int rowIndex) {
                                    int remainingRows = studentList.length - rowIndex;
                                    setState(() {
                                      _rowsPerPage = remainingRows >= 10 ? 10 : remainingRows;
                                    });
                                  },
                                  source: FinalDataTableSource(studentList, deleteUserWithReason,
                                      commonDialogEdit, context),
                                  dataRowMaxHeight: 60.w,
                                  dataRowMinHeight: 40.w,
                                  rowsPerPage: _rowsPerPage,
                                  columnSpacing: 8,
                                  columns: [
                                    DataColumn(label: commonText(StringUtils.number)),
                                    DataColumn(label: commonText(StringUtils.mobileNumber)),
                                    DataColumn(label: commonText(StringUtils.date)),
                                    DataColumn(label: commonText(StringUtils.studentName)),
                                    DataColumn(label: commonText(StringUtils.villageName)),
                                    DataColumn(label: commonText(StringUtils.percentage)),
                                    DataColumn(label: commonText(StringUtils.imageUrl)),
                                    DataColumn(label: commonText(StringUtils.delete)),
                                    DataColumn(label: commonText(StringUtils.edit)),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  void filterDataDialog() {
    double selectedMinValue = _currentRangeValues.start;
    double selectedMaxValue = _currentRangeValues.end;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: StatefulBuilder(
            builder: (context, update) {
              return SizedBox(
                width: 300.w,
                height: 200.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlutterSlider(
                      values: [_currentRangeValues.start, _currentRangeValues.end],
                      rangeSlider: true,
                      max: 100,
                      min: 0,
                      jump: true,
                      handlerAnimation: const FlutterSliderHandlerAnimation(scale: 1),
                      tooltip: FlutterSliderTooltip(
                        alwaysShowTooltip: true,
                        disableAnimation: true,
                        direction: FlutterSliderTooltipDirection.top,
                        format: (String value) => '${double.parse(value).toInt()}',
                        boxStyle: FlutterSliderTooltipBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: ColorUtils.greyE7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        positionOffset: FlutterSliderTooltipPositionOffset(top: 20.0),
                      ),
                      trackBar: FlutterSliderTrackBar(
                        inactiveTrackBarHeight: 24,
                        activeTrackBarHeight: 24,
                        inactiveTrackBar: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xFFE4E6E7),
                        ),
                        activeTrackBar: const BoxDecoration(
                          borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
                          color: Colors.purple,
                        ),
                      ),
                      handler: FlutterSliderHandler(
                        child: const CircleAvatar(
                          radius: 13,
                          backgroundColor: ColorUtils.primaryColor,
                          child: CircleAvatar(radius: 8, backgroundColor: ColorUtils.white),
                        ),
                      ),
                      rightHandler: FlutterSliderHandler(
                        child: const CircleAvatar(
                          radius: 10,
                          backgroundColor: ColorUtils.primaryColor,
                        ),
                      ),
                      onDragging: (handlerIndex, lowerValue, upperValue) {
                        selectedMinValue = lowerValue;
                        selectedMaxValue = upperValue;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: ScreenUtil().setWidth(5)),
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
            },
          ),
        );
      },
    );
  }

  void _applyFilter(double minPercentage, double maxPercentage) {
    // TODO: Implement filter logic if required.
  }
}