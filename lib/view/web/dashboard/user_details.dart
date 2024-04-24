import 'package:flutter/material.dart';
import 'package:responsivedashboard/common_widget/custom_assets.dart';
import 'package:responsivedashboard/model/user_model.dart';
import 'package:responsivedashboard/utils/image_utils.dart';

class AllUserDataTableSource extends DataTableSource {
  final BuildContext context;
  final List<UserResModel> yourDataList;
  final Function(String userId, bool isApprove) commonDeleteUserDialogCallback;
  final Function(String? phoneNo, String? password)
      commonDialogUserEditCallback;

  AllUserDataTableSource(
    this.yourDataList,
    this.commonDeleteUserDialogCallback,
    this.commonDialogUserEditCallback,
    this.context,
  );

  @override
  DataRow? getRow(int index) {
    if (index >= yourDataList.length) {
      return null;
    }

    final rowData = yourDataList[index];

    // final dynamic rawDate = rowData.createdDate;
    // final DateTime dateTime =
    //     rawDate is DateTime ? rawDate : DateTime.parse(rawDate.toString());
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
        // DataCell(Text(rowData.studentFullName.toString())),

        DataCell(
          Text(rowData.phoneNo.toString()),
        ), // Placeholder for result cell

        DataCell(Text(rowData.pin.toString())),

        DataCell(InkWell(
          onTap: () {
            commonDeleteUserDialogCallback(rowData.phoneNo.toString(), false);
          },
          child: LocalAssets(
            imagePath: AssetsUtils.delete,
          ),
        )),

        DataCell(InkWell(
          onTap: () {
            commonDialogUserEditCallback(rowData.phoneNo, rowData.pin);
          },
          child: LocalAssets(
            imagePath: AssetsUtils.edit,
          ),
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => yourDataList.length;

  @override
  int get selectedRowCount => 0;

  // Future<void> _showImageDialog(BuildContext context, String imageUrl) async {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         child: PhotoViewGallery(
  //           pageController: PageController(),
  //           backgroundDecoration: const BoxDecoration(
  //             color: Colors.black,
  //           ),
  //           onPageChanged: (index) {},
  //           pageOptions: [
  //             PhotoViewGalleryPageOptions(
  //               imageProvider: NetworkImage(imageUrl),
  //               minScale: PhotoViewComputedScale.contained,
  //               maxScale: PhotoViewComputedScale.covered * 2,
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
