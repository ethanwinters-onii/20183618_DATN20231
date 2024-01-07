import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/base/base_controller.dart';
import 'package:kitty_community_app/app/core/utils/helpers/get_account_local.dart';
import 'package:kitty_community_app/app/core/values/enums/status.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_provider.dart';

import '../../../data/models/user_model/account_info.dart';

class PSearchController extends BaseController {
  RxList<String> accountIds = <String>[].obs;
  RxList<AccountInfo> accounts = <AccountInfo>[].obs;

  RxList<AccountInfo> searchList = <AccountInfo>[].obs;
  RxBool isSearching = false.obs;

  final accountLocal = AccountLocalHelper.get();

  @override
  Future<void> initialData() {
    // TODO: implement initialData
    // getAllAccounts();
    setStatus(Status.success);
    return super.initialData();
  }

  void getAllAccounts() async {
    final result = await FirebaseProvider.getAllUser();
    if (result != null) {
      accounts.addAll(result);
      setStatus(Status.success);
    } else {
      setStatus(Status.success);
    }
  }

  void addAccount(AccountInfo account) {
    accounts.add(account);
    accountIds.add(account.userId!);
    searchList.add(account);
  }

  void handleOnSearching() {
    isSearching.value = !isSearching.value;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
