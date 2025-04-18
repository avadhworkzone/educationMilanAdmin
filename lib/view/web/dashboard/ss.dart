import 'dart:convert';
import 'dart:io';
import 'package:excel/excel.dart';
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

class PdfServicsse {
  static int finalPageIndex = 22;
  static int maxPageCount = 30;
  static int rank = 1;
  static late Font gujaratiFont;

  static getGujaratiFont() async {
    final font = await rootBundle.load("fonts/NotoSansGujarati.ttf");
    gujaratiFont = pw.Font.ttf(font);
  }
  static Future<void> generateYearWiseReportPdf({
    required int year,
    required List<StudentModel> allStudents,
  }) async {
    await getGujaratiFont(); // Load custom Gujarati font
    final pdf = pw.Document();
    final pdfBytesList = <int>[]; // To build final output
    bool isFirstPage = true;

    const List<String> standardOrder = [
      'STD Junior KG (Eng)', 'STD Junior KG (Guj)',
      'STD Senior KG (Eng)', 'STD Senior KG (Guj)',
      'STD 1 (Eng)', 'STD 1 (Guj)', 'STD 2 (Eng)', 'STD 2 (Guj)',
      'STD 3 (Eng)', 'STD 3 (Guj)', 'STD 4 (Eng)', 'STD 4 (Guj)',
      'STD 5 (Eng)', 'STD 5 (Guj)', 'STD 6 (Eng)', 'STD 6 (Guj)',
      'STD 7 (Eng)', 'STD 7 (Guj)', 'STD 8 (Eng)', 'STD 8 (Guj)',
      'STD 9 (Eng)', 'STD 9 (Guj)', 'STD 10 (Eng)', 'STD 10 (Guj)',
      'STD 11 Com. (Eng)', 'STD 11 Com. (Guj)',
      'STD 11 Sci. (Eng)', 'STD 11 Sci. (Guj)',
      'STD 11 Art (Eng)', 'STD 11 Art (Guj)',
      'STD 12 Com. (Eng)', 'STD 12 Com. (Guj)',
      'STD 12 Sci. (Eng)', 'STD 12 Sci. (Guj)',
      'STD 12 Art (Eng)', 'STD 12 Art (Guj)'
    ];

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

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4.landscape,
          build: (context) {
            final List<pw.Widget> content = [];

            // Add logo + title only on first page
            if (isFirstPage) {
              content.add(
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text(
                        'Borda Parivar',
                        style: pw.TextStyle(
                          font: gujaratiFont,
                          fontSize: 28,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'Annual Student Report - $year',
                        style: pw.TextStyle(font: gujaratiFont, fontSize: 18),
                      ),
                      pw.SizedBox(height: 20),
                    ],
                  ),
                ),
              );
              isFirstPage = false;
            }

