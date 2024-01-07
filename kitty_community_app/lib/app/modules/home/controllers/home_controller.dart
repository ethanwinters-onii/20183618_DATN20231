import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/base/base_controller.dart';
import 'package:kitty_community_app/app/core/utils/local_storage/hive_storage.dart';
import 'package:kitty_community_app/app/core/values/enums/status.dart';
import 'package:kitty_community_app/app/data/models/post_model/post_model.dart';
import 'package:kitty_community_app/app/data/models/user_model/account_info.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_provider.dart';

import '../../../core/utils/local_storage/local_db_constants.dart';

class HomeController extends BaseController {
  final AccountInfo accountInfo =
      HiveStorage.box.get(LocalDBConstants.ACCOUNT_LOCAL);

  RxList<PostModel> posts = <PostModel>[].obs;

  @override
  Future<void> initialData() {
    // TODO: implement initialData
    getAllPost();
    return super.initialData();
  }

  void getAllPost() async {
    final result =
        await FirebaseProvider.getAllFriendsPost(accountInfo.following ?? []);
    if (result != null) {
      posts.addAll(result);
      setStatus(Status.success);
    } else {
      setStatus(Status.success);
    }
  }

  void handleLikeAPost(PostModel post) async {
    await FirebaseProvider.updateLikeAPost(post, accountInfo.userId ?? "-");
  }
}
