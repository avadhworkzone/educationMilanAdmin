import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:responsivedashboard/common_widget/custom_assets.dart';
import 'package:responsivedashboard/common_widget/octa_image.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/utils/image_utils.dart';

const int columnCount = 10;

class FinalDataTableSource extends DataTableSource {
  final BuildContext context;
  final List<StudentModel> yourDataList;
  final Function(String studentId, bool isApprove, String fcmToken) commonDialogCallback;
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
    String? imageId,
    String? reason,
    String? status,
  }) commonDialogEditCallback;

  FinalDataTableSource(
    this.yourDataList,
    this.commonDialogCallback,
    this.commonDialogEditCallback,
    this.context,
  );

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
    // var filteredData = yourDataList
    //     .where((element) =>
    //         element.standard == element.studentId && element.isApproved == true)
    //     .toList();
    final dataApprove = yourDataList[index];
    // final rowData = yourDataList[index];
    // if (dataApprove.isApproved == true) {
    // final dynamic rawDate = dataApprove.createdDate;
    // final DateTime dateTime =
    //     rawDate is DateTime ? rawDate : DateTime.parse(dataApprove.toString());
    // final formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

    return DataRow(
      color: MaterialStateColor.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.blue;
        }
        return Colors.white;
      }),
      cells: [
        DataCell(Text('${index + 1}')),
        DataCell(Text(dataApprove.mobileNumber ?? '')),
        DataCell(Text(DateFormat("dd MMM yyyy")
            .format(DateTime.parse(dataApprove.createdDate ?? DateTime.now().toString())))),

        DataCell(
          Text(dataApprove.studentFullName ?? ''),
        ), // Placeholder for result cell

        DataCell(Text(dataApprove.villageName ?? '')),
        DataCell(Text(dataApprove.percentage?.toString() ?? '')),

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
                    _showImageDialog(context, dataApprove.result.toString());
                  },
                  child: NetWorkOcToAssets(
                    imgUrl: dataApprove.result.toString(),
                  ),
                ),
              ),
            ),
          ),
        ),

        DataCell(InkWell(
          onTap: () {
            commonDialogCallback(
              dataApprove.studentId.toString(),
              true,
              dataApprove.fcmToken.toString(),
            );
          },
          child: LocalAssets(
            imagePath: AssetsUtils.delete,
          ),
        )),

        DataCell(InkWell(
          onTap: () {
            commonDialogEditCallback(
              dataApprove.result.toString(),
              dataApprove.percentage,
              dataApprove.standard,
              dataApprove.studentFullName,
              dataApprove.studentId.toString(),
              dataApprove.userId.toString(),
              dataApprove.villageName.toString(),
              dataApprove.createdDate,
              mobileNumber: dataApprove.mobileNumber,
              checkUncheck: dataApprove.checkUncheck,
              fcmToken: dataApprove.fcmToken!,
              result: dataApprove.result,
              isApproved: dataApprove.isApproved,
              imageId: dataApprove.imageId,
              reason: dataApprove.reason,
              status: dataApprove.status,
            );
          },
          child: LocalAssets(
            imagePath: AssetsUtils.edit,
          ),
        )),
      ],
    );
    // } else {
    //   return DataRow.byIndex(
    //     index: index,
    //     // Empty DataCells for non-approved rows
    //     cells: List.generate(
    //       columnCount,
    //       (index) => DataCell(Container()), // You can customize the empty cell
    //     ),
    //   );
    // }
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
