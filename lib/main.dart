import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tailor/app/components/splash/splash_binding.dart';

import 'app/data/local/my_shared_pref.dart';
import 'app/data/local/tasks_db.dart';
import 'app/routes/app_pages.dart';
import 'config/theme/my_theme.dart';
import 'config/translations/localization_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();



  // // if (Platform.isWindows || Platform.isLinux) {
  // //   // Initialize FFI
  //   sqfliteFfiInit();
  // }
  // // Change the default factory. On iOS/Android, if not using `sqlite_flutter_lib` you can forget
  // // this step, it will use the sqlite version available on the system.

  // Device info
//  DeviceInfoHelper.initializeDeviceInfo();

  // Shared pref
  await MySharedPref.init();

  // inti fcm services
  // await FcmHelper.initFcm();

  // FCM foreground message
  // FirebaseMessaging.onMessage.listen(FcmHelper.fcmForegroundHandler);

  // initialize local notifications service
  // await AwesomeNotificationsHelper.init();

  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      rebuildFactor: RebuildFactors.all,
      builder: (context, widget) {
        return GetMaterialApp(
          title: "GetXStandard",
          useInheritedMediaQuery: true,
          debugShowCheckedModeBanner: false,
          builder: (context, widget) {
            bool themeIsLight = MySharedPref.getThemeIsLight();
            return Theme(
              data: MyTheme.getThemeData(isLight: themeIsLight),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!,
              ),
            );
          },
          initialRoute: AppPages.SPLASH,
          // first screen to show when app is running

          defaultTransition: Transition.noTransition,

          getPages: AppPages.routes,
          // app screens
          locale: MySharedPref.getCurrentLocal(),
          // app language
          translations:
              LocalizationService(), // localization services in app (controller app language)
        );
      },
    ),
  );
}
