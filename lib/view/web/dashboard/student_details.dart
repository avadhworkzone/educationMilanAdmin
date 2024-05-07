import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:responsivedashboard/common_widget/custom_assets.dart';
import 'package:responsivedashboard/common_widget/octa_image.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/utils/image_utils.dart';
import 'package:responsivedashboard/view/web/dashboard/common_method.dart';

const int columnCount = 10;
// final StudentDetailsController controller = StudentDetailsController();

class YourDataTableSource extends DataTableSource {
  final BuildContext context;
  final bool isApprove;
  final List<StudentModel> yourDataList;
  final Function(
    String studentId,
    bool isApprove,
    String fcmToken,
  ) commonDialogCallback;
  final Function(
    String? image,
    num? personTage,
    String? standard,
    String? fullName,
    String studentId,
    String userId,
    String villageName,
    String? createdDate,
  {
  required  String? mobileNumber,
  required  bool? isApproved,
   String? result,
   required String fcmToken,
   String? checkUncheck,
  required String? imageId,
  String? reason,
  String? status,
  }
  ) commonDialogEditCallback;

  final Function(String studentId, String fcmToken) commonCheckUncheckCallBack;

  YourDataTableSource(
    this.yourDataList,
    this.commonDialogCallback,
    this.commonDialogEditCallback,
    this.commonCheckUncheckCallBack,
    this.context, {
    this.isApprove = false,
  });

  double _scale = 1.0;
  static const double _minScale = 0.5;
  static const double _maxScale = 4.0;

  void _updateScale(double delta) {
    _scale = (_scale - delta).clamp(_minScale, _maxScale);
  }

  @override
  DataRow? getRow(int index) {
    if (index >= yourDataList.length) {
      return null;
    }

    final rowData = yourDataList[index];
    //print("rowData.result.toString() ${rowData.result.toString()}");
    if (rowData.isApproved == false) {
      final dynamic rawDate = rowData.createdDate;
      final DateTime dateTime =
          rawDate is DateTime ? rawDate : DateTime.parse(rawDate.toString());
      final formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

      return DataRow(
        color: MaterialStateColor.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.blue;
          }
          return Colors.white;
        }),
        cells: [
          DataCell(Text('${index + 1}')),
          DataCell(Text(rowData.mobileNumber ?? '')),
          DataCell(Text(formattedDate)),
          DataCell(
            Text(rowData.studentFullName ?? ''),
          ),
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
                    onTap: () {
                      _showImageDialog(context, rowData.result.toString());
                    },
                    child: NetWorkOcToAssets(
                      imgUrl: rowData.result.toString(),
                    ),
                    // child:Image.network(rowData.result.toString()),
                  ),
                ),
              ),
            ),
          ),
          DataCell(InkWell(
            onTap: () {
              commonDialogCallback(
                rowData.studentId.toString(),
                isApprove,
                rowData.fcmToken.toString(),
              );
            },
            child: LocalAssets(
              imagePath: AssetsUtils.delete,
            ),
          )),
          DataCell(InkWell(
            onTap: () {
              commonDialogEditCallback(
                rowData.result.toString(),
                rowData.percentage,
                rowData.standard,
                rowData.studentFullName,
                rowData.studentId.toString(),
                rowData.userId.toString(),
                rowData.villageName.toString(),
                rowData.createdDate,
                mobileNumber: rowData.mobileNumber,
                result: rowData.result,
                fcmToken: rowData.fcmToken!,
                checkUncheck: rowData.checkUncheck,
                isApproved: rowData.isApproved,
                imageId : rowData.imageId,
                reason :rowData.reason,
                status :rowData.status,
              );
            },
            child: LocalAssets(
              imagePath: AssetsUtils.edit,
            ),
          )),
          DataCell(InkWell(
              onTap: () {
                commonCheckUncheckCallBack(
                    rowData.studentId.toString(), rowData.fcmToken.toString());
              },
              child: const Icon(Icons.check))),
          // DataCell(InkWell(
          //     onTap: () {
          //       commonRejectCallBack(rowData.studentId.toString());
          //     },
          //     child: const Icon(Icons.close))),
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
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
            onPageChanged: (index) {},
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
