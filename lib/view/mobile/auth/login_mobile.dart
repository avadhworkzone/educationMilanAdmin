import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsivedashboard/common_widget/common_text_form_field.dart';
import 'package:responsivedashboard/common_widget/common_tosat_msg.dart';
import 'package:responsivedashboard/common_widget/custom_text.dart';
import 'package:responsivedashboard/firbaseService/auth_services/login_services.dart';
import 'package:responsivedashboard/responsiveLayout/responsive_layout.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/utils/image_utils.dart';
import 'package:responsivedashboard/utils/share_preference.dart';
import 'package:responsivedashboard/utils/string_utils.dart';
import 'package:responsivedashboard/view/mobile/bottombar_mobile/mobile_bottombar.dart';
import 'package:responsivedashboard/view/tablet/bottomebar_tablet/tablet_bottombar.dart';
import 'package:responsivedashboard/view/web/auth/desktop_login_form.dart';
import 'package:responsivedashboard/view/web/dashboard/dashboard.dart';

class LoginMobile extends StatefulWidget {
  const LoginMobile({Key? key}) : super(key: key);

  @override
  State<LoginMobile> createState() => _LoginMobileState();
}

class _LoginMobileState extends State<LoginMobile> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.h),
          child: Column(
            children: [
              SizedBox(
                height: 150.h,
              ),
              Center(
                child: Image.asset(
                  AssetsUtils.logo,
                  scale: 2,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: CustomText(
                  StringUtils.appName,
                  fontWeight: FontWeight.w400,
                  color: ColorUtils.purple2E,
                  fontSize: 30.sp,
                  fontFamily: AssetsUtils.dMSerifDisplay,
                ),
              ),
              SizedBox(
                height: 10.w,
              ),
              CustomText(
                StringUtils.logIn,
                fontWeight: FontWeight.w600,
                color: ColorUtils.black,
                fontSize: 20,
              ),
              SizedBox(
                height: 10.w,
              ),
              Container(
                height: 3.h,
                width: 100.w,
                decoration: BoxDecoration(
                    color: ColorUtils.primaryColor,
                    borderRadius: BorderRadius.circular(5)),
              ),
              SizedBox(
                height: 30.w,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      StringUtils.email,
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: ColorUtils.black32,
                    ),
                    SizedBox(
                      height: 1.w,
                    ),

                    /// EMAIL field
                    CommonTextField(
                      hintText: "Enter Your Email",
                      textEditController: emailController,
                      keyBoardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || !isValidEmail(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomText(
                      StringUtils.password,
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: ColorUtils.black32,
                    ),
                    SizedBox(
                      height: 1.w,
                    ),

                    /// PASSWORD field
                    CommonTextField(
                      obscureValue: _obscureText,
                      sIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      hintText: "Enter Your Password",
                      textEditController: passwordController,
                      keyBoardType: TextInputType.name,
                      validator: validatePassword,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100.w,
              ),
              InkWell(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });

                    final status = await AuthService.signIn(
                        docId: emailController.text,
                        pin: passwordController.text);
                    setState(() {
                      isLoading = false;
                    });

                    if (status == true) {
                      PreferenceManagerUtils.setIsLogin(true);
                      Get.to(
                        const ResponsiveLayout(
                          desktopBody: DesktopScaffold(),
                          mobileBody: MobileBottombar(),
                          tabletBody: TabletBottombar(),
                        ),
                      );
                      ToastUtils.showCustomToast(
                        context: context,
                        title: "Login Successfully",
                      );
                    } else {
                      ToastUtils.showCustomToast(
                        context: context,
                        title: "Some Thing Went Wrong!",
                      );
                    }
                  }
                },
                child: isLoading
                    ? const CircularProgressIndicator() // Show loader when isLoading is true
                    : Container(
                        width: 500.w,
                        // height: 50.h,
                        decoration: BoxDecoration(
                            color: const Color(0XFF251E90),
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: CustomText(
                            textAlign: TextAlign.center,
                            StringUtils.log,
                            color: ColorUtils.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
              ),
              SizedBox(
                height: 20.w,
              ),
              CustomText(
                StringUtils.forgetPassword,
                color: ColorUtils.grey9A,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(
                height: 10.w,
              ),
              CustomText(
                StringUtils.signIn,
                color: ColorUtils.purple2E,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: CustomText(
          textAlign: TextAlign.center,
          StringUtils.privacyPolicy,
          color: ColorUtils.grey9A,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
