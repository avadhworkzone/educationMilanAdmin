import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsivedashboard/common_widget/column_text.dart';
import 'package:responsivedashboard/common_widget/common_btn.dart';
import 'package:responsivedashboard/common_widget/custom_text.dart';
import 'package:responsivedashboard/firbaseService/standard_service/standad_services.dart';
import 'package:responsivedashboard/firbaseService/village_service/village_services.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/utils/share_preference.dart';
import 'package:responsivedashboard/utils/string_utils.dart';
import 'package:responsivedashboard/view/screens/signInPage.dart';
import 'package:responsivedashboard/view/web/auth/desktop_login_form.dart';
import 'package:responsivedashboard/view/web/dashboard/common_method.dart';
import 'package:responsivedashboard/view/screens/add_standard.dart';
import 'package:responsivedashboard/view/screens/add_village.dart';

class SettingDataScreen extends StatefulWidget {
  const SettingDataScreen({Key? key}) : super(key: key);

  @override
  State<SettingDataScreen> createState() => _SettingDataScreenState();
}

class _SettingDataScreenState extends State<SettingDataScreen> {
  bool isLoggingOut = false;
  List<String> villageList = [];
  List<String> standardsList = [];
  bool isLoading = true;
  String lastDateResult = '';
  TextEditingController lastDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSettingsData();
  }

  Future<void> fetchSettingsData() async {
    try {
      villageList = await VillageService().getVillagesByFamily();
      standardsList = await StandardService.getStandardsByFamily(PreferenceManagerUtils.getFamilyCode());

      final familyDoc = await FirebaseFirestore.instance
          .collection('families')
          .doc(PreferenceManagerUtils.getFamilyCode())
          .get();
      final familyData = familyDoc.data();
      lastDateResult = familyData?['lastDateResult']?.toString() ?? '';
      lastDateController.text = lastDateResult;
    } catch (e) {
      print('Error fetching setting data: $e');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> refreshStandardList() async {
    final updatedStandards = await StandardService.getStandardsByFamily(PreferenceManagerUtils.getFamilyCode());
    if (mounted) {
      setState(() {
        standardsList = updatedStandards;
      });
    }
  }

  Future<void> refreshVillageList() async {
    final updatedVillages = await VillageService().getVillagesByFamily();
    if (mounted) {
      setState(() {
        villageList = updatedVillages;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    return Expanded(
      flex: 2,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
        children: [
          const SizedBox(height: 10),
          buildHeaderRow(isMobile),
          SizedBox(height: 20.h),
          buildLastDateSection(),

          SizedBox(height: 20.h),
          buildStandardSection(),
          SizedBox(height: 30.h),
          buildVillageSection(),
        ],
      ),
    );
  }
  Widget buildHeaderRow(bool isMobile) {
    return Container(   decoration: BoxDecoration(
      color: ColorUtils.primaryColor,
      borderRadius: BorderRadius.circular(10),
    ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              StringUtils.settingData,
              color: ColorUtils.white,
              fontSize: isMobile ? 40.sp : 30.sp,
              fontWeight: FontWeight.w500,
            ),
            InkWell(
              onTap: () async {
                setState(() => isLoggingOut = true);
                await signOut();
                setState(() => isLoggingOut = false);
                Get.offAll(() => const SignUpScreenForm());
              },
              child: isLoggingOut
                  ? const CircularProgressIndicator()
                  : commonButton(StringUtils.logOut),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStandardSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionHeader(
          title: StringUtils.standard,
          onAddPressed: () async {
            final result = await addStandardDialog(context);
            if (result) {
              refreshStandardList(); // ✅ Refresh only if added
            }
          },
          addLabel: StringUtils.addStandard,
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: standardsList.map((standard) {
            return Chip(
              label: Text(standard),
              onDeleted: () async {
                final success = await StandardService.deleteStandardByName(standard);
                if (success) {
                  refreshStandardList(); // ✅ Refresh after delete
                }
              },
              deleteIcon: const Icon(Icons.delete_outline, color: ColorUtils.red),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget buildVillageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionHeader(
          title: StringUtils.village,
          onAddPressed: () async {
            final result = await addVillageDialog(context);
            if (result) {
              refreshVillageList(); // ✅ Refresh only if added
            }
          },
          addLabel: StringUtils.addVillage,
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: villageList.map((village) {
            return Chip(
              label: Text(village),
              onDeleted: () async {
                final success = await VillageService().deleteVillageByName(village);
                if (success) {
                  refreshVillageList(); // ✅ Refresh after delete
                }
              },
              deleteIcon: const Icon(Icons.delete_outline, color: ColorUtils.red),
            );
          }).toList(),
        ),
      ],
    );
  }
  Widget buildLastDateSection() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomText(
                'Last Date Result',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ColorUtils.black32,
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  pickDateAndSet();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: ColorUtils.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomText(
                    'Edit',
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: lastDateController,
                  readOnly: true,
                  enabled: false,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    filled: true,
                    fillColor: ColorUtils.greyF6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (lastDateController.text.trim() != lastDateResult)
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  updateLastDate();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: ColorUtils.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomText(
                    'Save',
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> pickDateAndSet() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final formattedDate = '${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}';
      setState(() {
        lastDateController.text = formattedDate;
      });
    }
  }

  Widget buildSectionHeader({
    required String title,
    required VoidCallback onAddPressed,
    required String addLabel,
  }) {
    return Row(
      children: [
        CustomText(
          title,
          color: ColorUtils.black32,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        const Spacer(),
        InkWell(
          onTap: onAddPressed,
          child: commonButton(addLabel),
        ),
      ],
    );
  }
  Future<void> updateLastDate() async {
    try {
      final input = lastDateController.text.trim();

      // Validate format
      final isValid = validateDateFormat(input);

      if (!isValid) {
        Get.snackbar('Invalid Date', 'Please enter date in dd-MM-yyyy format');
        return;
      }

      final familyCode = PreferenceManagerUtils.getFamilyCode();
      await FirebaseFirestore.instance
          .collection('families')
          .doc(familyCode)
          .update({'lastDateResult': input});

      setState(() {
        lastDateResult = input;
      });

      Get.snackbar('Success', 'Last Date updated successfully!');
    } catch (e) {
      print('Error updating last date: $e');
      Get.snackbar('Error', 'Failed to update Last Date');
    }
  }
  bool validateDateFormat(String input) {
    try {
      final parts = input.split('-');
      if (parts.length != 3) return false;

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final date = DateTime(year, month, day);

      // Check back if it matches exactly (to avoid invalid dates like 32-01-2025)
      return date.day == day && date.month == month && date.year == year;
    } catch (e) {
      return false;
    }
  }

  void formatDateInput(String value) {
    String newValue = value.replaceAll(RegExp(r'[^0-9]'), ''); // only digits

    if (newValue.length >= 3 && newValue.length <= 4) {
      newValue = newValue.substring(0, 2) + '-' + newValue.substring(2);
    } else if (newValue.length >= 5) {
      newValue = newValue.substring(0, 2) + '-' + newValue.substring(2, 4) + '-' + newValue.substring(4);
    }

    lastDateController.value = TextEditingValue(
      text: newValue,
      selection: TextSelection.collapsed(offset: newValue.length),
    );
  }

}
