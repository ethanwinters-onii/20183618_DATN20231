import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/base/main_layout.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';
import 'package:kitty_community_app/app/core/values/languages/key_language.dart';
import 'package:kitty_community_app/app/data/models/user_model/user_role.dart';
import 'package:kitty_community_app/app/global_widgets/app_button.dart';
import 'package:kitty_community_app/app/modules/update_profile/widgets/custom_radio_listtile.dart';
import 'package:kitty_community_app/app/modules/update_profile/widgets/profile_text_field.dart';
import 'package:sizer/sizer.dart';

import '../controllers/update_profile_controller.dart';
import '../widgets/account_image.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  const UpdateProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MainLayout<UpdateProfileController>(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    const SizedBox(),
                    Text(
                      KeyLanguage.update_profile.tr,
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      KeyLanguage.skip.tr,
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Center(
                  child: Obx(
                    () => AccountImage(
                      avatarPath: controller.avatarPath.value,
                      imageUrl: controller.accountInfo.avatar ?? "",
                      callback: () {
                        controller.handleSelectAvatar();
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                ProfileTextField(
                    label: KeyLanguage.full_name.tr,
                    txtEditingController: controller.fullNameEditingController,
                    prefixIcon: const Icon(
                      Icons.badge,
                      color: secondaryColor,
                    )),
                const SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () {
                    controller.showDatePickerDialog(context);
                  },
                  child: ProfileTextField(
                    label: KeyLanguage.date_of_birth.tr,
                    txtEditingController: controller.birthdayEditingController,
                    prefixIcon: const Icon(
                      Icons.event,
                      color: secondaryColor,
                    ),
                    readOnly: true,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                ProfileTextField(
                  label: KeyLanguage.about_me.tr,
                  txtEditingController: controller.descriptionEditingController,
                  prefixIcon: const Icon(
                    Icons.description,
                    color: secondaryColor,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  "You are:",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.black54, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () {
                    controller.onChangeRole(controller.userRoles[0]);
                  },
                  child: Obx(
                    () => CustomRadioListTile<UserRole>(
                        value: controller.userRoles[0],
                        groupValue: controller.selectedRole.value,
                        onChange: (UserRole? type) {
                          controller.onChangeRole(type!);
                        },
                        label: controller.userRoles[0].roleName),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.onChangeRole(controller.userRoles[1]);
                  },
                  child: Obx(
                    () => CustomRadioListTile<UserRole>(
                        value: controller.userRoles[1],
                        groupValue: controller.selectedRole.value,
                        onChange: (UserRole? type) {
                          controller.onChangeRole(type!);
                        },
                        label: controller.userRoles[1].roleName),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.onChangeRole(controller.userRoles[2]);
                  },
                  child: Obx(
                    () => CustomRadioListTile<UserRole>(
                        value: controller.userRoles[2],
                        groupValue: controller.selectedRole.value,
                        onChange: (UserRole? type) {
                          controller.onChangeRole(type!);
                        },
                        label: controller.userRoles[2].roleName),
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
                AppButton(
                    callback: () {
                      controller.handleUpdateProfile();
                    },
                    width: 100.w,
                    height: 52,
                    label: KeyLanguage.confirm.tr)
              ],
            ),
          ),
        ));
  }
}
