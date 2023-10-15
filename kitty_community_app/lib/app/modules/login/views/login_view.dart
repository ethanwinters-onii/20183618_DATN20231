import 'dart:math';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/base/main_layout.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';
import 'package:kitty_community_app/app/core/utils/extensions/logger_extension.dart';
import 'package:kitty_community_app/app/core/utils/helpers/rive_utils.dart';
import 'package:kitty_community_app/app/core/values/constants.dart';
import 'package:kitty_community_app/app/core/values/languages/key_language.dart';
import 'package:kitty_community_app/app/global_widgets/app_button.dart';
import 'package:kitty_community_app/app/modules/login/views/sign_up_view.dart';
import 'package:rive/rive.dart';
import 'package:sizer/sizer.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MainLayout<LoginController>(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      indicator: Container(
        color: Colors.black.withOpacity(0.5),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Obx(() => controller.isShowLoading.value
                  ? Transform.scale(
                      scale: 0.25,
                      child: RiveAnimation.asset(
                        AssetsContants.check,
                        onInit: (artboard) {
                          logger.d("2");
                          StateMachineController stateMachineController =
                              RiveUtils.getRiveController(artboard);
                          controller.check = stateMachineController
                              .findSMI("Check") as SMITrigger;
                          controller.error = stateMachineController
                              .findSMI("Error") as SMITrigger;
                          controller.reset = stateMachineController
                              .findSMI("Reset") as SMITrigger;
                        },
                      ))
                  : const SizedBox()),
            ),
            Align(
              alignment: Alignment.center,
              child: Obx(() => controller.isShowConfetti.value
                  ? Transform.scale(
                      scale: 2,
                      child: RiveAnimation.asset(
                        AssetsContants.confetti,
                        onInit: (artboard) {
                          logger.d("1");
                          StateMachineController stateMachineController =
                              RiveUtils.getRiveController(artboard);
                          controller.confetti = stateMachineController
                              .findSMI("Trigger explosion") as SMITrigger;
                        },
                      ),
                    )
                  : const SizedBox()),
            ),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  KeyLanguage.sign_in.tr,
                  style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 20.sp),
                ),
                SizedBox(
                  width: 15.w,
                  height: 15.w,
                  child: const RiveAnimation.asset(AssetsContants.kitty_login),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  KeyLanguage.no_account.tr,
                ),
                GestureDetector(
                  onTap: () {
                    Get.dialog(const SignUpView(),
                        barrierDismissible: false,
                        transitionCurve: Curves.easeInOut);
                  },
                  child: Text(
                    KeyLanguage.make_account.tr,
                    style: const TextStyle(color: secondaryColor),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            Obx(
              () => TextFormField(
                decoration: InputDecoration(
                    filled: true,
                    fillColor: secondaryColor.withOpacity(0.1),
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                    suffixIcon: controller.isAvailableEmail.value
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
                        : null,
                    hintText: "Email"),
                controller: controller.emailEdittingController,
                onChanged: (value) {
                  controller.onChangeEmail();
                },
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Obx(
              () => TextFormField(
                obscureText: !controller.showPassword.value,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: secondaryColor.withOpacity(0.1),
                    prefixIcon: const Icon(
                      Icons.key,
                      color: Colors.black,
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        controller.changeShowPassword();
                      },
                      child: Icon(
                        controller.showPassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.black,
                      ),
                    ),
                    hintText: KeyLanguage.password.tr),
                controller: controller.passwordEdittingController,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Text(
              KeyLanguage.forgot_password.tr,
              style: const TextStyle(color: secondaryColor),
            ),
            SizedBox(
              height: 2.h,
            ),
            Center(
              child: AppButton(
                  callback: () {
                    controller.handleLoginWithEmailAndPassword();
                  },
                  width: 45.w,
                  height: 4.h,
                  label: KeyLanguage.sign_in.tr),
            ),
            SizedBox(
              height: 2.h,
            ),
            const Row(
              children: [
                Expanded(
                    child: Divider(
                  thickness: 1,
                )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'OR',
                    style: TextStyle(color: Colors.black26),
                  ),
                ),
                Expanded(
                    child: Divider(
                  thickness: 1,
                ))
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    controller.handleLoginWithGoogle();
                  },
                  style: ElevatedButton.styleFrom(fixedSize: Size(70.w, 4.h)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        AssetsContants.ic_google,
                        width: 32,
                        height: 32,
                      ),
                      Text(
                        KeyLanguage.sign_in_with_google.tr,
                        style: TextStyle(fontSize: 12.sp, color: Colors.black),
                      )
                    ],
                  )),
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    controller.handleLoginWithFacebook();
                  },
                  style: ElevatedButton.styleFrom(fixedSize: Size(70.w, 4.h)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        AssetsContants.ic_facebook,
                        width: 32,
                        height: 32,
                      ),
                      Text(
                        KeyLanguage.sign_in_with_facebook.tr,
                        style: TextStyle(fontSize: 12.sp, color: Colors.black),
                      )
                    ],
                  )),
            ),
            SizedBox(
              width: 100.w,
              height: 30.h,
              child: const RiveAnimation.asset(AssetsContants.kitty_splash),
            )
          ],
        ),
      ),
    );
  }
}