            content.add(pw.Text(
              std,
              style: pw.TextStyle(
                font: gujaratiFont,
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ));
            content.add(pw.SizedBox(height: 10));

            content.add(
              pw.Table(
                border: pw.TableBorder.all(width: 0.5),
                columnWidths: {
                  0: const pw.FixedColumnWidth(40),
                  1: const pw.FlexColumnWidth(3),
                  2: const pw.FlexColumnWidth(2.5),
                  3: const pw.FlexColumnWidth(2),
                  4: const pw.FixedColumnWidth(80),
                },
                children: [
                  pw.TableRow(
                    decoration:
                    const pw.BoxDecoration(color: PdfColors.blueGrey300),
                    children: [
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('Rank',
                              style: pw.TextStyle(
                                  font: gujaratiFont,
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('Name',
                              style: pw.TextStyle(
                                  font: gujaratiFont,
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('Mobile',
                              style: pw.TextStyle(
                                  font: gujaratiFont,
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('Village',
                              style: pw.TextStyle(
                                  font: gujaratiFont,
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('Percentage',
                              style: pw.TextStyle(
                                  font: gujaratiFont,
                                  fontWeight: pw.FontWeight.bold))),
                    ],
                  ),
                  ...List.generate(students.length, (index) {
                    final s = students[index];
                    return pw.TableRow(
                      children: [
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text('${index + 1}',
                                style: pw.TextStyle(font: gujaratiFont))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text('${s.studentFullName ?? ''}',
                                style: pw.TextStyle(font: gujaratiFont))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text('${s.mobileNumber ?? ''}',
                                style: pw.TextStyle(font: gujaratiFont))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text('${s.villageName ?? ''}',
                                style: pw.TextStyle(font: gujaratiFont))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text('${s.percentage ?? '-'}%',
                                style: pw.TextStyle(font: gujaratiFont))),
                      ],
                    );
                  }),
                ],
              ),
            );

            return content;
          },
        ),
      );
    }

    final bytes = await pdf.save();

    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'Student_Report_$year.pdf')
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  // static Future<void> generateYearWiseReportPdf({
  //   required int year,
  //   required List<StudentModel> allStudents,
  // }) async {
  //   await getGujaratiFont();
  //   final pdf = pw.Document();
  //   // final logoImg = (await rootBundle.load('assets/images/logo.jpg')).buffer.asUint8List();
  //   bool isFirstPage = true;
  //
  //   const List<String> standardOrder = [
  //     'STD Junior KG (Eng)', 'STD Junior KG (Guj)',
  //     'STD Senior KG (Eng)', 'STD Senior KG (Guj)',
  //     'STD 1 (Eng)', 'STD 1 (Guj)', 'STD 2 (Eng)', 'STD 2 (Guj)',
  //     'STD 3 (Eng)', 'STD 3 (Guj)', 'STD 4 (Eng)', 'STD 4 (Guj)',
  //     'STD 5 (Eng)', 'STD 5 (Guj)', 'STD 6 (Eng)', 'STD 6 (Guj)',
  //     'STD 7 (Eng)', 'STD 7 (Guj)', 'STD 8 (Eng)', 'STD 8 (Guj)',
  //     'STD 9 (Eng)', 'STD 9 (Guj)', 'STD 10 (Eng)', 'STD 10 (Guj)',
  //     'STD 11 Com. (Eng)', 'STD 11 Com. (Guj)', 'STD 11 Sci. (Eng)', 'STD 11 Sci. (Guj)', 'STD 11 Art (Eng)', 'STD 11 Art (Guj)',
  //     'STD 12 Com. (Eng)', 'STD 12 Com. (Guj)', 'STD 12 Sci. (Eng)', 'STD 12 Sci. (Guj)', 'STD 12 Art (Eng)', 'STD 12 Art (Guj)'
  //   ];
  //
  //   for (final std in standardOrder) {
  //     final students = allStudents.where((s) {
  //       final matchStd = s.standard?.trim() == std.trim();
  //       if (!matchStd) return false;
  //       try {
  //         final created = DateTime.parse(s.createdDate ?? '');
  //         return created.year == year;
  //       } catch (_) {
  //         return false;
  //       }
  //     }).toList();
  //
  //     if (students.isEmpty) continue;
  //
  //     pdf.addPage(
  //       pw.MultiPage(
  //         pageFormat: PdfPageFormat.a4.landscape,
  //         build: (context) {
  //           final List<pw.Widget> content = [];
  //
  //           if (isFirstPage) {
  //             content.add(
  //               pw.Row(
  //                 mainAxisAlignment: pw.MainAxisAlignment.center,
  //                 children: [
  //                   // pw.Image(pw.MemoryImage(logoImg), width: 80, height: 80),
  //                   pw.SizedBox(width: 20),
  //                   pw.Column(
  //                     crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                     children: [
  //                       pw.Text(
  //                         'Borda Parivar',
  //                         style: pw.TextStyle(
  //                           font: gujaratiFont,
  //                           fontSize: 24,
  //                           fontWeight: pw.FontWeight.bold,
  //                         ),
  //                       ),
  //                       pw.Text(
  //                         'Annual Student Report - $year',
  //                         style: pw.TextStyle(
  //                           font: gujaratiFont,
  //                           fontSize: 16,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             );
  //             content.add(pw.SizedBox(height: 20));
  //             isFirstPage = false;
  //           }
  //
  //           content.add(
  //             pw.Text(
  //               std,
  //               style: pw.TextStyle(
  //                 font: gujaratiFont,
  //                 fontSize: 18,
  //                 fontWeight: pw.FontWeight.bold,
  //               ),
  //             ),
  //           );
  //           content.add(pw.SizedBox(height: 10));
  //
  //           content.add(
  //             pw.Table(
  //               border: pw.TableBorder.all(width: 0.5),
  //               columnWidths: {
  //                 0: const pw.FixedColumnWidth(40),
  //                 1: const pw.FlexColumnWidth(3),
  //                 2: const pw.FlexColumnWidth(2.5),
  //                 3: const pw.FlexColumnWidth(2),
  //                 4: const pw.FixedColumnWidth(80),
  //               },
  //               children: [
  //                 pw.TableRow(
  //                   decoration: const pw.BoxDecoration(color: PdfColors.blueGrey300),
  //                   children: [
  //                     pw.Padding(
  //                       padding: const pw.EdgeInsets.all(5),
  //                       child: pw.Text('Rank', style: pw.TextStyle(font: gujaratiFont, fontWeight: pw.FontWeight.bold)),
  //                     ),
  //                     pw.Padding(
  //                       padding: const pw.EdgeInsets.all(5),
  //                       child: pw.Text('Name', style: pw.TextStyle(font: gujaratiFont, fontWeight: pw.FontWeight.bold)),
  //                     ),
  //                     pw.Padding(
  //                       padding: const pw.EdgeInsets.all(5),
  //                       child: pw.Text('Mobile', style: pw.TextStyle(font: gujaratiFont, fontWeight: pw.FontWeight.bold)),
  //                     ),
  //                     pw.Padding(
  //                       padding: const pw.EdgeInsets.all(5),
  //                       child: pw.Text('Village', style: pw.TextStyle(font: gujaratiFont, fontWeight: pw.FontWeight.bold)),
  //                     ),
  //                     pw.Padding(
  //                       padding: const pw.EdgeInsets.all(5),
  //                       child: pw.Text('Percentage', style: pw.TextStyle(font: gujaratiFont, fontWeight: pw.FontWeight.bold)),
  //                     ),
  //                   ],
  //                 ),
  //                 ...List.generate(students.length, (index) {
  //                   final s = students[index];
  //                   return pw.TableRow(
  //                     children: [
  //                       pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('${index + 1}', style: pw.TextStyle(font: gujaratiFont))),
  //                       pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('${s.studentFullName ?? ''}', style: pw.TextStyle(font: gujaratiFont))),
  //                       pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('${s.mobileNumber ?? ''}', style: pw.TextStyle(font: gujaratiFont))),
  //                       pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('${s.villageName ?? ''}', style: pw.TextStyle(font: gujaratiFont))),
  //                       pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('${s.percentage ?? '-'}%', style: pw.TextStyle(font: gujaratiFont))),
  //                     ],
  //                   );
  //                 }),
  //               ],
  //             ),
  //           );
  //
  //           return content;
  //         },
  //       ),
  //     );
  //   }
  //
  //   final pdfBytes = await pdf.save();  // This is binary data (Uint8List)
  //   final blob = html.Blob([Uint8List.fromList(pdfBytes)], 'application/pdf');
  //   final url = html.Url.createObjectUrlFromBlob(blob);
  //   html.AnchorElement(href: url)
  //     ..setAttribute('download', 'Student_Report_$year.pdf')
  //     ..click();
  //   // html.document.body!.append(AnchorElement);
  //
  //   html.Url.revokeObjectUrl(url);
  // }





  static Future<void> generateReportPdf({
    required List<StudentModel> reportList,
    required String std,
  }) async {
    if (reportList.isEmpty) return;

    await getGujaratiFont();

    // final logoImg = (await rootBundle.load('assets/images/logo.jpg')).buffer.asUint8List();
    final currentYear = DateTime.now().year;

    final filteredList = reportList.where((s) {
      try {
        final date = DateTime.parse(s.createdDate ?? '');
        return date.year == currentYear;
      } catch (_) {
        return false;
      }
    }).toList();

    if (filteredList.isEmpty) return;

    final pdf = pw.Document();
    const int rowsPerPage = 25;
    final totalPages = (filteredList.length / rowsPerPage).ceil();

    for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
      final start = pageIndex * rowsPerPage;
      final end = (start + rowsPerPage > filteredList.length)
          ? filteredList.length
          : start + rowsPerPage;
      final currentPageItems = filteredList.sublist(start, end);

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (_) {
            final content = <pw.Widget>[];

            /// Header only on the first page
            if (pageIndex == 0) {
              content.add(
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    // pw.Image(pw.MemoryImage(logoImg), width: 60, height: 60),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(
                          'Borda Parivar',
                          style: pw.TextStyle(
                            font: gujaratiFont,
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          'STD: $std - Year: $currentYear',
                          style: pw.TextStyle(font: gujaratiFont, fontSize: 14),
                        ),
                      ],
                    ),
                    pw.Text(
                      DateFormat('dd MMM yyyy').format(DateTime.now()),
                      style: pw.TextStyle(font: gujaratiFont, fontSize: 12),
                    ),
                  ],
                ),
              );
              content.add(pw.SizedBox(height: 20));
            } else {
              content.add(pw.Text('STD: $std', style: pw.TextStyle(font: gujaratiFont, fontSize: 16, fontWeight: pw.FontWeight.bold)));
              content.add(pw.SizedBox(height: 10));
            }

