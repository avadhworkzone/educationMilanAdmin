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
void deleteUserWithReason(String studentId, bool isApprove, String fcmToken, VoidCallback onSuccess) {
  final TextEditingController reasonController = TextEditingController();
  bool isDeleting = false;

  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              width: 300.w,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(
                      StringUtils.deleteTitle,
                      color: ColorUtils.black32,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 16.h),
                    CommonTextField(
                      hintText: "Enter delete reason",
                      textEditController: reasonController,
                      keyBoardType: TextInputType.text,
                      maxLine: 3,
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: CustomText(
                            StringUtils.cancel,
                            color: ColorUtils.greyA7,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorUtils.redF3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                          ),
                          onPressed: () async {
                            final reason = reasonController.text.trim();

                            if (reason.isEmpty) {
                              Get.showSnackbar(
                                const GetSnackBar(
                                  message: "Please enter reason",
                                  duration: Duration(seconds: 2),
                                  backgroundColor: ColorUtils.primaryColor,
                                ),
                              );
                              return;
                            }

                            setState(() => isDeleting = true);

                            final success = await StudentService.deleteStudentResultReason(
                              studentId: studentId,
                              reason: reason,
                            );

                            setState(() => isDeleting = false);

                            if (success) {
                              await NotificationMethods.sendMessage(
                                receiverFcmToken: fcmToken,
                                msg: 'Your result status has been rejected.',
                                title: 'Notification',
                              );
                              Get.back(); // close dialog
                              onSuccess(); // ✅ after delete, call success callback to refresh!
                            } else {
                              Get.showSnackbar(
                                const GetSnackBar(
                                  message: "Failed to delete student",
                                  duration: Duration(seconds: 2),
                                  backgroundColor: ColorUtils.red,
                                ),
                              );
                            }
                          },
                          child: isDeleting
                              ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                              : CustomText(
                            StringUtils.delete,
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
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
      required VoidCallback onSuccess, // ✅ ADD THIS

    }) {
  final TextEditingController fullNameController = TextEditingController(text: fullName ?? '');
  final TextEditingController percentageController = TextEditingController(text: personTage?.toString() ?? '');
  String? selectedVillage = villageName;
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      final isMobile = MediaQuery.of(context).size.width < 600;
      selectedValue = standard;

      return Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(horizontal: isMobile ? 10.w : 50.w, vertical: 24.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: StatefulBuilder(
          builder: (context, update) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.w : 30.w, vertical: 24.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Image
                      if ((image?.isNotEmpty ?? false))
                        Center(
                          child: InkWell(
                            onTap: () {
                              _showImageDialog(context, image);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                image!,
                                height: isMobile ? 180.h : 250.h,
                                width: isMobile ? 180.h : 250.h,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 50),
                              ),
                            ),
                          ),
                        ),

                      SizedBox(height: 24.h),

                      /// Student Name
                      buildLabel('Student Name', isMobile),
                      SizedBox(height: 8.h),
                      buildTextField(fullNameController, TextInputType.name),

                      SizedBox(height: 16.h),

                      /// Village Name (DROPDOWN now ✅)
                      buildLabel('Village Name', isMobile),
                      SizedBox(height: 8.h),
                      FutureBuilder<List<String>>(
                        future: StudentService().getVillagesByFamily(PreferenceManagerUtils.getLoginAdmin()), // ✅ from firestore
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            return DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                // filled: true,
                                // fillColor: ColorUtils.greyF6,
                              ),
                              value: selectedVillage,
                              isExpanded: true,
                              hint: Text('Select Village'),
                              validator: (value) => value == null ? 'Please select a village' : null,
                              onChanged: (String? newValue) {
                                update(() {
                                  selectedVillage = newValue;
                                });
                              },
                              items: snapshot.data!.map((String village) {
                                return DropdownMenuItem<String>(
                                  value: village,
                                  child: Text(village),
                                );
                              }).toList(),
                            );
                          } else {
                            return const Text("No villages available");
                          }
                        },
                      ),

                      SizedBox(height: 16.h),

                      /// Standard and Percentage
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildLabel('Standard', isMobile),
                                SizedBox(height: 8.h),
                                FutureBuilder<List<String>>(
                                  future: StudentService().getStandardsByFamily(PreferenceManagerUtils.getLoginAdmin()),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator());
                                    } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                                      return const Text('No standards found');
                                    }
                                    List<String> standardsList = snapshot.data!;
                                    return DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      isDense: true,
                                      menuMaxHeight: 200,
                                      value: selectedValue,
                                      validator: (value) => value == null ? "* Required" : null,
                                      decoration: const InputDecoration(border: OutlineInputBorder()),
                                      items: standardsList.map((std) => DropdownMenuItem(
                                        value: std,
                                        child: Text(std),
                                      )).toList(),
                                      onChanged: (value) {
                                        update(() {
                                          selectedValue = value;
                                        });
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildLabel('Percentage', isMobile),
                                SizedBox(height: 8.h),
                                buildTextField(
                                  percentageController,
                                  TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) return 'Required';
                                    final number = double.tryParse(value);
                                    if (number == null || number < 0 || number > 100) {
                                      return 'Enter 0 to 100';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 30.h),

                      /// Update Button
                      Center(
                        child: InkWell(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              update(() => isEdit = true);

                              reqModel.mobileNumber = mobileNumber;
                              reqModel.result = result;
                              reqModel.fcmToken = fcmToken;
                              reqModel.checkUncheck = checkUncheck;
                              reqModel.standard = selectedValue.toString();
                              reqModel.studentFullName = fullNameController.text;
                              reqModel.percentage = double.parse(percentageController.text);
                              reqModel.studentId = studentId;
                              reqModel.villageName = selectedVillage ?? '';
                              reqModel.userId = userId;
                              reqModel.isApproved = isApproved ?? false;
                              reqModel.createdDate = DateTime.now().toLocal().toString();
                              reqModel.imageId = imageId;
                              reqModel.reason = reason;
                              reqModel.status = status;

                              final isStatus = await StudentService.studentDetailsEdit(reqModel);

                              update(() => isEdit = false);

                              if (isStatus) {
                                NotificationMethods.sendMessage(
                                  receiverFcmToken: fcmToken,
                                  msg: 'Your result data has been edited.',
                                  title: 'Notification',
                                );
                                Get.back();
                                onSuccess(); // ✅ call refresh

                              }
                            }
                          },
                          child: isEdit
                              ? const CircularProgressIndicator()
                              : Container(
                            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
                            decoration: BoxDecoration(
                              color: const Color(0XFF251E90),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomText(
                              'Update',
                              fontSize: isMobile ? 32.sp : 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                  ,
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
void _showImageDialog(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.network(imageUrl, fit: BoxFit.contain),
      ),
    ),
  );
}

Widget buildLabel(String label, bool isMobile) {
  return Text(
    label,
    style: TextStyle(
      fontSize: isMobile ? 32.sp : 14.sp,
      fontWeight: FontWeight.w600,
      color: ColorUtils.black32,
    ),
  );
}

Widget buildTextField(TextEditingController controller, TextInputType type, {String? Function(String?)? validator}) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    validator: validator,
    decoration: const InputDecoration(
      border: OutlineInputBorder(),
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    ),
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
