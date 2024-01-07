import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitty_community_app/app/core/base/base_controller.dart';
import 'package:kitty_community_app/app/core/utils/extensions/datetime_extension.dart';
import 'package:kitty_community_app/app/core/values/enums/status.dart';
import 'package:kitty_community_app/app/data/models/post_model/post_model.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_provider.dart';
import 'package:sizer/sizer.dart';

import '../../../core/utils/extensions/logger_extension.dart';
import '../../../core/utils/local_storage/hive_storage.dart';
import '../../../core/utils/local_storage/local_db_constants.dart';
import '../../../data/models/user_model/account_info.dart';
import '../../../global_widgets/app_bottom_sheet.dart';
import '../../update_profile/widgets/image_picker_bottom_sheet.dart';

class CreatePostController extends BaseController {
  final AccountInfo accountInfo = HiveStorage.box.get(LocalDBConstants.ACCOUNT_LOCAL);

  final txtEditingController = TextEditingController();

  Rx<String> photoPath = "".obs;
  Rx<String> videoPath = "".obs;

  @override
  Future<void> initialData() {
    // TODO: implement initialData
    setStatus(Status.success);
    return super.initialData();
  }

  void handleSelectPhoto() async {
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
      photoPath.value = image.path;
    }
  }

  void handlePickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Get.back();
      logger.d(image.path);
      photoPath.value = image.path;
    }
  }

  void handleCreateNewPost() async {
    if (photoPath.value.trim().isEmpty && txtEditingController.text.trim().isEmpty) {
      return;
    } else {
      setStatus(Status.waiting);
      final postModel = PostModel(
        postId: "${accountInfo.userId}${DateTime.now().millisecondsSinceEpoch}",
        userId: accountInfo.userId,
        description: txtEditingController.text.trim(),
        image: photoPath.value,
        hearts: [],
        createdAt: DateTime.now().toAPIFormat(),
        userAvatar: accountInfo.avatar,
        createdBy: accountInfo.name,
        noComment: 0
      );
      await FirebaseProvider.createNewPost(postModel);
      setStatus(Status.success);
      Get.back();
    }
  }
}
