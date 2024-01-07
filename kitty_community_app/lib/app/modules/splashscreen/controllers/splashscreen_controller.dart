import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/utils/extensions/logger_extension.dart';
import 'package:kitty_community_app/app/core/utils/local_storage/hive_storage.dart';
import 'package:kitty_community_app/app/core/utils/local_storage/local_db_constants.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_constants.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_provider.dart';
import 'package:kitty_community_app/app/routes/app_pages.dart';

class SplashscreenController extends GetxController {
  //TODO: Implement SplashscreenController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onGetStarted() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final accountInfo = await FirebaseProvider.getUserById(user.uid);
      if (accountInfo != null) {
        logger.d(accountInfo.toJson());
        HiveStorage.box.put(LocalDBConstants.ACCOUNT_LOCAL, accountInfo);
        await FirebaseProvider.updateActiveStatus(true);
        if (accountInfo.onFirstLogin == true) {
          Get.offAllNamed(Routes.UPDATE_PROFILE);
        } else {
          Get.offAllNamed(Routes.WRAP);
        }
      } else {
        Get.toNamed(Routes.LOGIN);
      }
    } else {
      Get.toNamed(Routes.LOGIN);
    }
  }

  void increment() => count.value++;
}
