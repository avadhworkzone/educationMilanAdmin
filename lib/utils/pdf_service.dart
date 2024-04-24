import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'dart:html' as html;

import 'package:responsivedashboard/utils/string_utils.dart';

class PdfService {
  static int finalPageIndex = 22;
  static int maxPageCount = 30;
  static int rank = 1;
  static late Font gujaratiFont;

  static getGujaratiFont() async {
    final font = await rootBundle.load("fonts/NotoSansGujarati.ttf");
    gujaratiFont = pw.Font.ttf(font);
  }

  static Future<void> generateReportPdf({
    required List<StudentModel> reportList,
    required String std,
  }) async {
    rank = 1;
    if (reportList.isEmpty) {
      // showToast(title: VariablesUtils.noDataFound);
      return;
    }
    final logoImg =
        (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List();

    try {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Container(
                width: double.infinity,
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColor.fromHex('#41a7f5'))),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      decoration:
                          pw.BoxDecoration(color: PdfColor.fromHex('#133178')),
                      padding: const pw.EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: pw.Row(children: [
                        pw.ClipRRect(
                          verticalRadius: 10.sp,
                          horizontalRadius: 10.sp,
                          child: pw.Image(pw.MemoryImage(logoImg),
                              width: 60, height: 60),
                        ),
                        // pw.Image(pw.MemoryImage(logoImg),
                        //     width: 60, height: 60),
                        pw.SizedBox(width: 20),
                        pw.Text("Katrodiya Parivar",
                            style: pw.TextStyle(
                              fontSize: 30.sp,
                              color: PdfColor.fromHex('#FFFFFF'),
                            )),
                      ]),
                    ),
                    pw.SizedBox(height: 5.sp),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                      child: pw.Row(children: [
                        pw.Text("STD : ${std}",
                            style: pw.TextStyle(fontSize: 13.sp)),
                        pw.Spacer(),
                        pw.Text(
                            DateFormat('dd MMM yyyy').format(DateTime.now()),
                            style: pw.TextStyle(fontSize: 13.sp)),
                      ]),
                    ),
                    pw.SizedBox(
                      height: 30,
                    ),
                    pw.Container(
                        decoration: pw.BoxDecoration(
                            border: pw.Border.all(
                                color: PdfColor.fromHex('#133178'))),
                        margin: const pw.EdgeInsets.symmetric(horizontal: 5),
                        child: pw.Column(children: [
                          transactionHeader(),
                          pw.ListView.builder(
                            itemCount: reportList.length > finalPageIndex
                                ? finalPageIndex
                                : reportList.length,
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 2, vertical: 2),
                            itemBuilder: (context, index) {
                              final result = reportList[index];
                              return transactionRow(result, index, reportList);
                            },
                          ),
                        ])),
                  ],
                ),
              ); // Center
            }),
      );

      int pageCount =
          ((reportList.length - finalPageIndex) / maxPageCount).ceil();

      print('pageCount:=>$pageCount reportList:=>${reportList.length}');

      for (int pageIndex = 0; pageIndex < pageCount; pageIndex++) {
        int rowIndex = finalPageIndex + (pageIndex * maxPageCount);
        int maxLength = maxPageCount;
        if ((rowIndex + maxPageCount) > reportList.length) {
          maxLength = reportList.length - rowIndex;
        }

        pdf.addPage(
            getPage(
                maxLength: maxLength,
                startIndex: rowIndex,
                reportList: reportList,
                isLast: pageIndex == pageCount - 1),
            index: pageIndex + 1);
      }

      var savedFile = await pdf.save();
      List<int> fileInts = List.from(savedFile);
      html.AnchorElement(
          href:
              "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}")
        ..setAttribute(
            "download", "${DateTime.now().millisecondsSinceEpoch}.pdf")
        ..click();
    } on Exception catch (e) {
      print('GENERATE PDF ERROR => $e');
      return;
    }
  } // Page

  static pw.Page getPage(
      {required int maxLength,
      required int startIndex,
      required List<StudentModel> reportList,
      required bool isLast}) {
    return pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
              margin: const pw.EdgeInsets.only(top: 5),
              padding: const pw.EdgeInsets.all(2),
              decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColor.fromHex('#274ca3'))),
              child: pw.Column(children: [
                pw.Column(
                  children: List.generate(maxLength, (index) {
                    final result = reportList[startIndex + index];
                    return transactionRow(
                        result, startIndex + index, reportList);
                  }),
                ),
              ]));
        });
  }

  static transactionHeader() {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#133178'),
        //    border: pw.Border.all(color: PdfColor.fromHex('#0747a1'))
      ),
      child: pw.Row(
        children: [
          pw.Expanded(
              flex: 1,
              child: pw.Center(
                  child: pw.Text('Rank',
                      // fontWeight: FontWeight.w600,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontSize: 12.sp,
                          color: PdfColor.fromHex('#FFFFFF'),
                          fontBold: pw.Font.courierBold())))),
          // pw.Expanded(
          //     flex: 1,
          //     child: pw.Center(
          //         child: pw.Text('Date',
          //             style: pw.TextStyle(
          //                 fontSize: 12.sp,
          //                 color: PdfColor.fromHex('#FFFFFF'),
          //                 fontBold: pw.Font.courierBold())))),
          pw.Expanded(
              flex: 3,
              child: pw.Center(
                  child: pw.Text('Student Name',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontSize: 12.sp,
                          color: PdfColor.fromHex('#FFFFFF'),
                          fontBold: pw.Font.courierBold())))),
          pw.Expanded(
              flex: 3,
              child: pw.Center(
                  child: pw.Text(StringUtils.mobileNumber,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontSize: 12.sp,
                          color: PdfColor.fromHex('#FFFFFF'),
                          fontBold: pw.Font.courierBold())))),
          pw.Expanded(
              flex: 2,
              child: pw.Center(
                  child: pw.Text('Village Name',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontSize: 12.sp,
                          color: PdfColor.fromHex('#FFFFFF'),
                          fontBold: pw.Font.courierBold())))),
          pw.Expanded(
              flex: 2,
              child: pw.Center(
                  child: pw.Text('Percentage',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontSize: 12.sp,
                          color: PdfColor.fromHex('#FFFFFF'),
                          fontBold: pw.Font.courierBold())))),
          pw.Expanded(
              flex: 3,
              child: pw.Center(
                  child: pw.Text('Other',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontSize: 12.sp,
                          color: PdfColor.fromHex('#FFFFFF'),
                          fontBold: pw.Font.courierBold())))),
        ],
      ),
    );
  }

  static pw.Container transactionRow(
    StudentModel result,
    int index,
    List<StudentModel> reportList,
  ) {
    return pw.Container(
        padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 2),
        color: index.isOdd
            ? PdfColor.fromHex('#c6d7ff')
            : PdfColor.fromHex('#FFFFFF'),
        child: pw.Row(
          children: [
            pw.Expanded(
                flex: 1,
                child: pw.Center(
                    child: pw.Text("${getRank(result, index, reportList)}",
                        textAlign: pw.TextAlign.center,
                        style: TextStyle(font: gujaratiFont)))),
            // pw.Expanded(
            //     flex: 1,
            //     child: pw.Center(
            //         child: pw.Text(DateFormat("dd MMM yyyy").format(
            //             DateTime.parse(result.createdDate ??
            //                 DateTime.now().toString()))))),
            pw.Expanded(
                flex: 3,
                child: pw.Center(
                    child: pw.Text("${result.studentFullName}",
                        textAlign: pw.TextAlign.center,
                        style: TextStyle(font: gujaratiFont)))),
            pw.Expanded(
                flex: 3,
                child: pw.Center(
                    child: pw.Text(
                  "${result.mobileNumber}",
                  style: TextStyle(font: gujaratiFont),
                  textAlign: pw.TextAlign.center,
                ))),
            pw.Expanded(
                flex: 2,
                child: pw.Center(
                    child: pw.Text("${result.villageName}",
                        textAlign: pw.TextAlign.center,
                        style: TextStyle(font: gujaratiFont)))),
            pw.Expanded(
                flex: 2,
                child: pw.Center(
                    child: pw.Text(
                  '${result.percentage}%',
                  style: TextStyle(font: gujaratiFont),
                  textAlign: pw.TextAlign.center,
                ))),
            pw.Expanded(flex: 3, child: pw.Center(child: pw.Text(''))),
          ],
        ));
  }

  static int getRank(
    StudentModel result,
    int index,
    List<StudentModel> reportList,
  ) {
    if (index == 0) {
      return rank;
    }
    final previousStud = reportList[index - 1];
    if (result.percentage == previousStud.percentage) {
      return rank;
    } else {
      rank += 1;
      return rank;
    }
  }
}
