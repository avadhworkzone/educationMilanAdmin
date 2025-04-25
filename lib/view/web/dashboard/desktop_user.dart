import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsivedashboard/common_widget/column_text.dart';
import 'package:responsivedashboard/common_widget/common_btn.dart';
import 'package:responsivedashboard/common_widget/common_drawer.dart';
import 'package:responsivedashboard/common_widget/common_text_form_field.dart';
import 'package:responsivedashboard/common_widget/custom_text.dart';
import 'package:responsivedashboard/common_widget/octa_image.dart';
import 'package:responsivedashboard/firbaseService/standard_service/standad_services.dart';
import 'package:responsivedashboard/firbaseService/student_service/student_details_services.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/utils/share_preference.dart';
import 'package:responsivedashboard/utils/string_utils.dart';
import 'package:responsivedashboard/view/services/app_notification.dart';

import '../auth/desktop_login_form.dart';
import '../../screens/student_details_row.dart';

class DesktopAllUser extends StatefulWidget {
  const DesktopAllUser({Key? key}) : super(key: key);

  @override
  State<DesktopAllUser> createState() => _DesktopAllUserState();
}

class _DesktopAllUserState extends State<DesktopAllUser> {
  TextEditingController searchController = TextEditingController();
  StudentModel reqModel = StudentModel();
  int _rowsPerPage = 10;
  bool isLoggingOut = false;
  bool isDelete = false;
  bool isEdit = false;
  String? selectedValue;

  final StandardService firestoreService = StandardService();
  Future<List<String>>? standardsListFuture;
  String? downloadURL;

  final _formKey = GlobalKey<FormState>();
  String selectedFile = '';
  XFile? file;
  Uint8List? selectedImageInBytes;
  int imageCounts = 0;
  List<Uint8List> pickedImagesInBytes = [];
  List<StudentModel> yourDataList = [];
  List<StudentModel> filteredData = [];

  @override
  void initState() {
    super.initState();
    // fetchData();
    // standardsListFuture = firestoreService.getStandards();
    //   firestoreService.getStandards();
  }

  bool sortAscending = true;
  List<StudentModel> sortedData = [];

  void sortData(bool bool) {
    sortedData = List.from(yourDataList);
    sortedData.sort((a, b) {
      if (sortAscending) {
        return a.percentage!.compareTo(b.percentage!);
      } else {
        return b.percentage!.compareTo(a.percentage!);
      }
    });
  }

