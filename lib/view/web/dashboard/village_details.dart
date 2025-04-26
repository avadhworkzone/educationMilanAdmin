import 'package:flutter/material.dart';
import 'package:responsivedashboard/common_widget/custom_assets.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/utils/image_utils.dart';
import 'package:responsivedashboard/view/screens/add_village.dart';

class VillageDataTableSource extends DataTableSource {
  final BuildContext context;
  final List<StudentModel> yourVillageList;

  VillageDataTableSource(this.yourVillageList, this.context);

  @override
  DataRow? getRow(int index) {
    if (index >= yourVillageList.length) return null;

    final student = yourVillageList[index];
    return DataRow(
        cells: [
          DataCell(Text('${index + 1}')),
          DataCell(Text(student.villageName ?? "")),
          DataCell(
            InkWell(
              onTap: () {
                editVillageDialog(context,index,student.villageName ?? "");
                },
              child: LocalAssets(
                imagePath: AssetsUtils.edit,
              ),
            ),
          ),
          DataCell(
            InkWell(
              onTap: () {
                deleteStandardDialog(context,index);
                },
              child: LocalAssets(
                imagePath: AssetsUtils.delete,
              ),
            ),),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => yourVillageList.length;

  @override
  int get selectedRowCount => 0;
}
