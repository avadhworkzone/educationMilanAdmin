import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsivedashboard/common_widget/common_text_form_field.dart';
import 'package:responsivedashboard/common_widget/common_tosat_msg.dart';
import 'package:responsivedashboard/common_widget/custom_text.dart';
import 'package:responsivedashboard/firbaseService/auth_services/login_services.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/utils/image_utils.dart';
import 'package:responsivedashboard/utils/share_preference.dart';
import 'dashboard.dart';

class SignUpScreenForm extends StatefulWidget {
  const SignUpScreenForm({Key? key}) : super(key: key);

  @override
  State<SignUpScreenForm> createState() => _SignUpScreenFormState();
}

class _SignUpScreenFormState extends State<SignUpScreenForm> {
  final TextEditingController familyCodeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(AssetsUtils.loginImage, width: Get.width, fit: BoxFit.fill),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.r, vertical: 50.r),
              child: Container(
                decoration: BoxDecoration(
                  color: ColorUtils.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 700;
                    return isMobile
                        ? Column(
                      children: [
                        _buildLogoSection(isMobile: true),
                        // Divider(color: Colors.grey.shade300, thickness: 1),
                        _buildFormSection(isMobile: true),
                      ],
                    )
                        : Row(
                      children: [
                        Expanded(flex: 2, child: _buildLogoSection(isMobile: false)),
                        Container(width: 2, color: Colors.grey.shade300),
                        Expanded(flex: 3, child: _buildFormSection(isMobile: false)),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection({required bool isMobile}) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 40.r : 80.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AssetsUtils.logo, height:  200.h),
          SizedBox(height: 15.h),
          CustomText(
            "Education Milan",
            fontWeight: FontWeight.w500,
            color: ColorUtils.purple2E,
            fontSize: 40.sp,
            fontFamily: AssetsUtils.dMSerifDisplay,
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection({required bool isMobile}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 30.r : 60.r,
        horizontal: isMobile ? 40.r : 80.r,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isMobile?SizedBox(): Image.asset(AssetsUtils.signupLogo, height:80.h),
            SizedBox(height: 20.h),
            CustomText(
              "Login",
              fontWeight: FontWeight.w600,
              color: ColorUtils.primaryColor,
              fontSize: isMobile ? 60.sp : 22.sp,
            ),
            SizedBox(height: 6.h),
            Container(
              height: 3.h,
              width: 30.w,
              decoration: BoxDecoration(
                color: ColorUtils.primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            SizedBox(height: 30.h),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText("Family Code", fontWeight: FontWeight.w500, fontSize: 16, color: ColorUtils.black32),
                  SizedBox(height: 5.h),
                  CommonTextField(
                    hintText: "Enter Family Code",
                    textEditController: familyCodeController,
                    validator: (value) => value == null || value.isEmpty ? 'Please enter family code' : null,
                  ),
                  SizedBox(height: 20.h),
                  CustomText("Password", fontWeight: FontWeight.w500, fontSize: 16, color: ColorUtils.black32),
                  SizedBox(height: 5.h),
                  CommonTextField(
                    obscureValue: _obscureText,
                    sIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () => setState(() => _obscureText = !_obscureText),
                    ),
                    hintText: "Enter Password",
                    textEditController: passwordController,
                    validator: validatePassword,
                  ),
                ],
              ),
            ),
            SizedBox(height: 50.h),
            InkWell(
              onTap: _handleLogin,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : Container(
                decoration: BoxDecoration(
                  color: const Color(0XFF251E90),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 30.w),
                child: CustomText(
                  "Login",
                  color: ColorUtils.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            // CustomText(
            //   "Terms of use   Privacy policy",
            //   color: ColorUtils.grey9A,
            //   fontSize: 12,
            //   fontWeight: FontWeight.w500,
            // ),
          ],
        ),
      ),
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      final status = await AuthService.signIn(
        docId: familyCodeController.text.trim(),
        pin: passwordController.text.trim(),
      );

      setState(() => isLoading = false);

      if (status == true) {
        PreferenceManagerUtils.setIsLogin(true);
        PreferenceManagerUtils.setLoginAdmin(familyCodeController.text.trim());
        PreferenceManagerUtils.setFamilyCode(familyCodeController.text.trim());

        Get.offAll(()=>DesktopScaffold());

        ToastUtils.showCustomToast(context: context, title: "Login Successfully");
      } else {
        ToastUtils.showCustomToast(context: context, title: "Invalid Family Code or Password");
      }
    }
  }
}

// Optional: Use your original validatePassword function here
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'Password is required';
  // if (value.length < 8) return 'Password must be at least 8 characters';
  // if (!value.contains(RegExp(r'[A-Z]')) || !value.contains(RegExp(r'[a-z]'))) {
  //   return 'Use both upper and lowercase letters';
  // }
  // if (!value.contains(RegExp(r'[0-9]'))) return 'Include at least one digit';
  // if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
  //   return 'Include at least one special character';
  // }
  return null;
}
