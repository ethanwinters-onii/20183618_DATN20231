import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitty_community_app/app/core/base/base_controller.dart';
import 'package:kitty_community_app/app/core/utils/extensions/logger_extension.dart';
import 'package:kitty_community_app/app/core/utils/local_storage/hive_storage.dart';
import 'package:kitty_community_app/app/core/utils/local_storage/local_db_constants.dart';
import 'package:kitty_community_app/app/core/values/enums/status.dart';
import 'package:kitty_community_app/app/data/models/comment_model/comment_model.dart';
import 'package:kitty_community_app/app/data/models/post_model/post_model.dart';
import 'package:kitty_community_app/app/data/models/user_model/account_info.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_provider.dart';
import 'package:kitty_community_app/app/global_widgets/app_bottom_sheet.dart';
import 'package:kitty_community_app/app/modules/update_profile/widgets/image_picker_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

class PostDetailController extends BaseController {
  final AccountInfo accountInfo =
      HiveStorage.box.get(LocalDBConstants.ACCOUNT_LOCAL);
  PostModel selectedPost = Get.arguments[1];

  final TextEditingController txtController = TextEditingController();

  RxString photoPath = "".obs;

  RxInt numOfComment = 0.obs;  

  @override
  Future<void> initialData() {
    // TODO: implement initialData
    setStatus(Status.success);
    return super.initialData();
  }

  void updateLike() async {
    await FirebaseProvider.updateLikeAPost(
        selectedPost, accountInfo.userId ?? "-");
  }

  void handleSelectPhoto() async {
    Get.bottomSheet(
      AppBottomSheet(
        height: 20.h,
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

  void handleSendComment() async {
    if (txtController.text.trim().isNotEmpty || photoPath.value.isNotEmpty) {
      setStatus(Status.waiting);
      final comment = CommentModel(
          commentId: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: accountInfo.userId,
          postId: selectedPost.postId,
          name: accountInfo.name,
          comment: txtController.text.trim(),
          avatar: accountInfo.avatar,
          hearts: [],
          commentImage: photoPath.value);
      txtController.text = "";
      photoPath.value = "";
      await FirebaseProvider.writeComment(comment, numOfComment.value, selectedPost);
      setStatus(Status.success);
    }
  }

  void likeComment(CommentModel comment) async {
    print("aaa");
    await FirebaseProvider.updateLikeAComment(
        comment, accountInfo.userId ?? "");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