            /// Table
            content.add(
              pw.Table(
                border: pw.TableBorder.all(width: 0.5),
                columnWidths: {
                  0: const pw.FixedColumnWidth(40),
                  1: const pw.FlexColumnWidth(3),
                  2: const pw.FlexColumnWidth(2.5),
                  3: const pw.FlexColumnWidth(2),
                  4: const pw.FixedColumnWidth(80),
                },
                children: [
                  /// Header Row
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.blueGrey300),
                    children: [
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('Rank', style: pw.TextStyle(font: gujaratiFont, fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('Name', style: pw.TextStyle(font: gujaratiFont, fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('Mobile', style: pw.TextStyle(font: gujaratiFont, fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('Village', style: pw.TextStyle(font: gujaratiFont, fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('Percentage', style: pw.TextStyle(font: gujaratiFont, fontWeight: pw.FontWeight.bold))),
                    ],
                  ),

                  /// Data Rows
                  ...List.generate(currentPageItems.length, (index) {
                    final s = currentPageItems[index];
                    return pw.TableRow(
                      children: [
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text('${start + index + 1}', style: pw.TextStyle(font: gujaratiFont))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text('${s.studentFullName ?? ''}', style: pw.TextStyle(font: gujaratiFont))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text('${s.mobileNumber ?? ''}', style: pw.TextStyle(font: gujaratiFont))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text('${s.villageName ?? ''}', style: pw.TextStyle(font: gujaratiFont))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text('${s.percentage ?? '-'}%', style: pw.TextStyle(font: gujaratiFont))),
                      ],
                    );
                  }),
                ],
              ),
            );

            return content;
          },
        ),
      );
    }


