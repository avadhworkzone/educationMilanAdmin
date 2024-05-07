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
import 'package:responsivedashboard/utils/enum_utils.dart';
import 'package:responsivedashboard/utils/string_utils.dart';
import 'package:responsivedashboard/responsiveLayout/responsive_layout.dart';
import 'package:responsivedashboard/view/mobile/bottombar_mobile/mobile_bottombar.dart';
import 'package:responsivedashboard/view/tablet/bottomebar_tablet/tablet_bottombar.dart';
import 'package:responsivedashboard/view/web/dashboard/common_method.dart';
import 'package:responsivedashboard/view/web/dashboard/dashboard.dart';
import 'package:responsivedashboard/view/web/dashboard/student_details.dart';

import '../../../../common_widget/no_data_found.dart';
import '../../../../firbaseService/student_service/student_details_services.dart';

class StandardViseDataStudentScreen extends StatefulWidget {
  final String stdId;

  const StandardViseDataStudentScreen({Key? key, required this.stdId})
      : super(key: key);

  @override
  State<StandardViseDataStudentScreen> createState() =>
      _StandardViseDataStudentScreenState();
}

class _StandardViseDataStudentScreenState
    extends State<StandardViseDataStudentScreen> {
  TextEditingController searchController = TextEditingController();
  int _rowsPerPage = 10;
  List<StudentModel> stdFilteredData = [];
  List<StudentModel> studentData = [];

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
            ),
          ),
          title: CustomText(
            widget.stdId,
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
                StreamBuilder<List<StudentModel>>(
                    stream: StudentService.getStudentData(
                        standard: widget.stdId,
                        isApproved: false,
                        statusEnum: StatusEnum.pending),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox(
                            height: Get.height,
                            width: Get.width,
                            child: const Center(
                                child: CircularProgressIndicator()));
                      }
                      if (snapshot.hasError) {
                        return SizedBox(
                            height: Get.height,
                            width: Get.width,
                            child: noDataFound());
                      }

                      studentData = snapshot.data!;
                      stdFilteredData =
                          filterStudentData(searchController.text);
                      return stdFilteredData.isEmpty
                          ? SizedBox(
                              height: Get.height,
                              width: Get.width,
                              child: noDataFound())
                          : Column(
                              children: [
                                /// Textfield Row
                                SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.01,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: Get.width * 0.02,
                                        ),
                                        SizedBox(
                                          width: 300.w,
                                          child: TextFormField(
                                            cursorColor: ColorUtils.grey66,
                                            controller: searchController,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            style: const TextStyle(
                                                color: ColorUtils.black,
                                                fontFamily: "FiraSans",
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400),
                                            decoration: InputDecoration(
                                              prefixIcon: const Icon(
                                                Icons.search_rounded,
                                                color: ColorUtils.grey66,
                                              ),
                                              contentPadding: EdgeInsets.only(
                                                  left: Get.width * 0.02),
                                              hintText: "Search",
                                              hintStyle: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: ColorUtils.grey66),
                                              errorBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              ColorUtils.red)),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                      color:
                                                          ColorUtils.greyD0)),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1.0,
                                                    color: ColorUtils.greyD0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)),
                                              ),
                                              disabledBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1.0,
                                                    color: ColorUtils.greyD0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)),
                                              ),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)),
                                                borderSide: BorderSide(
                                                    width: 1.0,
                                                    color: ColorUtils.greyD0),
                                              ),
                                            ),
                                            onChanged: (value) {
                                              setState(() {});
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: Theme(
                                          data: ThemeData.light().copyWith(
                                              cardColor: Colors.white),
                                          child: PaginatedDataTable(
                                            initialFirstRowIndex: 0,
                                            onPageChanged: (int rowIndex) {},
                                            source: YourDataTableSource(
                                                stdFilteredData,
                                                deleteUserWithReason,
                                                commonDialogEdit,
                                                commonCheckUncheck,
                                                context),
                                            dataRowMaxHeight: 60.w,
                                            dataRowMinHeight: 40.w,
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
                                                ),
                                              ),
                                              DataColumn(
                                                label: commonText(
                                                  StringUtils.percentage,
                                                ),
                                              ),
                                              DataColumn(
                                                  label: commonText(
                                                StringUtils.imageUrl,
                                              )),
                                              DataColumn(
                                                label: commonText(
                                                  StringUtils.delete,
                                                ),
                                              ),
                                              DataColumn(
                                                label: commonText(
                                                  StringUtils.edit,
                                                ),
                                              ),
                                              DataColumn(
                                                label: commonText(
                                                  StringUtils.accept,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                    }),
              ],
            ),
          ],
        ));
  }

  List<StudentModel> filterStudentData(String query) {
    if (query.isEmpty) {
      return studentData;
    } else {
      return studentData.where((student) {
        // Customize this condition based on your search criteria.
        return student.studentFullName
                ?.toLowerCase()
                .contains(query.toLowerCase()) ??
            false;
      }).toList();
    }
  }
}
