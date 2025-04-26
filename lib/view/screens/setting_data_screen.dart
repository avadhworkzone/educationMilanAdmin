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
import 'package:responsivedashboard/view/web/auth/desktop_login_form.dart';
import 'package:responsivedashboard/view/web/dashboard/common_method.dart';
import 'package:responsivedashboard/view/web/dashboard/drawer_screen/add_standard.dart';
import 'package:responsivedashboard/view/web/dashboard/drawer_screen/add_village.dart';

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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
        children: [
          SizedBox(height: 10),
          buildHeaderRow(),
          SizedBox(height: 20.h),
          buildStandardSection(),
          SizedBox(height: 30.h),
          buildVillageSection(),
        ],
      ),
    );
  }

  Widget buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          StringUtils.settingData,
          color: ColorUtils.black32,
          fontSize: 30,
          fontWeight: FontWeight.w500,
        ),
        InkWell(
          onTap: () async {
            setState(() => isLoggingOut = true);
            await signOut();
            setState(() => isLoggingOut = false);
            Get.offAll(() => const DesktopLoginForm());
          },
          child: isLoggingOut
              ? const CircularProgressIndicator()
              : commonButton(StringUtils.logOut),
        ),
      ],
    );
  }

  Widget buildStandardSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionHeader(
          title: StringUtils.standard,
          onAddPressed: () => addStandardDialog(context),
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
                  setState(() => standardsList.remove(standard));
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
          onAddPressed: () => addVillageDialog(context),
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
                  setState(() => villageList.remove(village));
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
