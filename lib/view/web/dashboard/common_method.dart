import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsivedashboard/common_widget/common_text_form_field.dart';
import 'package:responsivedashboard/common_widget/custom_assets.dart';
import 'package:responsivedashboard/common_widget/custom_text.dart';
import 'package:responsivedashboard/common_widget/octa_image.dart';
import 'package:responsivedashboard/firbaseService/student_service/student_details_services.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/model/user_model.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/utils/image_utils.dart';
import 'package:responsivedashboard/utils/share_preference.dart';
import 'package:responsivedashboard/utils/string_utils.dart';
import 'package:responsivedashboard/view/services/app_notification.dart';

import '../../../firbaseService/user_service/user_service.dart';

bool isDelete = false;
bool isEdit = false;
String? selectedValue;
final _formKey = GlobalKey<FormState>();
Future<List<String>>? standardsListFuture;
StudentModel reqModel = StudentModel();
UserResModel userResModel = UserResModel();
// List<StudentModel> yourDataList = [];
// List<StudentModel> yourStandardList = [];
List<UserResModel> userData = [];
List<UserResModel> userfilterData = [];
Widget commonTab({
  required String icon,
  required String title,
  required Function onTap,
  required Color color,
  double? iconWidth,
  double? iconHeight,
}) {
  bool isMobile = Get.width < 600; // if width < 600, it's mobile

  return Container(
    color: color,
    child: InkWell(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        child: Row(
          children: [
            if (title == "Promotion") const SizedBox(width: 8),
            LocalAssets(
              imagePath: icon,
              width: iconWidth ?? (isMobile ? 24.w : 30.w),
              height: iconHeight ?? (isMobile ? 24.h : 30.h),
              imgColor: Colors.white,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: CustomText(
                title,
                fontWeight: FontWeight.w500,
                color: ColorUtils.white,
                fontSize: isMobile ? 13.sp : 15.sp,
                fontFamily: AssetsUtils.poppins,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

///delete dialog
void commonDeleteDialog(String studentId, bool isApprove, String fcmToken) {
  showDialog(
    context: Get.context!,
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
                            print("======false========$isDelete");
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
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }),
      );
    },
  );
}

///delete dialog
void deleteUserWithReason(String studentId, bool isApprove, String fcmToken) {
  final TextEditingController reasonController = TextEditingController();
  showDialog(
    context: Get.context!,
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
                  CommonTextField(
                    hintText: "Enter delete reason",
                    textEditController: reasonController,
                    keyBoardType: TextInputType.emailAddress,
                    maxLine: 2,
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
                          if (reasonController.text.isEmpty) {
                            Get.showSnackbar(const GetSnackBar(
                              message: "Please enter reason",
                              duration: Duration(seconds: 2),
                              backgroundColor: ColorUtils.primaryColor,
                            ));
                            return;
                          }

                          update(() {
                            isDelete = true;
                          });
                          final status = await StudentService.deleteStudentWithReason(
                              studentId, reasonController.text, isApprove);
                          update(() {
                            isDelete = false;
                            print("======false========$isDelete");
                          });
                          if (status) {
                            NotificationMethods.sendMessage(
                                    receiverFcmToken: fcmToken,
                                    msg: 'your result status is Rejected',
                                    title: 'Notification')
                                .then((value) => Get.back());
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
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }),
      );
    },
  );
}

///delete dialog
void commonUserDeleteDialog(String userId, bool isApprove, String fcmToken) {
  showDialog(
    context: Get.context!,
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
                          final status = await UserService.deleteUser(userId);
                          update(() {
                            isDelete = false;
                            print("======false========$isDelete");
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
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }),
      );
    },
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
  String? imageId,
  String? reason,
  String? status,
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

                                  if (parsedValue == null || parsedValue < 0 || parsedValue > 100) {
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
                            reqModel.isApproved = isApproved ?? false;
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
                                  title: 'Notification');
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
    context: Get.context!,
  );
}

///User edit dialog
void commonUserEditDialogEdit(
  final String? phoneNo,
  final String? password,
) {
  final TextEditingController phoneController = TextEditingController(text: phoneNo ?? '');
  final TextEditingController passwordController = TextEditingController(text: password);

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
            width: 400.w,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// UserName field
                    CustomText(
                      StringUtils.mobileNumber,
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
                        textEditController: phoneController,
                        keyBoardType: TextInputType.phone,
                      ),
                    ),
                    SizedBox(
                      height: 10.w,
                    ),

                    /// passord no field
                    CustomText(
                      StringUtils.password,
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: ColorUtils.black32,
                    ),

                    SizedBox(
                      height: 1.w,
                    ),

                    CommonTextField(
                      textEditController: passwordController,
                      keyBoardType: TextInputType.number,
                    ),

                    SizedBox(
                      height: 10.w,
                    ),

                    Center(
                      child: InkWell(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            update(() {
                              isEdit = true;
                            });

                            userResModel.phoneNo = phoneController.text;
                            userResModel.pin = passwordController.text;

                            print("userResModel.phoneNo == ${userResModel.phoneNo}");
                            print("userResModel.pin == ${userResModel.pin}");

                            final status = await UserService.userDetailsEdit(
                              phoneNo ?? "",
                              userResModel,
                            );

                            update(() {
                              isEdit = false;
                            });

                            if (status) {
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
    context: Get.context!,
  );
}

///CHECK ACCEPT UNBOX DIALOG
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
                            NotificationMethods.sendMessage(
                                receiverFcmToken: fcmToken,
                                msg: 'your result status is Approved',
                                title: 'Notification');
                            Get.back();
                            // fetchData();
                            // UserService.getUserData();
                            // Get.offAll(() => ResponsiveLoginLayout(
                            //       desktopBodyLogin: const DesktopScaffold(),
                            //       mobileBodyLogin: const MobileLoginForm(),
                            //       tabletBodyLogin: const TabletLoginForm(),
                            // ));
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
    context: Get.context!,
  );
}

///CHECK REJECT DIALOG
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
    context: Get.context!,
  );
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
