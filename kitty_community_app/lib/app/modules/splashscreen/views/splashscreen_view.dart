import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/utils/extensions/logger_extension.dart';
import 'package:kitty_community_app/app/core/values/constants.dart';
import 'package:kitty_community_app/app/core/values/languages/key_language.dart';
import 'package:kitty_community_app/app/global_widgets/app_button.dart';
import 'package:kitty_community_app/app/routes/app_pages.dart';
import 'package:sizer/sizer.dart';

import '../controllers/splashscreen_controller.dart';

class SplashscreenView extends GetView<SplashscreenController> {
  const SplashscreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
                width: 100.w,
                height: 50.h,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(AssetsContants.splash_img),
                )),
            Text(
              "${KeyLanguage.find_the_pet_arround_you.tr.capitalize}",
              style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                KeyLanguage
                    .join_us_and_socialize_with_millions_of_people_in_your_community
                    .tr,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 6.h,
            ),
            AppButton(
                callback: () {
                  if (FirebaseAuth.instance.currentUser != null) {
                    // logger.i(FirebaseAuth.instance.currentUser);
                    Get.offAllNamed(Routes.WRAP, arguments: [FirebaseAuth.instance.currentUser]);
                  } else {
                    Get.toNamed(Routes.LOGIN);
                  }
                },
                width: 50.w,
                height: 7.h,
                label: KeyLanguage.get_started.tr)
          ],
        ),
      ),
    );
  }
}
