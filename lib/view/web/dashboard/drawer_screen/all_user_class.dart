import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsivedashboard/common_widget/column_text.dart';
import 'package:responsivedashboard/common_widget/common_btn.dart';
import 'package:responsivedashboard/common_widget/custom_text.dart';
import 'package:responsivedashboard/firbaseService/user_service/user_service.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/model/user_model.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/utils/share_preference.dart';
import 'package:responsivedashboard/utils/string_utils.dart';
import 'package:responsivedashboard/view/tablet/auth/login_tablet.dart';
import 'package:responsivedashboard/view/web/auth/desktop_login_form.dart';
import 'package:responsivedashboard/responsiveLayout/responsive_layout.dart';
import 'package:responsivedashboard/view/web/dashboard/common_method.dart';
import 'package:responsivedashboard/view/web/dashboard/user_details.dart';
import 'package:responsivedashboard/viewmodel/dashboard_viewmodel.dart';
import '../../../../common_widget/no_data_found.dart';
import '../../../mobile/auth/login_mobile.dart';

class AllUser extends StatefulWidget {
  const AllUser({Key? key}) : super(key: key);

  @override
  State<AllUser> createState() => _AllUserState();
}

class _AllUserState extends State<AllUser> {
  int _rowsPerPage = 10;
  bool isLoggingOut = false;
  TextEditingController searchController = TextEditingController();
  DashboardViewModel dashboardViewModel = Get.find<DashboardViewModel>();
  List<UserResModel> userList = [];
  List<UserResModel> userFilterList = [];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: ListView(
        children: [
          SizedBox(
            height: Get.width * 0.01,
          ),

          /// Textfield Row
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
                      /// All User
                      CustomText(
                        StringUtils.addUser,
                        color: ColorUtils.black32,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
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
                      )
                    ],
                  ),
                  SizedBox(
                    height: Get.width * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Search Textfield
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
                            contentPadding:
                                EdgeInsets.only(left: Get.width * 0.02),
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
                              borderSide: BorderSide(
                                  width: 1.0, color: ColorUtils.greyD0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            disabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1.0, color: ColorUtils.greyD0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                  width: 1.0, color: ColorUtils.greyD0),
                            ),
                          ),
                          onChanged: (value) {
                            // var data = widget.filteredData;
                            // if (value.isNotEmpty) {
                            //   data = yourDataList
                            //       .where((element) => element.studentFullName!
                            //           .toLowerCase()
                            //           .contains(value))
                            //       .toList();
                            // } else {
                            //   data = yourDataList;
                            // }
                            // setState(() {
                            //   yourDataList = data;
                            //   PreferenceManagerUtils.setData(data);
                            // });
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
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
                StreamBuilder<List<UserResModel>>(
                    stream: UserService.getUserData(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return noDataFound();
                      }
                      userList = snapshot.data!;
                      userFilterList = filterUserData(searchController.text);
                      return SizedBox(
                          width: double.infinity,
                          child: Theme(
                            data: ThemeData.light()
                                .copyWith(cardColor: Colors.white),
                            child: PaginatedDataTable(
                              initialFirstRowIndex: 0,
                              onPageChanged: (int rowIndex) {
                                log("rowIndex :- $rowIndex");
                                log("filteredData length :- ${userFilterList.length}");
                                int remainingRows =
                                    userFilterList.length - rowIndex;
                                print("remainingRows :- $remainingRows");

                                setState(() {
                                  _rowsPerPage =
                                      remainingRows >= 10 ? 10 : remainingRows;
                                  log("_rowsPerPage :- $_rowsPerPage");
                                });
                              },
                              source: AllUserDataTableSource(
                                  userFilterList,
                                  commonUserDeleteDialog,
                                  commonUserEditDialogEdit,
                                  context),
                              dataRowMaxHeight: 60.w,
                              dataRowMinHeight: 40.w,
                              rowsPerPage: _rowsPerPage,
                              columnSpacing: 8,
                              columns: [
                                DataColumn(
                                    label: commonText(
                                  StringUtils.number,
                                )),
                                DataColumn(
                                    label: commonText(
                                  StringUtils.mobileNumber,
                                )),
                                DataColumn(
                                    label: commonText(
                                  StringUtils.password,
                                )),
                                DataColumn(
                                    label: commonText(
                                  StringUtils.edit,
                                )),
                                DataColumn(
                                    label: commonText(
                                  StringUtils.delete,
                                )),
                              ],
                            ),
                          ));
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<UserResModel> filterUserData(String query) {
    if (query.isEmpty) {
      return userList;
    } else {
      return userList.where((user) {
        // Customize this condition based on your search criteria.
        return user.phoneNo?.toLowerCase().contains(query.toLowerCase()) ??
            false;
      }).toList();
    }
  }
}
