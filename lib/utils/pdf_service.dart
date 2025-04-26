import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'dart:html' as html;
import 'package:universal_html/html.dart' as universal_html;
import 'package:responsivedashboard/utils/string_utils.dart';

import '../firbaseService/student_service/student_details_services.dart';

class PdfService {
  static int finalPageIndex = 22;
  static int maxPageCount = 30;
  static int rank = 1;
  static late Font gujaratiFont;

  static getGujaratiFont() async {
    final font = await rootBundle.load("fonts/NotoSansGujarati-Regular.ttf");
    gujaratiFont = pw.Font.ttf(font);
  }


  static Future<void> generateYearWiseReport({
    required int year,
    required List<StudentModel> allStudents,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    // Set column widths
    sheet.setColWidth(0, 8);   // Rank
    sheet.setColWidth(1, 65);  // Name
    sheet.setColWidth(2, 25);  // Mobile
    sheet.setColWidth(3, 17);  // Village
    sheet.setColWidth(4, 15);  // Percentage

    // 🔄 Get dynamic standard list from StudentService
    final List<StudentModel> allStdData = await StudentService.getStandardData().first;
    final List<String> standardOrder = allStdData
        .map((s) => s.standard?.trim() ?? '')
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList();
    // Top spacing before standard section
    sheet.appendRow(['']);
    sheet.appendRow(['']);
    sheet.appendRow(['------------------------------------------------------------------------------ BORDA PARIVAR SNEHMILAN ------------------------------------------------------------------------------']);
    // Top spacing before standard section
    sheet.appendRow(['']);
    for (final std in standardOrder) {
      final students = allStudents.where((s) {
        final matchStd = s.standard?.trim() == std.trim();
        if (!matchStd) return false;
        try {
          final created = DateTime.parse(s.createdDate ?? '');
          return created.year == year;
        } catch (_) {
          return false;
        }
      }).toList();

      if (students.isEmpty) continue;

      // Top spacing before standard section
      sheet.appendRow(['']);
      sheet.appendRow(['']);

      // Title row
      sheet.appendRow(['================================================== $std ===================================================']);

      // Spacer after title
      sheet.appendRow(['']);
      sheet.appendRow(['']);

      // Header
      sheet.appendRow(['Rank', 'Name', 'Mobile', 'Village', 'Percentage']);

      for (int i = 0; i < students.length; i++) {
        final s = students[i];
        sheet.appendRow([
          '${i + 1}',
          s.studentFullName ?? '',
          s.mobileNumber ?? '',
          s.villageName ?? '',
          '${s.percentage ?? '-'}%',
        ]);
      }

      // Bottom spacing after section
      sheet.appendRow(['']);
      sheet.appendRow(['']);
    }

    // Save and download
    final excelBytes = excel.encode();
    if (excelBytes == null) return;

    final base64Data = base64Encode(excelBytes);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final content =
        'data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,$base64Data';

    final anchor = html.AnchorElement(href: content)
      ..setAttribute('download', 'Yearly_Student_Report_$timestamp.xlsx')
      ..click();
  }






  static Future<void> generateReportPdf({
    required List<StudentModel> reportList,
    required String std,
  }) async {
    rank = 1;
    if (reportList.isEmpty) return;

    await getGujaratiFont();
    final logoImg = (await rootBundle.load('assets/images/logo.jpg')).buffer.asUint8List();

    final pdf = pw.Document();
    final currentDate = DateFormat('dd MMM yyyy').format(DateTime.now());

    const int rowsPerPage = 25;
    final totalPages = (reportList.length / rowsPerPage).ceil();

    for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
      final start = pageIndex * rowsPerPage;
      final end = (start + rowsPerPage > reportList.length)
          ? reportList.length
          : start + rowsPerPage;
      final currentPageItems = reportList.sublist(start, end);

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4.landscape,
          margin: const pw.EdgeInsets.all(16),
          build: (context) {
            return [
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                color: PdfColor.fromHex('#133178'),
                child: pw.Row(
                  children: [
                    pw.ClipRRect(
                      verticalRadius: 10,
                      horizontalRadius: 10,
                      child: pw.Image(pw.MemoryImage(logoImg), width: 60, height: 60),
                    ),
                    pw.SizedBox(width: 20),
                    pw.Text(
                      "Borda Parivar Snehmilan",
                      style: pw.TextStyle(
                        font: gujaratiFont,
                        fontSize: 30,
                        color: PdfColor.fromHex('#FFFFFF'),
                      ),
                    ),
                    pw.Spacer(),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text("STD: $std", style: pw.TextStyle(font: gujaratiFont, fontSize: 13, color: PdfColors.white)),
                        pw.Text(currentDate, style: pw.TextStyle(font: gujaratiFont, fontSize: 13, color: PdfColors.white)),
                      ],
                    )
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColor.fromHex('#133178')),
                ),
                child: pw.Table.fromTextArray(
                  headers: ['Rank', 'Name', 'Mobile', 'Village', 'Percentage'],
                  headerStyle: pw.TextStyle(font: gujaratiFont, fontWeight: pw.FontWeight.bold),
                  headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  cellStyle: pw.TextStyle(font: gujaratiFont),
                  data: List.generate(currentPageItems.length, (index) {
                    final s = currentPageItems[index];
                    return [
                      '${start + index + 1}',
                      s.studentFullName ?? '',
                      s.mobileNumber ?? '',
                      s.villageName ?? '',
                      '${s.percentage ?? '-'}%',
                    ];
                  }),
                ),
              ),
            ];
          },
        ),
      );
    }

    final pdfBytes = await pdf.save();
    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'Report_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }


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


  static Future<void> generateReportExcel({
    required List<StudentModel> reportList,
    required String std,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    // Set custom column widths
    sheet.setColWidth(0, 8);   // Rank
    sheet.setColWidth(1, 65);  // Name
    sheet.setColWidth(2, 25);  // Mobile
    sheet.setColWidth(3, 17);  // Village
    sheet.setColWidth(4, 15);  // Percentage

    // Spacer rows
    sheet.appendRow(['']);
    sheet.appendRow(['']);

    // App title row
    sheet.appendRow([
      '------------------------------------------------------------------------------ Snehmilan list ------------------------------------------------------------------------------'
    ]);

    // Spacer rows
    sheet.appendRow(['']);
    sheet.appendRow(['']);

    // Section title
    sheet.appendRow([
      '================================================== $std ==================================================='
    ]);

    // Spacer rows
    sheet.appendRow(['']);
    sheet.appendRow(['']);

    // Header row
    sheet.appendRow(['Rank', 'Student Name', 'Mobile Number', 'Village Name', 'Percentage']);

    // Filter reportList by current year
    final currentYear = DateTime.now().year;
    final List<StudentModel> currentYearData = reportList.where((element) {
      final dateStr = element.createdDate;
      if (dateStr == null || dateStr.isEmpty) return false;
      try {
        final date = DateTime.parse(dateStr);
        return date.year == currentYear;
      } catch (_) {
        return false;
      }
    }).toList();

    // Sort by percentage (high to low)
    currentYearData.sort((a, b) => (b.percentage ?? 0).compareTo(a.percentage ?? 0));

    // Add student rows
    for (int i = 0; i < currentYearData.length; i++) {
      final student = currentYearData[i];
      sheet.appendRow([
        '${i + 1}',
        student.studentFullName ?? '',
        student.mobileNumber ?? '',
        student.villageName ?? '',
        '${student.percentage ?? '-'}%',
      ]);
    }

    // Encode and download
    final excelBytes = excel.encode();
    if (excelBytes == null) return;

    final content = base64Encode(excelBytes);
    final anchor = html.AnchorElement(
      href: 'data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=utf-16le;base64,$content',
    )
      ..setAttribute('download', 'Report_${std}_${DateTime.now().millisecondsSinceEpoch}.xlsx')
      ..click();
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

  static Future<void> generateAllReportPdf({
    required List<List<StudentModel>> reportList,
    String? std,
  }) async {
    rank = 1;
    if (reportList.isEmpty) {
      // showToast(title: VariablesUtils.noDataFound);
      return;
    }
    final logoImg =
        (await rootBundle.load('assets/images/logo.jpg')).buffer.asUint8List();

    try {
      final pdf = pw.Document();
      List.generate(
          reportList.length,
          (superIndex) => pdf.addPage(pw.Page(
              pageFormat: PdfPageFormat.a4,
              build: (pw.Context context) {
                return pw.Container(
                  width: double.infinity,
                  decoration: pw.BoxDecoration(
                      border:
                          pw.Border.all(color: PdfColor.fromHex('#41a7f5'))),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        decoration: pw.BoxDecoration(
                            color: PdfColor.fromHex('#133178')),
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
                          pw.Text("Borda Parivar",
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
                          pw.Text("STD : ${superIndex + 1}",
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
                                final result = reportList[superIndex][index];
                                return transactionRow(
                                    result, index, reportList[superIndex]);
                              },
                            ),
                          ])),
                    ],
                  ),
                ); // Center
              })));
      // pdf.addPage(
      //   pw.Page(
      //       pageFormat: PdfPageFormat.a4,
      //       build: (pw.Context context) {
      //         return pw.Container(
      //           width: double.infinity,
      //           decoration:
      //               pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromHex('#41a7f5'))),
      //           child: pw.Column(
      //             crossAxisAlignment: pw.CrossAxisAlignment.start,
      //             children: [
      //               pw.Container(
      //                 decoration: pw.BoxDecoration(color: PdfColor.fromHex('#133178')),
      //                 padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      //                 child: pw.Row(children: [
      //                   pw.ClipRRect(
      //                     verticalRadius: 10.sp,
      //                     horizontalRadius: 10.sp,
      //                     child: pw.Image(pw.MemoryImage(logoImg), width: 60, height: 60),
      //                   ),
      //                   // pw.Image(pw.MemoryImage(logoImg),
      //                   //     width: 60, height: 60),
      //                   pw.SizedBox(width: 20),
      //                   pw.Text("Edupulse",
      //                       style: pw.TextStyle(
      //                         fontSize: 30.sp,
      //                         color: PdfColor.fromHex('#FFFFFF'),
      //                       )),
      //                 ]),
      //               ),
      //               pw.SizedBox(height: 5.sp),
      //               pw.Padding(
      //                 padding: const pw.EdgeInsets.symmetric(horizontal: 5),
      //                 child: pw.Row(children: [
      //                   pw.Text("STD : 1", style: pw.TextStyle(fontSize: 13.sp)),
      //                   pw.Spacer(),
      //                   pw.Text(DateFormat('dd MMM yyyy').format(DateTime.now()),
      //                       style: pw.TextStyle(fontSize: 13.sp)),
      //                 ]),
      //               ),
      //               pw.SizedBox(
      //                 height: 30,
      //               ),
      //               pw.Container(
      //                   decoration: pw.BoxDecoration(
      //                       border: pw.Border.all(color: PdfColor.fromHex('#133178'))),
      //                   margin: const pw.EdgeInsets.symmetric(horizontal: 5),
      //                   child: pw.Column(children: [
      //                     transactionHeader(),
      //                     pw.ListView.builder(
      //                       itemCount: reportList.length > finalPageIndex
      //                           ? finalPageIndex
      //                           : reportList.length,
      //                       padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      //                       itemBuilder: (context, index) {
      //                         final result = reportList[index];
      //                         return transactionRow(result, index, reportList);
      //                       },
      //                     ),
      //                   ])),
      //             ],
      //           ),
      //         ); // Center
      //       }),
      // );
      //
      // int pageCount = ((reportList.length - finalPageIndex) / maxPageCount).ceil();
      //
      // print('pageCount:=>$pageCount reportList:=>${reportList.length}');
      //
      // for (int pageIndex = 0; pageIndex < pageCount; pageIndex++) {
      //   int rowIndex = finalPageIndex + (pageIndex * maxPageCount);
      //   int maxLength = maxPageCount;
      //   if ((rowIndex + maxPageCount) > reportList.length) {
      //     maxLength = reportList.length - rowIndex;
      //   }
      //
      //   pdf.addPage(
      //       getPage(
      //           maxLength: maxLength,
      //           startIndex: rowIndex,
      //           reportList: reportList,
      //           isLast: pageIndex == pageCount - 1),
      //       index: pageIndex + 1);
      // }
      // final output = await getTemporaryDirectory();
      // final file = File('${output.path}/${DateTime.now().millisecondsSinceEpoch}.pdf');
      // await file.writeAsBytes(await pdf.save());
      // Get.to(PDFView(filePath: file.path,));
      final pdfBytes = await pdf.save();
      final base64Data = base64Encode(pdfBytes);
      html.AnchorElement(
        href: 'data:application/pdf;base64,$base64Data',
      )
        ..setAttribute('download', 'Report_${DateTime.now().millisecondsSinceEpoch}.pdf')
        ..click();
    } on Exception catch (e) {
      print('GENERATE PDF ERROR => $e');
      return;
    }
  }
}
