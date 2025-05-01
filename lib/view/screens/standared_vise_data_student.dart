import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:responsivedashboard/common_widget/custom_text.dart';
import 'package:responsivedashboard/common_widget/no_data_found.dart';
import 'package:responsivedashboard/common_widget/octa_image.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/utils/enum_utils.dart';
import 'package:responsivedashboard/utils/string_utils.dart';
import 'package:responsivedashboard/view/screens/dashboard.dart';
import 'package:responsivedashboard/view/web/dashboard/common_method.dart';
import 'package:responsivedashboard/firbaseService/student_service/student_details_services.dart';
import 'package:responsivedashboard/common_widget/column_text.dart';
import '../../utils/share_preference.dart';
import 'student_details_row.dart';

class StandardViseDataStudentScreen extends StatefulWidget {
  final String stdId;

  const StandardViseDataStudentScreen({Key? key, required this.stdId}) : super(key: key);

  @override
  State<StandardViseDataStudentScreen> createState() => _StandardViseDataStudentScreenState();
}

class _StandardViseDataStudentScreenState extends State<StandardViseDataStudentScreen> {
  TextEditingController searchController = TextEditingController();
  int _rowsPerPage = 10;
  List<StudentModel> studentData = [];

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
          body: ListView(
            padding: EdgeInsets.all(24.w),
            children: [
              buildSearchBox(isMobile),
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
                  final filteredData = filterStudentData(searchController.text);

                  if (filteredData.isEmpty) {
                    return SizedBox(
                      height: Get.height * 0.5,
                      child: Center(child: noDataFound()),
                    );
                  }

                  return buildDataTable(filteredData);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildSearchBox(bool isMobile) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: isMobile ? double.infinity : 400.w,
        child: TextFormField(
          controller: searchController,
          cursorColor: ColorUtils.grey66,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search_rounded, color: ColorUtils.grey66),
            hintText: "Search student...",
            hintStyle: const TextStyle(color: ColorUtils.grey66, fontSize: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: ColorUtils.primaryColor)),
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
    );
  }

  Widget buildDataTable(List<StudentModel> dataList) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      return ListView.builder(
        itemCount: dataList.length,
        shrinkWrap: true,
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () => deleteUserWithReason(
                          student.studentId ?? '',
                          student.isApproved ?? false,
                          student.fcmToken ?? '',() {
                            setState(() {

                            });
                          },
                        ),
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                      IconButton(
                        onPressed: () => commonDialogEdit(
                          student.result,
                          student.percentage,
                          student.standard,
                          student.studentFullName,
                          student.studentId ?? '',
                          student.userId ?? '',
                          student.villageName ?? '',
                          student.createdDate,
                          mobileNumber: student.mobileNumber ?? '',
                          isApproved: student.isApproved ?? false,
                          result: student.result,
                          fcmToken: student.fcmToken ?? '',
                          imageId: student.imageId,
                          reason: student.reason,
                          status: student.status,
                          onSuccess: () {
                            setState(() {}); // ✅ Refresh without leaving screen
                          },
                        ),
                        icon: const Icon(Icons.edit, color: Colors.orange),
                      ),
                      IconButton(
                        onPressed: () => commonCheckUncheck(
                          student.studentId ?? '',
                          student.fcmToken ?? '',() {
                            setState(() {

                            });
                          },
                        ),
                        icon: const Icon(Icons.check_circle, color: Colors.green),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 1000),
      child: PaginatedDataTable(
        source: YourDataTableSource(
          dataList,
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
  Future<void> _showImageDialog(BuildContext context, String imageResult) async {
    final List<String> imageUrls = imageResult.split(',');
    final PageController controller = PageController();
    int currentIndex = 0;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.black,
              insetPadding: EdgeInsets.zero,
              child: Stack(
                children: [
                  PhotoViewGallery.builder(
                    itemCount: imageUrls.length,
                    pageController: controller,
                    onPageChanged: (index) => setState(() => currentIndex = index),
                    backgroundDecoration: const BoxDecoration(color: Colors.black),
                    builder: (BuildContext context, int index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: NetworkImage(imageUrls[index]),
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered * 2,
                        heroAttributes: PhotoViewHeroAttributes(tag: imageUrls[index]),
                      );
                    },
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.close, color: Colors.white, size: 28),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        '${currentIndex + 1} / ${imageUrls.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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
      return (student.studentFullName ?? '')
          .toLowerCase()
          .contains(query.toLowerCase());
    }).toList();
  }
}
