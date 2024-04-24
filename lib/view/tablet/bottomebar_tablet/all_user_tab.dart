import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsivedashboard/common_widget/column_text.dart';
import 'package:responsivedashboard/common_widget/common_btn.dart';
import 'package:responsivedashboard/common_widget/custom_text.dart';
import 'package:responsivedashboard/firbaseService/standard_service/standad_services.dart';
import 'package:responsivedashboard/firbaseService/student_service/student_details_services.dart';
import 'package:responsivedashboard/firbaseService/user_service/user_service.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/utils/string_utils.dart';
import 'package:responsivedashboard/view/mobile/auth/login_mobile.dart';
import 'package:responsivedashboard/view/tablet/auth/login_tablet.dart';
import 'package:responsivedashboard/view/web/auth/desktop_login_form.dart';
import 'package:responsivedashboard/responsiveLayout/responsive_layout.dart';
import 'package:responsivedashboard/view/web/dashboard/common_method.dart';
import 'package:responsivedashboard/view/web/dashboard/user_details.dart';
import '../../mobile/bottombar_mobile/student_list_mob.dart';

class AllUserTab extends StatefulWidget {
  // final List<UserResModel> allUserData1;
  // final List<StudentModel> filteredData;

  const AllUserTab({
    Key? key,
  }) : super(key: key);

  @override
  State<AllUserTab> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<AllUserTab> {
  TextEditingController searchController = TextEditingController();
  int _rowsPerPage = 10;
  bool isLoggingOut = false;
  List<StudentModel> allUserData = [];
  List<StudentModel> filteredStandardData = [];
  final StandardService firestoreService = StandardService();
  @override
  void initState() {
    super.initState();
    setState(() {
      // fetchData();
      //TODO : change
      // fetchDataOfStandard();
      // standardsListFuture = firestoreService.getStandards();
      StandardService.getStandards();
    });
  }

  // Future<void> fetchData() async {
  //   try {
  //     var stream = StudentService.getStudentData();
  //     var userStream = UserService.getUserData();
  //     await for (var data in stream) {
  //       setState(() async {
  //         filteredData.clear();
  //         //TODO : change
  //         // yourDataList = data;
  //         for (var element in data) {
  //           if (element.isApproved == false) {
  //             filteredData.add(element);
  //           }
  //         }
  //
  //         await for (var data in userStream) {
  //           setState(() {
  //             userData = data;
  //             userfilterData = List.from(data);
  //             allUserData1 = data;
  //           });
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     print("Error fetching data: $e");
  //   }
  // }
//TODO : change
  // Future<void> fetchDataOfStandard() async {
  //   try {
  //     var stream = StudentService.getStandardData();
  //     await for (var data in stream) {
  //       setState(() {
  //         yourStandardList = data;
  //         filteredStandardData = List.from(data);
  //         for (var element in data) {
  //           if (element.isApproved == true) {
  //             filteredData.add(element);
  //           }
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     print("Error fetching data: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    print("tab allUserData1--- ${allUserData1}");
    return ListView(
      children: [
        SizedBox(
          height: Get.width * 0.01,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.01,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    StringUtils.addUser,
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
                          Get.offAll(() => const ResponsiveLayout(
                                desktopBody: DesktopLoginForm(),
                                mobileBody: LoginMobile(),
                                tabletBody: LoginTablet(),
                              ));
                        },
                        child: isLoggingOut
                            ? const CircularProgressIndicator()
                            : commonButton(StringUtils.logOut),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: Get.width * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      commonButton(StringUtils.addNew),
                      SizedBox(
                        width: Get.width * 0.01,
                      ),
                      InkWell(
                        onTap: () {},
                        child: const CustomText(
                          "1 row selected",
                          color: ColorUtils.black10,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 300.w,
                    child: TextFormField(
                      cursorColor: ColorUtils.grey66,
                      controller: searchController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                          color: ColorUtils.black,
                          fontFamily: "FiraSans",
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: ColorUtils.grey66),
                        contentPadding: EdgeInsets.only(left: Get.width * 0.02),
                        hintText: "Search",
                        hintStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: ColorUtils.grey66),
                        errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: ColorUtils.red)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: ColorUtils.greyD0)),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1.0, color: ColorUtils.greyD0),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        disabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1.0, color: ColorUtils.greyD0),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide:
                              BorderSide(width: 1.0, color: ColorUtils.greyD0),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
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
                  data: ThemeData.light().copyWith(cardColor: Colors.white),
                  child: PaginatedDataTable(
                    initialFirstRowIndex: 0,
                    onPageChanged: (int rowIndex) {
                      log("rowIndex :- $rowIndex");
                      // log("filteredData length :- ${widget.allUserData1.length}");
                      int remainingRows = allUserData1.length - rowIndex;
                      print("remainingRows :- $remainingRows");

                      setState(() {
                        _rowsPerPage = remainingRows >= 10 ? 10 : remainingRows;
                        log("_rowsPerPage :- $_rowsPerPage");
                      });
                    },
                    source: AllUserDataTableSource(
                        allUserData1,
                        commonUserDeleteDialog,
                        commonUserEditDialogEdit,
                        context),
                    dataRowMaxHeight: 60.w,
                    dataRowMinHeight: 40.w,
                    rowsPerPage: _rowsPerPage,
                    columnSpacing: 16,
                    columns: [
                      DataColumn(
                        label: commonText(
                          StringUtils.number,
                        ),
                      ),
                      DataColumn(
                        label: commonText(
                          StringUtils.mobileNumber,
                        ),
                      ),
                      DataColumn(
                        label: commonText(
                          StringUtils.password,
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
        ),
      ],
    );
  }
}
