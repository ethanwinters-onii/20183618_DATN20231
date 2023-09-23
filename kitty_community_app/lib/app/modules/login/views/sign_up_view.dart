import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../core/theme/color_theme.dart';
import '../../../core/values/languages/key_language.dart';
import '../controllers/login_controller.dart';

class SignUpView extends GetView<LoginController> {
  const SignUpView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: 90.w,
          height: 60.h,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6)),
                        child: const Icon(
                          Icons.clear,
                          color: Colors.black,
                        )),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    KeyLanguage.create_new_account.tr,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${KeyLanguage.already_have_account.tr} ",
                          ),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Text(
                              KeyLanguage.sign_in.tr,
                              style: const TextStyle(color: secondaryColor),
                            ),
                          )
                        ],
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                            labelText: KeyLanguage.full_name.tr),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.black,
                            ),
                            labelText: "Email"),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(
                              Icons.key,
                              color: Colors.black,
                            ),
                            labelText: KeyLanguage.password.tr),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(
                              Icons.key,
                              color: Colors.black,
                            ),
                            labelText: KeyLanguage.confirm_password.tr),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    width: 90.w,
                    height: 6.h,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                          colors: [Color(0xFFFE87AB), Color(0xFFDA4873)],
                        ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16)
                      )
                    ),
                    child: Center(
                      child: Text(
                        KeyLanguage.sign_up.tr,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14.sp),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
