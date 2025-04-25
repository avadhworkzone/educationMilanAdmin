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
import 'package:responsivedashboard/utils/string_utils.dart';
import '../../screens/dashboard.dart';

class DesktopLoginForm extends StatefulWidget {
  const DesktopLoginForm({Key? key}) : super(key: key);

  @override
  State<DesktopLoginForm> createState() => _DesktopLoginFormState();
}

class _DesktopLoginFormState extends State<DesktopLoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(AssetsUtils.loginImage,
                width: Get.width, fit: BoxFit.fill),
            Padding(
              padding: EdgeInsets.only(
                  left: 120.r, top: 70.r, right: 120.r, bottom: 70.r),
              child: Container(
                // height: 800,
                width: double.infinity,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 4,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    color: ColorUtils.white,
                    borderRadius: BorderRadius.circular(20.0)),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                          padding: const EdgeInsets.all(150).r,
                          child: ListView(
                            children: [
                              Image.asset(
                                AssetsUtils.logo,
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              CustomText(
                                textAlign: TextAlign.center,
                                StringUtils.appName,
                                fontWeight: FontWeight.w400,
                                color: ColorUtils.purple2E,
                                fontSize: 30.sp,
                                fontFamily: AssetsUtils.dMSerifDisplay,
                              )
                            ],
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 60.r, bottom: 60.r),
                      child: Container(
                        width: 2.w,
                        color: Colors.grey.shade200,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 35.r, left: 120.r, right: 120.r),
                        child: SizedBox(
                          height: Get.height,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                AssetsUtils.signupLogo,
                                height: 60.h,
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
                                width: 30.w,
                                decoration: BoxDecoration(
                                    color: ColorUtils.primaryColor,
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              SizedBox(
                                height: 50.w,
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
                                    SizedBox(
                                      width: 300.w,
                                      child: CommonTextField(
                                        hintText: "Enter Your Email",
                                        textEditController: emailController,
                                        keyBoardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value == null ||
                                              !isValidEmail(value)) {
                                            return 'Please enter a valid email address';
                                          }
                                          return null;
                                        },
                                      ),
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
                                    SizedBox(
                                      width: 300.w,
                                      child: CommonTextField(
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
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 50.w,
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
                                      PreferenceManagerUtils.setLoginAdmin(
                                          emailController.text);

                                      Get.offAll(
                                          ()=>  const DesktopScaffold(),
                                      );
                                      ToastUtils.showCustomToast(
                                        context: context,
                                        title: "Login Successfully",
                                      );
                                    } else {
                                      ToastUtils.showCustomToast(
                                        context: context,
                                        title: "Some Thing Went Wrong",
                                      );
                                    }
                                  }
                                  // if (_formKey.currentState!.validate()) {
                                  //   setState(() {
                                  //     isLoading = true;
                                  //   });
                                  //
                                  //   final status = await AuthService.signIn(
                                  //       docId: emailController.text,
                                  //       pin: passwordController.text);
                                  //   setState(() {
                                  //     isLoading = false;
                                  //   });
                                  //
                                  //   if (status == true) {
                                  //     PreferenceManagerUtils.setIsLogin(true);
                                  //     Get.offAll(
                                  //       const ResponsiveLayout(
                                  //         desktopBody: DesktopScaffold(),
                                  //         mobileBody: MobileBottombar(),
                                  //         tabletBody: TabletBottombar(),
                                  //       ),
                                  //     );
                                  //     ToastUtils.showCustomToast(
                                  //       context: context,
                                  //       title: "Login Successfully",
                                  //     );
                                  //   } else {
                                  //     ToastUtils.showCustomToast(
                                  //       context: context,
                                  //       title: "Some Thing Went Wrong",
                                  //     );
                                  //   }
                                  // }
                                },
                                child: isLoading
                                    ? const CircularProgressIndicator() // Show loader when isLoading is true
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: const Color(0XFF251E90),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 6.h, horizontal: 23.w),
                                          child: CustomText(
                                            StringUtils.log,
                                            color: ColorUtils.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                              ),
                              SizedBox(
                                height: 10.w,
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
                              SizedBox(
                                height: 60.w,
                              ),
                              CustomText(
                                StringUtils.privacyPolicy,
                                color: ColorUtils.grey9A,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool isValidEmail(String value) {
  final emailRegExp = RegExp(
    r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
    caseSensitive: false,
  );
  return emailRegExp.hasMatch(value);
}

String? validatePassword(String? value) {
  // Password should not be empty
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }

  // Password should be at least 8 characters long
  if (value.length < 8) {
    return 'Password must be at least 8 characters long';
  }

  // Password should contain a mix of uppercase and lowercase letters
  if (!value.contains(RegExp(r'[A-Z]')) || !value.contains(RegExp(r'[a-z]'))) {
    return 'Password should contain a mix of uppercase and lowercase letters';
  }

  // Password should contain at least one digit
  if (!value.contains(RegExp(r'[0-9]'))) {
    return 'Password should contain at least one digit';
  }
  // Password should contain at least one special character
  if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    return 'Password should contain at least one special character';
  }
  // Additional password complexity rules can be added as needed

  return null; // Password is valid
}
