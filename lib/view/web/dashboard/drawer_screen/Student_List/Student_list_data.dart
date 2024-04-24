// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:responsivedashboard/common_widget/common_btn.dart';
// import 'package:responsivedashboard/common_widget/custom_text.dart';
// import 'package:responsivedashboard/mobile/auth/login_mobile.dart';
// import 'package:responsivedashboard/model/student_model.dart';
// import 'package:responsivedashboard/tablet/auth/login_tablet.dart';
// import 'package:responsivedashboard/utils/color_utils.dart';
// import 'package:responsivedashboard/utils/image_utils.dart';
// import 'package:responsivedashboard/utils/string_utils.dart';
// import 'package:responsivedashboard/web/login_form/desktop_login_form.dart';
// import 'package:responsivedashboard/web/login_form/responsive_layout.dart';
// import 'package:responsivedashboard/web/responsive/common_method.dart';
// import 'package:responsivedashboard/web/responsive/drawer_screen/Student_List/student_data_class.dart';
// import 'package:responsivedashboard/web/responsive/final_data_ontap.dart';
//
// class StudentListData extends StatefulWidget {
//   final List<StudentModel> filteredData;
//   const StudentListData({
//     Key? key,
//     required this.filteredData,
//   }) : super(key: key);
//
//   @override
//   State<StudentListData> createState() => _StudentListDataState();
// }
//
// class _StudentListDataState extends State<StudentListData> {
//   TextEditingController searchController = TextEditingController();
//   bool isLoggingOut = false;
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       // flex: 2,
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(
//               height: Get.width * 0.01,
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: Get.width * 0.02,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// Textfield Row
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       /// Final Data
//                       CustomText(
//                         StringUtils.allResult,
//                         color: ColorUtils.black32,
//                         fontSize: 30.sp,
//                         fontWeight: FontWeight.w500,
//                       ),
//                       Row(
//                         children: [
//                           commonButton(StringUtils.matchOut),
//                           SizedBox(
//                             width: Get.width * 0.01,
//                           ),
//                           InkWell(
//                             onTap: () async {
//                               setState(() {
//                                 isLoggingOut = true;
//                               });
//                               await signOut();
//                               setState(() {
//                                 isLoggingOut = false;
//                               });
//                               Get.to(ResponsiveLoginLayout(
//                                 desktopBodyLogin: const DesktopLoginForm(),
//                                 mobileBodyLogin: const LoginMobile(),
//                                 tabletBodyLogin: const LoginTablet(),
//                               ));
//                             },
//                             child: isLoggingOut ? const CircularProgressIndicator() : commonButton(StringUtils.logOut),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                   SizedBox(
//                     height: Get.width * 0.02,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           commonButton(StringUtils.addNew),
//                           SizedBox(
//                             width: Get.width * 0.01,
//                           ),
//                           InkWell(
//                             onTap: () {},
//                             child: const CustomText(
//                               "1 row selected",
//                               color: ColorUtils.black10,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       /// Search Textfield
//                       SizedBox(
//                         width: 300.w,
//                         child: TextFormField(
//                           cursorColor: ColorUtils.grey66,
//                           controller: searchController,
//                           keyboardType: TextInputType.emailAddress,
//                           style: const TextStyle(color: ColorUtils.black, fontFamily: "FiraSans", fontSize: 18, fontWeight: FontWeight.w400),
//                           decoration: InputDecoration(
//                             prefixIcon: const Icon(Icons.search_rounded, color: ColorUtils.grey66),
//                             contentPadding: EdgeInsets.only(left: Get.width * 0.02),
//                             hintText: "Search",
//                             hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: ColorUtils.grey66),
//                             errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: ColorUtils.red)),
//                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: ColorUtils.greyD0)),
//                             focusedBorder: const OutlineInputBorder(
//                               borderSide: BorderSide(width: 1.0, color: ColorUtils.greyD0),
//                               borderRadius: BorderRadius.all(Radius.circular(8)),
//                             ),
//                             disabledBorder: const OutlineInputBorder(
//                               borderSide: BorderSide(width: 1.0, color: ColorUtils.greyD0),
//                               borderRadius: BorderRadius.all(Radius.circular(8)),
//                             ),
//                             enabledBorder: const OutlineInputBorder(
//                               borderRadius: BorderRadius.all(Radius.circular(8)),
//                               borderSide: BorderSide(width: 1.0, color: ColorUtils.greyD0),
//                             ),
//                           ),
//                           onChanged: (value) {
//                             var data = widget.filteredData;
//                             if (value.isNotEmpty) {
//                               data = yourDataList.where((element) => element.studentFullName!.toLowerCase().contains(value)).toList();
//                             } else {
//                               data = yourDataList;
//                             }
//                             setState(() {});
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: Get.width * 0.02,
//                   ),
//
//                   /// Gridview.builder
//                   GridView.builder(
//                     padding: EdgeInsets.only(right: 25.w),
//                     shrinkWrap: true,
//                     itemCount: yourStandardList.length,
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 40.h, childAspectRatio: 5, crossAxisSpacing: 15.w),
//                     itemBuilder: (context, index) {
//                       var element = yourStandardList[index];
//                       return InkWell(
//                         onTap: () {
//                           Get.offAll(ResponsiveLoginLayout(
//                             desktopBodyLogin: StudentList(
//                               studentId: element.standard.toString(),
//                               filteredData: yourDataList,
//                             ),
//                             mobileBodyLogin: OnTapFinalDataScreen(
//                               studentId: element.standard.toString(),
//                               yourDataList: yourDataList,
//                             ),
//                             tabletBodyLogin: OnTapFinalDataScreen(
//                               studentId: element.standard.toString(),
//                               yourDataList: yourDataList,
//                             ),
//                           ));
//                           // finalDataApprovedDialog(element.standard.toString());
//                         },
//                         child: Container(
//                           // height: 63.h,
//                           // width: 187.w,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15.r),
//                             border: Border.all(color: ColorUtils.greyEA, width: 3.w),
//                             color: ColorUtils.greyF9,
//                           ),
//                           child: Center(
//                               child: CustomText(
//                             element.standard ?? "",
//                             fontSize: 19.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: AssetsUtils.poppins,
//                             color: ColorUtils.black3F,
//                           )),
//                         ),
//                       );
//                     },
//                   ),
//                   // SizedBox(
//                   //   width: Get.width / 3,
//                   // ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
