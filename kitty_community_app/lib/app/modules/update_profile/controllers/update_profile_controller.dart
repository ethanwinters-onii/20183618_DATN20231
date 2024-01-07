import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitty_community_app/app/core/base/base_controller.dart';
import 'package:kitty_community_app/app/core/utils/extensions/datetime_extension.dart';
import 'package:kitty_community_app/app/core/utils/extensions/logger_extension.dart';
import 'package:kitty_community_app/app/core/utils/extensions/string_extension.dart';
import 'package:kitty_community_app/app/core/utils/local_storage/hive_storage.dart';
import 'package:kitty_community_app/app/core/utils/local_storage/local_db_constants.dart';
import 'package:kitty_community_app/app/core/values/enums/status.dart';
import 'package:kitty_community_app/app/data/models/user_model/account_info.dart';
import 'package:kitty_community_app/app/data/models/user_model/user_role.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_provider.dart';
import 'package:kitty_community_app/app/global_widgets/app_bottom_sheet.dart';
import 'package:kitty_community_app/app/modules/update_profile/widgets/image_picker_bottom_sheet.dart';
import 'package:kitty_community_app/app/routes/app_pages.dart';
import 'package:kitty_community_app/main.dart';
import 'package:sizer/sizer.dart';

class UpdateProfileController extends BaseController {
  final AccountInfo accountInfo =
      HiveStorage.box.get(LocalDBConstants.ACCOUNT_LOCAL);

  final fullNameEditingController = TextEditingController();
  final birthdayEditingController = TextEditingController();
  final descriptionEditingController = TextEditingController();
  Rx<DateTime> selectedDate = DateTime.now().obs;

  Rx<String> avatarPath = "".obs;

  final userRoles = roles;
  Rx<UserRole> selectedRole = roles[0].obs;

  @override
  Future<void> initialData() {
    // TODO: implement initialData
    fullNameEditingController.text = accountInfo.name ?? "";
    birthdayEditingController.text =
        selectedDate.value.toCustomFormat("dd-MM-yyyy");
    if (accountInfo.dateOfBirth != null &&
        accountInfo.dateOfBirth!.isNotEmpty) {
      birthdayEditingController.text = accountInfo.dateOfBirth ?? "";
      selectedDate.value = accountInfo.dateOfBirth!.toDateTime("dd-MM-yyyy");
    }
    descriptionEditingController.text = accountInfo.description ?? "";
    setStatus(Status.success);
    return super.initialData();
  }

  void onChangeRole(UserRole type) {
    selectedRole.value = type;
  }

  void showDatePickerDialog(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      selectedDate.value = date;
      birthdayEditingController.text = date.toCustomFormat("dd-MM-yyyy");
    }
  }

  void handleSelectAvatar() async {
    Get.bottomSheet(
      AppBottomSheet(
        height: 25.h,
        child: ImagePickerBottomSheet(
          onTakePhoto: handleTakePhoto,
          onPickGallery: handlePickImage,
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      shape: const BeveledRectangleBorder(),
    );
  }

  void handleTakePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      Get.back();
      logger.d(image.path);
      avatarPath.value = image.path;
    }
  }

  void handlePickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Get.back();
      logger.d(image.path);
      avatarPath.value = image.path;
    }
  }

  void handleUpdateProfile() async {
    if (avatarPath.value != "") {
      setStatus(Status.waiting);
      await FirebaseProvider.uploadProfilePicture(File(avatarPath.value));
    }
    await FirebaseProvider.updateUserInfo(
        newName: fullNameEditingController.text.trim(),
        newAbout: descriptionEditingController.text.trim(),
        birthday: birthdayEditingController.text,
        role: selectedRole.value.roleId
    );
    setStatus(Status.success);
    Get.toNamed(Routes.WRAP);
  }
}
