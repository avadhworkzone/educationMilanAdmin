import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsivedashboard/common_widget/custom_text.dart';
import 'package:responsivedashboard/common_widget/no_data_found.dart';
import 'package:responsivedashboard/common_widget/octa_image.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/view/screens/dashboard.dart';
import 'package:responsivedashboard/view/web/dashboard/common_method.dart';
import 'package:responsivedashboard/firbaseService/student_service/student_details_services.dart';

import '../../utils/pdf_service.dart';

class FinalStandardViseDataScreen extends StatefulWidget {
  final String stdId;

  const FinalStandardViseDataScreen({Key? key, required this.stdId}) : super(key: key);

  @override
  State<FinalStandardViseDataScreen> createState() => _FinalStandardViseDataScreenState();
}

class _FinalStandardViseDataScreenState extends State<FinalStandardViseDataScreen> {
  TextEditingController searchController = TextEditingController();
  int _rowsPerPage = 10;
  List<StudentModel> studentData = [];
  List<StudentModel> filteredData=[];
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final isMobile = constraints.maxWidth < 600;

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
              fontSize: isMobile ? 40.sp : 20.sp,
            ),
          ),
          body: StreamBuilder<List<StudentModel>>(
            stream: StudentService.getApprovedStudentData(standard: widget.stdId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: noDataFound());
              }

              studentData = snapshot.data!;
               filteredData = filterStudentData(searchController.text);

              if (filteredData.isEmpty) {
                return Center(child: noDataFound());
              }

              return Column(
                children: [
                  buildSearchBox(isMobile,filteredData),
                  SizedBox(height: 20.h),
                 Expanded(
                   child: ListView(children: [
                     isMobile
                         ? buildMobileList(filteredData)
                         : buildWebTable(filteredData),
                   ],),
                 )
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget buildSearchBox(bool isMobile,List<StudentModel> dataList) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: searchController,
              cursorColor: ColorUtils.grey66,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded, color: ColorUtils.grey66),
                hintText: "Search student...",
                hintStyle: const TextStyle(color: ColorUtils.grey66, fontSize: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
          ),
          IconButton(
              onPressed: ()async {
                await PdfService.generateReportExcel(reportList: dataList, std:widget.stdId);

              },
              icon:  Icon(Icons.download_for_offline,color: ColorUtils.primaryColor,size: isMobile?40.h:50.w,))
        ],
      ),
    );
  }

  Widget buildMobileList(List<StudentModel> dataList) {
    return ListView.builder(
      itemCount: dataList.length,
      shrinkWrap: true,
      padding: EdgeInsets.all(10),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final student = dataList[index];

        return Card(
          margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if ((student.result?.isNotEmpty ?? false))
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          height: 200.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: GestureDetector(
                              onTap: () {
                                _showImageDialog(context, student.result.toString());
                              },
                              child: NetWorkOcToAssets(imgUrl: student.result.toString()),
                            ),
                          ),
                        ),
                      ),
                    SizedBox(width: 12.h),
                    Expanded(
                      child: Column(
                        children: [
                          buildRowItem("Student Name", student.studentFullName ?? "-", isMobile: true),
                          buildRowItem("Mobile", student.mobileNumber ?? "-", isMobile: true),
                          buildRowItem("Village", student.villageName ?? "-", isMobile: true),
                          buildRowItem("Standard", student.standard ?? "-", isMobile: true),
                          buildRowItem("Percentage", "${student.percentage ?? 0}%", isMobile: true),
                          buildRowItem("Date", student.createdDate?.split("T").first ?? "-", isMobile: true),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => deleteUserWithReason(
                        student.studentId ?? '',
                        student.isApproved ?? false,
                        student.fcmToken ?? '',
                            () => setState(() {}),
                      ),
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildWebTable(List<StudentModel> dataList) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PaginatedDataTable(
        source: WebDataTableSource(dataList, context, refreshCallback: () => setState(() {})),
        rowsPerPage: _rowsPerPage,
        columnSpacing: 15.w,
        columns: [
          DataColumn(label: Text("No")),
          DataColumn(label: Text("Mobile")),
          DataColumn(label: Text("Student Name")),
          DataColumn(label: Text("Village")),
          DataColumn(label: Text("Percentage")),
          DataColumn(label: Text("Date")),
          DataColumn(label: Text("Image")),
          DataColumn(label: Text("Delete")),
        ],
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.network(imageUrl, fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget buildRowItem(String label, String value, {bool isMobile = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 40.sp : 12.sp,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: isMobile ? 40.sp : 12.sp,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<StudentModel> filterStudentData(String query) {
    if (query.isEmpty) return studentData;
    return studentData.where((student) {
      return (student.studentFullName ?? '').toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}

class WebDataTableSource extends DataTableSource {
  final List<StudentModel> dataList;
  final BuildContext context;
  final VoidCallback refreshCallback;

  WebDataTableSource(this.dataList, this.context, {required this.refreshCallback});

  @override
  DataRow? getRow(int index) {
    if (index >= dataList.length) return null;
    final student = dataList[index];

    return DataRow(cells: [
      DataCell(Text('${index + 1}')),
      DataCell(Text(student.mobileNumber ?? '-')),
      DataCell(Text(student.studentFullName ?? '-')),
      DataCell(Text(student.villageName ?? '-')),
      DataCell(Text("${student.percentage ?? 0}%")),
      DataCell(Text(student.createdDate?.split("T").first ?? '-')),

      // ✅ Show Image cell
      DataCell(
        student.result?.isNotEmpty ?? false
            ? Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Image.network(student.result.toString(), fit: BoxFit.contain),
                  ),
                );
              },
              child: Image.network(
                student.result.toString(),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
            : const Text("-"),
      ),

      // Delete button
      DataCell(
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            deleteUserWithReason(
              student.studentId ?? '',
              student.isApproved ?? false,
              student.fcmToken ?? '',
              refreshCallback,
            );
          },
        ),
      ),
    ]);
  }

  @override
  int get rowCount => dataList.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
