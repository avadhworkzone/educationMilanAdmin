import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsivedashboard/common_widget/common_text_form_field.dart';
import 'package:responsivedashboard/common_widget/custom_text.dart';
import 'package:responsivedashboard/firbaseService/village_service/village_services.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/utils/string_utils.dart';

void addVillageDialog(BuildContext context) {
  TextEditingController villageController = TextEditingController();
  bool isAdd = false;
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
            width: 300.w,
            child: Padding(
              padding: EdgeInsets.all(50.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Standard field
                  CustomText(
                    StringUtils.village,
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
                    height: 20.w,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () async {
                        if (villageController.text.isNotEmpty) {
                          update(() {
                            isAdd = true;
                          });
                          final status = await VillageService.addVillage(
                              {'villageName': villageController.text});
                          if (status) {
                            update(() {
                              isAdd = false;
                            });
                            Get.back();
                          } else {
                            update(() {
                              isAdd = false;
                            });
                          }
                        }
                      },
                      child: isAdd
                          ? const CircularProgressIndicator()
                          : Container(
                              width: 100.w,
                              decoration: BoxDecoration(
                                color: const Color(0XFF251E90),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomText(
                                    StringUtils.add,
                                    color: ColorUtils.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
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

void editVillageDialog(BuildContext context, int index, String currentVillage) {
  TextEditingController editVillageController =
      TextEditingController(text: currentVillage);
  bool isEdit = false;
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
            width: 300.w,
            child: Padding(
              padding: EdgeInsets.all(50.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Standard field
                  CustomText(
                    StringUtils.village,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                    color: ColorUtils.black32,
                  ),
                  SizedBox(
                    height: 1.w,
                  ),
                  CommonTextField(
                    textEditController: editVillageController,
                    keyBoardType: TextInputType.name,
                  ),
                  SizedBox(
                    height: 20.w,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () async {
                        if (editVillageController.text.isNotEmpty) {
                          update(() {
                            isEdit = true;
                          });
                          String villageId =
                              (index + 1).toString().padLeft(2, '0');
                          final status = await VillageService.editVillage(
                              villageId,
                              {"villageName": editVillageController.text});
                          if (status) {
                            update(() {
                              isEdit = false;
                            });
                            Get.back();
                          } else {
                            update(() {
                              isEdit = false;
                            });
                          }
                        }
                      },
                      child: isEdit
                          ? const CircularProgressIndicator()
                          : Container(
                              width: 100.w,
                              decoration: BoxDecoration(
                                color: const Color(0XFF251E90),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
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
                  ),
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

void deleteStandardDialog(BuildContext context, int index) {
  bool isDelete = false;
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: StatefulBuilder(
          builder: (context, update) {
            return SizedBox(
              width: 300.w,
              child: Padding(
                padding: EdgeInsets.all(50.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            String villageId =
                                (index + 1).toString().padLeft(2, '0');
                            final status =
                                await VillageService.deleteVillage(villageId);
                            if (status) {
                              update(() {
                                isDelete = false;
                              });
                              Get.back();
                            } else {
                              update(() {
                                isDelete = false;
                              });
                            }
                          },
                          child: isDelete
                              ? const CircularProgressIndicator()
                              : Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: ColorUtils.redF3),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6.h, horizontal: 20.w),
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
