import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsivedashboard/common_widget/column_text.dart';
import 'package:responsivedashboard/common_widget/common_btn.dart';
import 'package:responsivedashboard/common_widget/custom_text.dart';
import 'package:responsivedashboard/firbaseService/standard_service/standad_services.dart';
import 'package:responsivedashboard/firbaseService/village_service/village_services.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/utils/string_utils.dart';
import 'package:responsivedashboard/view/web/auth/desktop_login_form.dart';
import 'package:responsivedashboard/view/web/dashboard/common_method.dart';
import 'package:responsivedashboard/view/web/dashboard/drawer_screen/add_standard.dart';
import 'package:responsivedashboard/view/web/dashboard/drawer_screen/add_village.dart';
import 'package:responsivedashboard/view/web/dashboard/village_details.dart';

class SettingDataScreen extends StatefulWidget {
  const SettingDataScreen({Key? key}) : super(key: key);

  @override
  State<SettingDataScreen> createState() => _SettingDataScreenState();
}

class _SettingDataScreenState extends State<SettingDataScreen> {
  bool isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: ListView(
        children: [
          SizedBox(
            height: Get.width * 0.01,
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.01,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Setting Data
                      CustomText(
                        StringUtils.settingData,
                        color: ColorUtils.black32,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                      Row(
                        children: [
                          // commonButton(StringUtils.matchOut),
                          SizedBox(
                            width: Get.width * 0.01,
                          ),
                          InkWell(
                            onTap: () async {
                              setState(() {
                                isLoggingOut = true;
                              });
                              await signOut();
                              setState(() {
                                isLoggingOut = false;
                              });
                              Get.offAll(() => const DesktopLoginForm());
                            },
                            child: isLoggingOut
                                ? const CircularProgressIndicator()
                                : commonButton(StringUtils.logOut),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  // ADD STANDARED
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          // FutureBuilder<List<StudentModel>>(
          //   future: StandardService.getStandards(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     } else if (snapshot.hasError) {
          //       return Center(
          //         child: Text('Error: ${snapshot.error}'),
          //       );
          //     } else {
          //       return Container(
          //         padding: const EdgeInsets.all(8.0),
          //         decoration: const BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.all(Radius.circular(10)),
          //         ),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             SizedBox(
          //               width: double.infinity,
          //               child: Theme(
          //                 data: ThemeData.light()
          //                     .copyWith(cardColor: Colors.white),
          //                 child: PaginatedDataTable(
          //                   dataRowMaxHeight: 60.w,
          //                   dataRowMinHeight: 40.w,
          //                   columnSpacing: 8,
          //                   rowsPerPage: 5,
          //                   source: SettingDataTableSource(
          //                     snapshot.data ?? [],
          //                     context,
          //                   ),
          //                   columns: [
          //                     DataColumn(
          //                       label: commonText(
          //                         StringUtils.number,
          //                       ),
          //                     ),
          //                     DataColumn(
          //                       label: commonText(
          //                         StringUtils.standard,
          //                       ),
          //                     ),
          //                     DataColumn(
          //                       label: commonText(
          //                         StringUtils.edit,
          //                       ),
          //                     ),
          //                     DataColumn(
          //                       label: commonText(
          //                         StringUtils.delete,
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       );
          //     }
          //   },
          // ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.01,
            ),
            child: Row(
              children: [
                CustomText(
                  StringUtils.standard,
                  color: ColorUtils.black32,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    addStandardDialog(context);
                  },
                  child: commonButton(StringUtils.addStandard),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.01,
            ),
            child: StreamBuilder<List<Map>>(
              stream: StandardService.getStandardsStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.hasError) {
                  return const Text('Loading...');
                }
                if (snapshot.data == null) {
                  return const SizedBox();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: snapshot.data!
                        .map((e) => Chip(
                              label: Text(e['standard'] ?? ""),
                              onDeleted: () async {
                                final status =
                                    await StandardService.deleteStandard(
                                        e['id']);
                              },
                              deleteIcon: const Icon(
                                Icons.delete_outline,
                                color: ColorUtils.red,
                              ),
                            ))
                        .toList(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.01,
            ),
            child: Row(
              children: [
                CustomText(
                  StringUtils.village,
                  color: ColorUtils.black32,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                const Spacer(),
                InkWell(
                  onTap: () async {
                    addVillageDialog(context);
                  },
                  child: commonButton(StringUtils.addVillage),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<List<StudentModel>>(
            stream: VillageService().getVillagesStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Theme(
                          data: ThemeData.light()
                              .copyWith(cardColor: Colors.white),
                          child: PaginatedDataTable(
                            dataRowMaxHeight: 60.w,
                            dataRowMinHeight: 40.w,
                            columnSpacing: 8,
                            rowsPerPage: 5,
                            source: VillageDataTableSource(
                              snapshot.data ?? [],
                              context,
                            ),
                            columns: [
                              DataColumn(
                                label: commonText(
                                  StringUtils.number,
                                ),
                              ),
                              DataColumn(
                                label: commonText(
                                  StringUtils.village,
                                ),
                              ),
                              DataColumn(
                                label: commonText(
                                  StringUtils.edit,
                                ),
                              ),
                              DataColumn(
                                label: commonText(
                                  StringUtils.delete,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
