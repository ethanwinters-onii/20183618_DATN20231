import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitty_community_app/app/core/base/base_controller.dart';
import 'package:kitty_community_app/app/core/utils/extensions/logger_extension.dart';
import 'package:kitty_community_app/app/core/values/enums/status.dart';
import 'package:kitty_community_app/app/data/models/product_model/product_model.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_constants.dart';
import 'package:kitty_community_app/app/global_widgets/app_bottom_sheet.dart';
import 'package:kitty_community_app/app/global_widgets/custom_snack_bar.dart';
import 'package:kitty_community_app/app/modules/profile/widgets/add_product_bottomsheet.dart';
import 'package:kitty_community_app/app/modules/update_profile/widgets/image_picker_bottom_sheet.dart';
import 'package:kitty_community_app/app/routes/app_pages.dart';
import 'package:sizer/sizer.dart';

import '../../../core/utils/local_storage/hive_storage.dart';
import '../../../core/utils/local_storage/local_db_constants.dart';
import '../../../data/models/post_model/post_model.dart';
import '../../../data/models/user_model/account_info.dart';
import '../../../data/providers/firebase/firebase_provider.dart';

class ProfileController extends BaseController
    with GetSingleTickerProviderStateMixin {
  final AccountInfo accountLocal =
      HiveStorage.box.get(LocalDBConstants.ACCOUNT_LOCAL);

  AccountInfo? accountInfo;
  late final TabController tabController;
  RxInt tabIndex = 0.obs;

  RxList<PostModel> userPosts = <PostModel>[].obs;
  RxList<PostModel> userLikePosts = <PostModel>[].obs;

  final nameEditingController = TextEditingController();
  final priceEditingController = TextEditingController();

  RxString imagePath = "".obs;

  RxString selectUserID = "".obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Future<void> initialData() async {
    // TODO: implement initialData
    if (Get.arguments != null) {
      selectUserID.value = Get.arguments[0];
      accountInfo = Get.arguments[1];
      tabController =
        TabController(length: accountInfo?.role == "0" ? 2 : 3, vsync: this);
      tabController.addListener(_onChangeTab);
      if (accountInfo != null) {
        getUserPost();
        getUserLikePost();
      }
    } else {
      accountInfo = HiveStorage.box.get(LocalDBConstants.ACCOUNT_LOCAL);
      selectUserID.value = accountInfo?.userId ?? "";
      tabController =
        TabController(length: accountInfo?.role == "0" ? 2 : 3, vsync: this);
      tabController.addListener(_onChangeTab);
      getUserPost();
      getUserLikePost();
    }
    return super.initialData();
  }

  void _onChangeTab() {
    tabIndex.value = tabController.index;
  }

  void getUserPost() async {
    final result = await FirebaseProvider.getUserPosts(selectUserID.value);
    if (result != null) {
      userPosts.addAll(result.reversed);
      setStatus(Status.success);
    } else {
      setStatus(Status.success);
    }
  }

  void getUserLikePost() async {
    setStatus(Status.waiting);
    logger.w(accountInfo?.toJson());
    final result = await FirebaseProvider.getUserLikePost(
        accountInfo?.following ?? [], accountInfo?.userId ?? "");
    if (result != null) {
      userLikePosts.addAll(result.reversed);
      setStatus(Status.success);
    } else {
      setStatus(Status.success);
    }
  }

  void handleSignOut() async {
    await FirebaseConstants.auth.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  void showAddProductBottomSheet() {
    nameEditingController.text = "";
    priceEditingController.text = "";
    imagePath.value = "";
    Get.bottomSheet(
        AppBottomSheet(
          height: 70.h,
          child: Obx(
            () => Form(
              key: formKey,
              child: AddProductBottomSheet(
                nameEditingController: nameEditingController,
                priceEditingController: priceEditingController,
                imagePath: imagePath.value,
                onSelectImage: handleSelectPhoto,
                onRemoveImage: () {
                  imagePath.value = "";
                },
                onAddProduct: handleAddProduct,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        isDismissible: true,
        shape: const BeveledRectangleBorder(),
        isScrollControlled: true);
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
      imagePath.value = image.path;
    }
  }

  void handlePickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Get.back();
      logger.d(image.path);
      imagePath.value = image.path;
    }
  }

  void handleAddProduct() async {
    if (formKey.currentState!.validate()) {
      if (imagePath.value.isEmpty) {
        CustomSnackBar.showSnackBar(
            title: "Error",
            message: "Please select an image presenting your product");
      } else {
        Get.back();
        setStatus(Status.waiting);
        final ProductModel product = ProductModel(
            productId: DateTime.now().millisecondsSinceEpoch.toString(),
            userId: accountInfo?.userId,
            image: imagePath.value,
            price: priceEditingController.text,
            name: nameEditingController.text);

        await FirebaseProvider.createProduct(product);
        setStatus(Status.success);
      }
    }
  }
}
