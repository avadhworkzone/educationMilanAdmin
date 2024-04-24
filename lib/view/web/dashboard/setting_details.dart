import 'package:flutter/material.dart';
import 'package:responsivedashboard/common_widget/custom_assets.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/utils/image_utils.dart';
import 'package:responsivedashboard/view/web/dashboard/drawer_screen/add_standard.dart';

class SettingDataTableSource extends DataTableSource {
  final BuildContext context;
  final List<StudentModel> yourStandardList;
  SettingDataTableSource(
    this.yourStandardList,
    this.context,
  );

  @override
  DataRow? getRow(int index) {
    if (index >= yourStandardList.length) return null;
    final student = yourStandardList[index];
    return DataRow(cells: [
      DataCell(
        Text('${index + 1}'),
      ),
      DataCell(
        Text(student.standard ?? ""),
      ),
      DataCell(
        InkWell(
          onTap: () {
            editStandardDialog(context, index, student.standard ?? "");
          },
          child: LocalAssets(
            imagePath: AssetsUtils.edit,
          ),
        ),
      ),
      DataCell(
        InkWell(
          onTap: () {
            deleteStandardDialog(context, index);
          },
          child: LocalAssets(
            imagePath: AssetsUtils.delete,
          ),
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => yourStandardList.length;

  @override
  int get selectedRowCount => 0;
}
