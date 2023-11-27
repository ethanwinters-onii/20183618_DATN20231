import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kitty_community_app/app/core/base/base_controller.dart';
import 'package:kitty_community_app/app/core/values/enums/status.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_constants.dart';
import 'package:kitty_community_app/app/routes/app_pages.dart';

import '../../../core/utils/local_storage/hive_storage.dart';
import '../../../core/utils/local_storage/local_db_constants.dart';
import '../../../data/models/post_model/post_model.dart';
import '../../../data/models/user_model/account_info.dart';
import '../../../data/providers/firebase/firebase_provider.dart';

class ProfileController extends BaseController with GetSingleTickerProviderStateMixin {
  final AccountInfo accountInfo = HiveStorage.box.get(LocalDBConstants.ACCOUNT_LOCAL);
  late final TabController tabController;
  RxInt tabIndex = 0.obs;

  RxList<PostModel> userPosts = <PostModel>[].obs;

  @override
  Future<void> initialData() {
    // TODO: implement initialData
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(_onChangeTab);
    getUserPost();
    return super.initialData();
  }

  void _onChangeTab() {
    tabIndex.value = tabController.index;
  }

  void getUserPost() async {
    final result = await FirebaseProvider.getUserPosts();
    if (result != null) {
      userPosts.addAll(result.reversed);
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
}
