import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:responsivedashboard/common_widget/octa_image.dart';
import 'package:responsivedashboard/common_widget/custom_assets.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/utils/image_utils.dart';

const int columnCount = 10;

class YourDataTableSource extends DataTableSource {
  final BuildContext context;
  final bool isApprove;
  final List<StudentModel> yourDataList;
  final Function(String studentId, bool isApprove, String fcmToken, VoidCallback onSuccess) commonDialogCallback;
  final Function(
      String? image,
      num? personTage,
      String? standard,
      String? fullName,
      String studentId,
      String userId,
      String villageName,
      String? createdDate, {
      required String? mobileNumber,
      required bool? isApproved,
      String? result,
      required String fcmToken,
      String? checkUncheck,
      required String? imageId,
      String? reason,
      String? status,
      required VoidCallback onSuccess,
      }) commonDialogEditCallback;
  final Function(String studentId, String fcmToken,  VoidCallback onSuccess,) commonCheckUncheckCallBack;

  YourDataTableSource(
      this.yourDataList,
      this.commonDialogCallback,
      this.commonDialogEditCallback,
      this.commonCheckUncheckCallBack,
      this.context, {
        this.isApprove = false,
      });

  @override
  DataRow? getRow(int index) {
    if (index >= yourDataList.length) return null;

    final rowData = yourDataList[index];

    if (rowData.isApproved == false) {
      final dynamic rawDate = rowData.createdDate;
      final DateTime dateTime = rawDate is DateTime ? rawDate : DateTime.parse(rawDate.toString());
      final formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

      return DataRow(
        color: MaterialStateColor.resolveWith((states) => states.contains(MaterialState.selected) ? Colors.blue : Colors.white),
        cells: [
          DataCell(Text('${index + 1}')),
          DataCell(Text(rowData.mobileNumber ?? '')),
          DataCell(Text(formattedDate)),
          DataCell(Text(rowData.studentFullName ?? '')),
          DataCell(Text(rowData.villageName ?? '')),
          DataCell(Text(rowData.percentage?.toString() ?? '')),
          DataCell(
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                width: 60.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: GestureDetector(
                    onTap: () => _showImageDialog(context, rowData.result ?? ''),
                    child: NetWorkOcToAssets(imgUrl: rowData.result ?? ''),
                  ),
                ),
              ),
            ),
          ),
          DataCell(
            InkWell(
              onTap: () {
                commonDialogCallback(
                  rowData.studentId!,
                  isApprove,
                  rowData.fcmToken!,
                      () {
                    Get.back(); // Close Delete Dialog
                    if (context.mounted) {
                      (context as Element).markNeedsBuild(); // Refresh after delete ✅
                    }
                  },
                );
              },
              child: LocalAssets(imagePath: AssetsUtils.delete),
            ),
          ),
          DataCell(
            InkWell(
              onTap: () {
                commonDialogEditCallback(
                  rowData.result,
                  rowData.percentage,
                  rowData.standard,
                  rowData.studentFullName,
                  rowData.studentId!,
                  rowData.userId!,
                  rowData.villageName!,
                  rowData.createdDate,
                  mobileNumber: rowData.mobileNumber,
                  result: rowData.result,
                  fcmToken: rowData.fcmToken!,
                  isApproved: rowData.isApproved,
                  imageId: rowData.imageId,
                  reason: rowData.reason,
                  status: rowData.status,
                  onSuccess: () {
                    Get.back(); // Close Edit Dialog
                    if (context.mounted) {
                      (context as Element).markNeedsBuild(); // Refresh after edit ✅
                    }
                  },
                );
              },
              child: LocalAssets(imagePath: AssetsUtils.edit),
            ),
          ),
          DataCell(
            InkWell(
              onTap: () {
                commonCheckUncheckCallBack(
                  rowData.studentId!,
                  rowData.fcmToken!,() {
                  if (context.mounted) {
                    (context as Element).markNeedsBuild(); // Refresh after delete ✅
                  }
                  },
                );
              },
              child: const Icon(Icons.check),
            ),
          ),
        ],
      );
    } else {
      return DataRow.byIndex(
        index: index,
        cells: List.generate(
          columnCount,
              (index) => DataCell(Container()),
        ),
      );
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => yourDataList.length;

  @override
  int get selectedRowCount => 0;

  Future<void> _showImageDialog(BuildContext context, String imageUrl) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: PhotoViewGallery(
            pageController: PageController(),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            pageOptions: [
              PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(imageUrl),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              ),
            ],
          ),
        );
      },
    );
  }
}
