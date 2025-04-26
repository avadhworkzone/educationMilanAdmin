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

  @override
  void initState() {
    super.initState();
    fetchSettingsData();
  }

  Future<void> fetchSettingsData() async {
    try {
      villageList = await VillageService().getVillagesByFamily();
      standardsList = await StandardService.getStandardsByFamily(PreferenceManagerUtils.getFamilyCode());
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
}