  //
  // void fetchData() async {
  //   try {
  //     var stream = StudentService.getStudentData();
  //
  //     await for (var data in stream) {
  //       setState(() {
  //         yourDataList = data;
  //         filteredData = List.from(data);
  //       });
  //     }
  //   } catch (e) {
  //     print("Error fetching data: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.white,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          myDrawer,
          Expanded(
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
                            CustomText(
                              StringUtils.allResult,
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

                            /// Search Text-field
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
                                  prefixIcon:
                                      const Icon(Icons.search_rounded, color: ColorUtils.grey66),
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
                                      borderSide: const BorderSide(color: ColorUtils.greyD0)),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.0, color: ColorUtils.greyD0),
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                  disabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.0, color: ColorUtils.greyD0),
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(width: 1.0, color: ColorUtils.greyD0),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    filteredData = yourDataList
                                        .where((element) =>
                                            element.studentFullName!.toLowerCase().contains(value))
                                        .toList();
                                  } else {
                                    filteredData = yourDataList;
                                  }

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
                      // SizedBox(
                      //     width: double.infinity,
                      //     child: Theme(
                      //       data: ThemeData.light().copyWith(cardColor: Colors.white),
                      //       child: PaginatedDataTable(
                      //         initialFirstRowIndex: 0,
                      //         onPageChanged: (int rowIndex) {
                      //           int remainingRows = filteredData.length - rowIndex;
                      //           // yourDataList.length - rowIndex;
                      //
                      //           setState(() {
                      //             _rowsPerPage = remainingRows >= 10 ? 10 : remainingRows;
                      //           });
                      //         },
                      //         source: YourDataTableSource(
                      //             filteredData,
                      //             // yourDataList,
                      //             commonDeleteDialog,
                      //             commonDialogEdit,
                      //             commonCheckUncheck,
                      //             // commonRejectDialog,
                      //             context),
                      //         dataRowMaxHeight: 60.w,
                      //         dataRowMinHeight: 40.w,
                      //         // headingRowColor: MaterialStateColor.resolveWith(
                      //         //     (Set<MaterialState> states) {
                      //         //   if (states.contains(MaterialState.selected)) {
                      //         //     return Colors.blue;
                      //         //   }
                      //         //   return Colors.white;
                      //         // }),
                      //         rowsPerPage: _rowsPerPage,
                      //         columnSpacing: 8,
                      //         columns: [
                      //           DataColumn(
                      //               label: commonText(
                      //             StringUtils.number,
                      //           )),
                      //           DataColumn(
                      //               label: commonText(
                      //             StringUtils.mobileNumber,
                      //           )),
                      //           DataColumn(
                      //               label: commonText(
                      //             StringUtils.date,
                      //           )),
                      //           DataColumn(
                      //               label: commonText(
                      //             StringUtils.studentName,
                      //           )),
                      //           DataColumn(
                      //               label: commonText(
                      //             StringUtils.villageName,
                      //           )),
                      //           DataColumn(
                      //               label: commonText(
                      //             StringUtils.percentage,
                      //           )),
                      //           DataColumn(
                      //               label: commonText(
                      //             StringUtils.imageUrl,
                      //           )),
                      //           DataColumn(
                      //               label: commonText(
                      //             StringUtils.delete,
                      //           )),
                      //           DataColumn(
                      //               label: commonText(
                      //             StringUtils.edit,
                      //           )),
                      //         ],
                      //       ),
                      //     )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///delete dialog
  commonDeleteDialog(String studentId, bool isApprove, String fcmToken) {
    showDialog(
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: StatefulBuilder(builder: (context, update) {
            return SizedBox(
              width: 200.w,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CustomText(
                      StringUtils.deleteTitle,
                      color: ColorUtils.black32,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: CustomText(
                            StringUtils.cancel,
                            color: ColorUtils.greyA7,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 6.w,
                        ),
                        InkWell(
                          onTap: () async {
                            update(() {
                              isDelete = true;
                            });
                            final status = await StudentService.deleteStudent(studentId);
                            update(() {
                              isDelete = false;
                              print("======false========${isDelete}");
                            });
                            if (status) {
                              Get.back();
                            } else {}
                          },
                          child: isDelete
                              ? const CircularProgressIndicator()
                              : Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: ColorUtils.redF3),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 20.w),
                                    child: CustomText(
                                      StringUtils.delete,
                                      color: ColorUtils.white,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
        );
      },
      context: context,
    );
  }

  ///edit dialog
  void commonDialogEdit(
    final String? image,
    final num? personTage,
    final String? standard,
    final String? fullName,
    final String studentId,
    final String userId,
    final String villageName,
    final String? createdDate, {
    required final String? mobileNumber,
    required final bool? isApproved,
    final String? result,
    required final String fcmToken,
    final String? checkUncheck,
    final String? imageId,
    final String? reason,
    final String? status,
  }) {
    final TextEditingController fullNameController = TextEditingController(text: fullName ?? '');
    final TextEditingController villageController = TextEditingController(text: villageName);
    final TextEditingController percentageController =
        TextEditingController(text: personTage?.toString() ?? '');

    showDialog(
      builder: (BuildContext context) {
        selectedValue = standard;
        return Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: StatefulBuilder(builder: (context, update) {
            return SizedBox(
              width: 400.w,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: GestureDetector(
                            // onTap: () async {
                            //   FilePickerResult? fileResult = await FilePicker
                            //       .platform
                            //       .pickFiles(allowMultiple: true);
                            //
                            //   if (fileResult != null) {
                            //     update(() {
                            //       selectedFile = fileResult.files.first.name;
                            //       selectedImageInBytes =
                            //           fileResult.files.first.bytes;
                            //     });
                            //   }
                            //   // _selectFile();
                            //   // handleImageTap();
                            // },

                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              height: 300.h,
                              width: 350.w,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                // child: OctoImage(image:  NetworkImage(image.toString(),)),
                                child: NetWorkOcToAssets(
                                  imgUrl: image.toString(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 20.h,
                      ),

                      /// Email field
                      CustomText(
                        StringUtils.studentFullName,
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                        color: ColorUtils.black32,
                      ),

                      SizedBox(
                        height: 1.w,
                      ),

                      SizedBox(
                        width: 300.w,
                        child: CommonTextField(
                          textEditController: fullNameController,
                          keyBoardType: TextInputType.name,
                        ),
                      ),
                      SizedBox(
                        height: 10.w,
                      ),

                      /// Village field
                      CustomText(
                        StringUtils.villageName,
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                        color: ColorUtils.black32,
                      ),

                      SizedBox(
                        height: 1.w,
                      ),

                      CommonTextField(
                        textEditController: villageController,
                        keyBoardType: TextInputType.name,
                      ),

                      SizedBox(
                        height: 10.w,
                      ),

                      /// ===============std and percentage=============== ///
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                StringUtils.standard,
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                color: ColorUtils.black32,
                              ),
                              SizedBox(
                                height: 1.w,
                              ),

                              /// drop down menu
                              SizedBox(
                                width: 100.w,
                                child: FutureBuilder<List<String>>(
                                  future: standardsListFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text(
                                          'Error: ${snapshot.error}',
                                        ),
                                      );
                                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                      return const Center(
                                        child: Text('No standards found.'),
                                      );
                                    } else {
                                      List<String> standardsList = snapshot.data!;
                                      Set<String> uniqueStandards = Set<String>.from(standardsList);
                                      return DropdownButtonFormField<String>(
                                        decoration: const InputDecoration(
                                            // ... Your decoration properties
                                            ),
                                        isExpanded: true,
                                        isDense: true,
                                        menuMaxHeight: 150.w,
                                        validator: (value) => value == null ? "* Required" : null,
                                        dropdownColor: ColorUtils.greyF6,
                                        value: selectedValue,
                                        onChanged: (String? newValue) {
                                          update(() {
                                            selectedValue = newValue;
                                          });
                                          Form.of(context).validate();
                                        },
                                        items: uniqueStandards.map((String standard) {
                                          return DropdownMenuItem<String>(
                                            value: standard,
                                            child: Text(standard),
                                          );
                                        }).toList(),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                StringUtils.percentageEdit,
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                color: ColorUtils.black32,
                              ),
                              SizedBox(
                                height: 1.w,
                              ),

                              /// percentage
                              SizedBox(
                                width: 100.w,
                                child: CommonTextField(
                                  textEditController: percentageController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return StringUtils.personaTageValidation;
                                    }

                                    double? parsedValue = double.tryParse(value);

                                    if (parsedValue == null ||
                                        parsedValue < 0 ||
                                        parsedValue > 100) {
                                      return 'Enter a 0 to 100';
                                    }
                                    return null;
                                  },
                                  keyBoardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 30.w,
                      ),

                      Center(
                        child: InkWell(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              update(() {
                                isEdit = true;
                              });
                              String? downloadUrl = '';
                              // if (selectedImageInBytes != null) {
                              //   downloadUrl =
                              //       await _uploadImageToFirebase();
                              // }
                              reqModel.mobileNumber = mobileNumber;
                              reqModel.result = result;
                              reqModel.fcmToken = fcmToken;
                              reqModel.checkUncheck = checkUncheck;
                              reqModel.standard = selectedValue.toString();
                              reqModel.studentFullName = fullNameController.text;
                              reqModel.percentage = double.parse(percentageController.text);
                              reqModel.studentId = studentId.toString();
                              reqModel.villageName = villageController.text;
                              reqModel.userId = userId.toString();
                              reqModel.checkUncheck = userId.toString();
                              reqModel.createdDate = DateTime.now().toLocal().toString();
                              reqModel.imageId = imageId;
                              reqModel.reason = reason;
                              reqModel.status = status;

                              final isStatus = await StudentService.studentDetailsEdit(
                                reqModel,
                              );

                              update(() {
                                isEdit = false;
                              });

                              if (isStatus) {
                                NotificationMethods.sendMessage(
                                  receiverFcmToken: fcmToken,
                                  msg: 'your result data is Edited',
                                  title: 'Notification',
                                );
                                Get.back();
                              }
                            }
                          },
                          child: isEdit
                              ? const CircularProgressIndicator()
                              : Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0XFF251E90),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomText(
                                      StringUtils.update,
                                      color: ColorUtils.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
      context: context,
    );
  }

  ///CHECK UNBOX DIALOG
  void commonCheckUncheck(String studentId, String fcmToken) {
    showDialog(
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: StatefulBuilder(builder: (context, update) {
            return SizedBox(
              width: 200.w,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CustomText(
                      "ARE YOU SURE TO ACCEPT",
                      color: ColorUtils.black32,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: CustomText(
                            "NO",
                            color: ColorUtils.greyA7,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 6.w,
                        ),
                        InkWell(
                          onTap: () async {
                            bool success = await StudentService.acceptStudentResult(studentId);
                            if (success) {
                              Get.back();
                            } else {
                              print("Failed to update isApproved in Firebase");
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20), color: ColorUtils.redF3),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 20.w),
                              child: CustomText(
                                "YES",
                                color: ColorUtils.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
        );
      },
      context: context,
    );
  }

  ///CHECK REJECT  DIALOG
  void commonRejectDialog(String studentId) {
    showDialog(
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: StatefulBuilder(builder: (context, update) {
            return SizedBox(
              width: 200.w,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CustomText(
                      "ARE YOU SURE TO ACCEPT",
                      color: ColorUtils.black32,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: CustomText(
                            "NO",
                            color: ColorUtils.greyA7,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 6.w,
                        ),
                        InkWell(
                          onTap: () async {
                            bool success = await StudentService.acceptStudentResult(studentId);
                            if (success) {
                              Get.back();
                            } else {
                              print("Failed to update isApproved in Firebase");
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20), color: ColorUtils.redF3),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 20.w),
                              child: CustomText(
                                "YES",
                                color: ColorUtils.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
        );
      },
      context: context,
    );
  }
}

///=======================SignOut===============///
Future<void> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    await PreferenceManagerUtils.clearPreference();
    print("User signed out");
  } catch (e) {
    print("Error signing out: $e");
  }
}
