import 'package:kitty_community_app/app/core/utils/local_storage/hive_storage.dart';
import 'package:kitty_community_app/app/core/utils/local_storage/local_db_constants.dart';
import 'package:kitty_community_app/app/data/models/user_model/account_info.dart';

class AccountLocalHelper {
  static Future<void> save(AccountInfo accountInfo) async {
    await HiveStorage.box.put(LocalDBConstants.ACCOUNT_LOCAL, accountInfo);
  }

  static AccountInfo get() {
    return HiveStorage.box.get(LocalDBConstants.ACCOUNT_LOCAL);
  }
}