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

      // List<StudentModel> stdJuniorResultList = [];
      // List<StudentModel> stdSeniorResultList = [];
      // List<StudentModel> std1ResultList = [];
      // List<StudentModel> std2ResultList = [];
      // List<StudentModel> std3ResultList = [];
      // List<StudentModel> std4ResultList = [];
      // List<StudentModel> std5ResultList = [];
      // List<StudentModel> std6ResultList = [];
      // List<StudentModel> std7ResultList = [];
      // List<StudentModel> std8ResultList = [];
      // List<StudentModel> std9ResultList = [];
      // List<StudentModel> std10ResultList = [];
      // List<StudentModel> std11ResultList = [];
      // List<StudentModel> std12ResultList = [];
      // for (var element in finalStudData) {
      //   switch (element.standard) {
      //     case "STD Junior KG (Eng)":
      //       stdJuniorResultList.add(element);
      //       break;
      //     case "STD Senior KG (Eng)":
      //       stdSeniorResultList.add(element);
      //       break;
      //     case "std1":
      //       std1ResultList.add(element);
      //       break;
      //     case "std2":
      //       std2ResultList.add(element);
      //       break;
      //     case "std3":
      //       std1ResultList.add(element);
      //       break;
      //     case "std4":
      //       std2ResultList.add(element);
      //       break;
      //     case "std5":
      //       std1ResultList.add(element);
      //       break;
      //     case "std6":
      //       std2ResultList.add(element);
      //       break;
      //     case "std7":
      //       std1ResultList.add(element);
      //       break;
      //     case "std8":
      //       std2ResultList.add(element);
      //       break;
      //     case "std9":
      //       std1ResultList.add(element);
      //       break;
      //     case "std10":
      //       std2ResultList.add(element);
      //       break;
      //     case "std11":
      //       std1ResultList.add(element);
      //       break;
      //     case "std12":
      //       std2ResultList.add(element);
      //       break;
      //   }
      // }
      // List<List<StudentModel>> finalResultData = [
      //   if (std1ResultList.isNotEmpty) std1ResultList,
      //   if (std2ResultList.isNotEmpty) std2ResultList,
      //   if (std3ResultList.isNotEmpty) std3ResultList,
      //   if (std4ResultList.isNotEmpty) std4ResultList,
      //   if (std5ResultList.isNotEmpty) std5ResultList,
      //   if (std6ResultList.isNotEmpty) std6ResultList,
      //   if (std7ResultList.isNotEmpty) std7ResultList,
      //   if (std8ResultList.isNotEmpty) std8ResultList,
      //   if (std9ResultList.isNotEmpty) std9ResultList,
      //   if (std10ResultList.isNotEmpty)std10ResultList,
      //   if (std11ResultList.isNotEmpty)std11ResultList,
      //   if (std12ResultList.isNotEmpty)std12ResultList,
      // ];
      //
      // // PdfService.generateReportPdf(reportList: finalStudData, std: "1");
      // // final finalStudData =
      // //     await StudentService.getFinalStudentDataFuture(standard: widget.std);
      //
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
          borderRadius: BorderRadius.circular(500),
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
