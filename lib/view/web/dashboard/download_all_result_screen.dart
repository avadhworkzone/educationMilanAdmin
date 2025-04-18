import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsivedashboard/common_widget/custom_assets.dart';
import 'package:responsivedashboard/firbaseService/student_service/student_details_services.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/utils/image_utils.dart';
import 'package:responsivedashboard/utils/pdf_service.dart';

class DownloadAllResultScreen extends StatefulWidget {
  const DownloadAllResultScreen({super.key});

  @override
  State<DownloadAllResultScreen> createState() => _DownloadAllResultScreenState();
}

class _DownloadAllResultScreenState extends State<DownloadAllResultScreen> {

  Future<void> downloadFullReport() async {
    try {
      final finalStudData = await StudentService.getFinalAllStudentDataFuture();

      List<List<StudentModel>> standardLists = [];

      for (var item in finalStudData) {
        String? standard = item.standard;
        bool found = false;

        for (var standardList in standardLists) {
          if (standardList.isNotEmpty && standardList[0].standard == standard) {
            standardList.add(item);
            found = true;
            break;
          }
        }

        if (!found) {
          standardLists.add([item]);
        }
      }

      PdfService.generateAllReportPdf(reportList: standardLists);
    } on Exception catch (e) {
      print("****PDF ERROR****$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child : Center(
        child: InkWell(
          borderRadius: BorderRadius.circular(500 ),
          onTap: ()=>downloadFullReport(),
          child: LocalAssets(
              imagePath: AssetsUtils.download,
              width: Get.width * 0.2,
            height: Get.height * 0.2,
            imgColor: ColorUtils.primaryColor,
          ),
        ),
      ),
    );
  }
}
