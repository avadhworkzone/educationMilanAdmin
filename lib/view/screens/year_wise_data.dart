import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsivedashboard/common_widget/custom_text.dart';
import 'package:responsivedashboard/common_widget/common_btn.dart';
import 'package:responsivedashboard/firbaseService/student_service/student_details_services.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/utils/pdf_service.dart';

class YearWiseExportScreen extends StatefulWidget {
  const YearWiseExportScreen({Key? key}) : super(key: key);

  @override
  State<YearWiseExportScreen> createState() => _YearWiseExportScreenState();
}

class _YearWiseExportScreenState extends State<YearWiseExportScreen> {
  late int selectedYear;
  bool isDownloading = false;
  bool isLoading = true;
  List<int> availableYears = [];
  List<StudentModel> allStudents = [];

  @override
  void initState() {
    super.initState();
    _fetchStudentYears();
  }

  Future<void> _fetchStudentYears() async {
    try {
      final List<StudentModel> studentList = await StudentService.getFinalStudentDataAllFuture(isApproved: true).first;
      allStudents = studentList;

      final years = allStudents
          .where((s) => s.createdDate != null && s.createdDate!.isNotEmpty)
          .map((s) {
        try {
          return DateTime.parse(s.createdDate!).year;
        } catch (_) {
          return null;
        }
      })
          .whereType<int>()
          .toSet()
          .toList()
        ..sort((a, b) => b.compareTo(a)); // Sort descending

      if (mounted) {
        setState(() {
          availableYears = years;
          selectedYear = years.isNotEmpty ? years.first : DateTime.now().year;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching years: $e');
      if (mounted) {
        setState(() => isLoading = false);
      }
      Get.snackbar('Error', 'Failed to load year options: $e');
    }
  }

  Future<void> _downloadYearWise() async {
    setState(() => isDownloading = true);
    try {
      await PdfService.generateYearWiseReport(
        year: selectedYear,
        allStudents: allStudents,
      );
      Get.snackbar('Success', 'Report downloaded for year $selectedYear');
    } catch (e, s) {
      Get.snackbar('Error', 'Failed to download: $e');
      print("--Download Error--\n$e\n$s");
    } finally {
      setState(() => isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Expanded(
      child: Center(
        child: availableYears.isEmpty?CustomText('No data Found'):Padding(
          padding: EdgeInsets.all(isMobile ? 16.w : 32.w),
          child: isLoading
              ? const CircularProgressIndicator()
              : Container(
            width: isMobile ? Get.width/2 : Get.width / 3,
            height: isMobile ? null : Get.height / 2,
            padding: EdgeInsets.all(isMobile ? 24.w : 50.w),
            decoration: BoxDecoration(
              color: ColorUtils.white,
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(color: Colors.grey, width: 2.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                  "Select Year",
                  fontSize: isMobile ? 40.sp : 22.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: 300.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.5.w),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: DropdownButton<int>(
                      isExpanded: true,
                      underline: const SizedBox(), // 🔥 Remove default underline
                      value: selectedYear,
                      items: availableYears.map((year) {
                        return DropdownMenuItem<int>(
                          value: year,
                          child: Text(
                            year.toString(),
                            style: TextStyle(fontSize: isMobile ? 40.sp : 16.sp),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedYear = value);
                        }
                      },
                    ),
                  )
                  ,
                ),
                SizedBox(height: 30.h),
                isDownloading
                    ? const CircularProgressIndicator()
                    : InkWell(
                  onTap: _downloadYearWise,
                  child: commonButton("Download Result"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