    var savedFile = await pdf.save();
    List<int> fileInts = List.from(savedFile);
    html.AnchorElement(
        href:
        "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}")
      ..setAttribute(
          "download", "${DateTime.now().millisecondsSinceEpoch}.pdf")
      ..click();
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
    // TODO: Implement your Excel generation logic using the `excel` package.
    // Here's a sample structure to start with:
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    // Add headers
    sheet.appendRow([
      'Rank',
      'Student Name',
      'Mobile Number',
      'Village Name',
      'Percentage',
    ]);

    // int rank = 1;

    reportList=reportList.where((element){
    final dateStr = element.createdDate;
    if (dateStr
    == null || dateStr.isEmpty) return false;
    try {
    final date = DateTime.parse(dateStr);
    return date.year == DateTime.now().year;
    } catch (e) {
    return false;
    }                            },).toList();
    for (int i = 0; i < reportList.length; i++) {
      final s = reportList[i];
      sheet.appendRow([
        rank++,
        s.studentFullName ?? '',
        s.mobileNumber ?? '',
        s.villageName ?? '',
        '${s.percentage}%',
      ]);
    }

    final fileBytes = excel.encode();
    final content = base64Encode(fileBytes!);
    final anchor = html.AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64,$content')
      ..setAttribute("download", "${DateTime.now().millisecondsSinceEpoch}.xlsx")
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
        (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List();

    try {
      final pdf = pw.Document();
      for (var reportList in reportList) {}
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
      final bytes = await pdf.save();

      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);

      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'Student_Report.pdf')
        ..click();

      html.Url.revokeObjectUrl(url);
    } on Exception catch (e) {
      print('GENERATE PDF ERROR => $e');
      return;
    }
  }
}