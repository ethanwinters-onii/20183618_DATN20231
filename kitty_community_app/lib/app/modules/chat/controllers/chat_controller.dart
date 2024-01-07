import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/base/base_controller.dart';
import 'package:kitty_community_app/app/core/utils/helpers/get_account_local.dart';
import 'package:kitty_community_app/app/core/values/enums/status.dart';
import 'package:kitty_community_app/app/data/models/user_model/account_info.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_provider.dart';

class ChatController extends BaseController {
  final accountLocal = AccountLocalHelper.get();

  RxList<AccountInfo> friends = <AccountInfo>[].obs;

  @override
  Future<void> initialData() {
    // TODO: implement initialData
    getListFriends();
    return super.initialData();
  }

  void getListFriends() async {
    List<String> follower = accountLocal.follower ?? [];
    List<String> following = accountLocal.following ?? [];
    List<String> friendIds =
        follower.where((element) => following.contains(element)).toList();
    setStatus(Status.waiting);
    for (var id in friendIds) {
      final result = await FirebaseProvider.getUserById(id);
      if (result != null) {
        friends.add(result);
      }
    }
    setStatus(Status.success);
  }
}
