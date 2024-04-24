import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsivedashboard/firebase_options.dart';
import 'package:responsivedashboard/utils/share_preference.dart';
import 'package:responsivedashboard/view/web/auth/desktop_login_form.dart';
import 'package:responsivedashboard/responsiveLayout/responsive_layout.dart';
import 'package:responsivedashboard/view/web/dashboard/dashboard.dart';
import 'package:responsivedashboard/viewmodel/dashboard_viewmodel.dart';

import 'utils/pdf_service.dart';
import 'view/mobile/auth/login_mobile.dart';
import 'view/mobile/bottombar_mobile/mobile_bottombar.dart';
import 'view/tablet/auth/login_tablet.dart';
import 'view/tablet/bottomebar_tablet/tablet_bottombar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDipGtXqmwN1gX1r7WxQS4mO0nczzxEFx8",
          authDomain: "bordaparivar-85e13.firebaseapp.com",
          projectId: "bordaparivar-85e13",
          storageBucket: "bordaparivar-85e13.appspot.com",
          messagingSenderId: "862823786092",
          appId: "1:862823786092:web:b50f311de7461e95c1da49",
          measurementId: "G-PX272LXVD8")
      // options: DefaultFirebaseOptions.web
      );

  await GetStorage.init();
  await PdfService.getGujaratiFont();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          // home: HomeScreen(),
          home: PreferenceManagerUtils.getIsLogin() == true
              ? const ResponsiveLayout(
                  mobileBody: MobileBottombar(),
                  tabletBody: TabletBottombar(),
                  desktopBody: DesktopScaffold(),
                )
              : const ResponsiveLayout(
                  desktopBody: DesktopLoginForm(),
                  mobileBody: LoginMobile(),
                  tabletBody: LoginTablet(),
                ),
          // initialBinding: BindingsBuilder(() {
          //   Get.put(StudentListController());
          // }),
        );
      },
    );
  }

  DashboardViewModel dashboardViewModel = Get.put(DashboardViewModel());
}
