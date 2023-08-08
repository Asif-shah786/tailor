import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tailor/config/theme/light_theme_colors.dart';
import 'package:lottie/lottie.dart';

import '../../../config/translations/strings_enum.dart';
import '../../../utils/constants.dart';

class DialogHelper {
  static get context => null;

  //show error dialog
  static void showErrorDialog(String title, String description) {
    Get.dialog(
      Dialog(
        elevation: 6,
        shadowColor: LightThemeColors.primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,

                ),
                maxLines: 4, overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 5.h),
              Lottie.asset(
                'animations/apiError.json',
                height: 120.h,
                repeat: true,
                reverse: true,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20.h),
              AnimatedTextKit(repeatForever: true, animatedTexts: [
                ColorizeAnimatedText(description,
                    textStyle: Get.textTheme.headlineMedium as TextStyle,
                    textAlign: TextAlign.center,
                    colors: [
                      Colors.purple,
                      Colors.blue,
                      Colors.yellow,
                      Colors.red,
                    ]),
              ]),
              SizedBox(height: 30.h),
              SizedBox(
                width: 100.w,
                child: ElevatedButton(
                  onPressed: () {
                    if (Get.isDialogOpen!) Get.back();
                  },
                  child: Text(Strings.okay.tr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///show loading
  static void showLoading() {
    Get.dialog(
      Center(
        child: Container(
          height: 80.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // App Icon
              Container(
                height: 50.sp,
                width: 50.sp,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(
                      AppImages.kAppIcon,
                    ),
                  ),
                ),
              ),
              // Loader
              SizedBox(
                  height: 60.h,
                  width: 60.w,
                  child: const CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  //hide loading
  static void hideLoading() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }
}