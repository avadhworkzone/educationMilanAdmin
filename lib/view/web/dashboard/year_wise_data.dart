import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/utils/pdf_service.dart';
import 'package:responsivedashboard/firbaseService/student_service/student_details_services.dart';
import 'package:responsivedashboard/common_widget/custom_text.dart';
import 'package:responsivedashboard/common_widget/common_btn.dart';

class YearWiseExportScreen extends StatefulWidget {
  const YearWiseExportScreen({Key? key}) : super(key: key);

  @override
  State<YearWiseExportScreen> createState() => _YearWiseExportScreenState();
}

class _YearWiseExportScreenState extends State<YearWiseExportScreen> {
  late int selectedYear;
  bool isDownloading = false;
  List<int> availableYears = [];
  List<StudentModel> allStudents = [];

  @override
  void initState() {
    super.initState();
    _fetchStudentYears();
  }

  Future<void> _fetchStudentYears() async {
    try {
      allStudents = await StudentService.getFinalStudentDataAllFuture();

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

      setState(() {
        availableYears = years;
        selectedYear = years.isNotEmpty ? years.first : DateTime.now().year;
      });
    } catch (e) {
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

      Get.snackbar('Success', 'PDF downloaded for year $selectedYear');
    } catch (e ,s) {
      Get.snackbar('Error', 'Failed to download PDF: $e');
      print("--=-=-=-=-= $e \n   $s" );
    } finally {
      setState(() => isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(width: Get.width/3, height: Get.height/2,
            decoration: BoxDecoration(
              color: ColorUtils.white,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.grey,width: 3),
              boxShadow: [
                BoxShadow(color: Colors.blue.withOpacity(0.3),blurRadius: 10)
              ]
            ),
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    "Select Year",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 10),
                  availableYears.isEmpty
                      ? const CircularProgressIndicator()
                      : DropdownButton<int>(
                    value: selectedYear,
                    items: availableYears.map((year) {
                      return DropdownMenuItem<int>(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedYear = value);
                      }
                    },
                  ),
                  const SizedBox(height: 30),
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
      ),
    );
  }
}
