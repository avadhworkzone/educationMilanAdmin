import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsivedashboard/common_widget/custom_text.dart';
import 'package:responsivedashboard/common_widget/no_data_found.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/utils/enum_utils.dart';
import 'package:responsivedashboard/utils/string_utils.dart';
import 'package:responsivedashboard/view/screens/dashboard.dart';
import 'package:responsivedashboard/view/web/dashboard/common_method.dart';
import 'package:responsivedashboard/firbaseService/student_service/student_details_services.dart';
import 'package:responsivedashboard/common_widget/column_text.dart';
import '../../utils/share_preference.dart';
import '../web/dashboard/student_details.dart';

class StandardViseDataStudentScreen extends StatefulWidget {
  final String stdId;

  const StandardViseDataStudentScreen({Key? key, required this.stdId}) : super(key: key);

  @override
  State<StandardViseDataStudentScreen> createState() => _StandardViseDataStudentScreenState();
}

class _StandardViseDataStudentScreenState extends State<StandardViseDataStudentScreen> {
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
          icon: const Icon(Icons.arrow_back_ios, color: ColorUtils.white),
          onPressed: () => Get.offAll(() => const DesktopScaffold()),
        ),
        title: CustomText(
          widget.stdId,
          color: ColorUtils.white,
          fontSize: 20.sp,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          buildSearchBox(),
          SizedBox(height: 20.h),
          StreamBuilder<List<StudentModel>>(
            stream: StudentService.getStudentDataForAdmin(
              familyCode: PreferenceManagerUtils.getFamilyCode(),
              standard: widget.stdId,
              isApproved: false,
              statusEnum: StatusEnum.pending,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: Get.height * 0.5,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return SizedBox(
                  height: Get.height * 0.5,
                  child: Center(child: noDataFound()),
                );
              }

              studentData = snapshot.data!;
              stdFilteredData = filterStudentData(searchController.text);

              if (stdFilteredData.isEmpty) {
                return SizedBox(
                  height: Get.height * 0.5,
                  child: Center(child: noDataFound()),
                );
              }

              return buildDataTable(); // your method that returns PaginatedDataTable
            },
          )

        ],
      ),
    );
  }

  Widget buildSearchBox() {
    return SizedBox(
      width: 300.w,
      child: TextFormField(
        controller: searchController,
        cursorColor: ColorUtils.grey66,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search_rounded, color: ColorUtils.grey66),
          hintText: "Search student...",
          hintStyle: const TextStyle(color: ColorUtils.grey66, fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: ColorUtils.greyD0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: ColorUtils.primaryColor),
          ),
        ),
        style: const TextStyle(
          color: ColorUtils.black,
          fontFamily: "FiraSans",
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget buildDataTable() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: ColorUtils.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: PaginatedDataTable(
        initialFirstRowIndex: 0,
        onPageChanged: (int rowIndex) {},
        source: YourDataTableSource(
          stdFilteredData,
          deleteUserWithReason,
          commonDialogEdit,
          commonCheckUncheck,
          context,
        ),
        dataRowMaxHeight: 60.h,
        dataRowMinHeight: 45.h,
        rowsPerPage: _rowsPerPage,
        columnSpacing: 10.w,
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
          DataColumn(label: commonText(StringUtils.accept)),
        ],
      ),
    );
  }

  List<StudentModel> filterStudentData(String query) {
    if (query.isEmpty) {
      return studentData;
    }
    return studentData.where((student) {
      return (student.studentFullName ?? '').toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
