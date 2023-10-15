import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/base/base_controller.dart';
import 'package:kitty_community_app/app/core/utils/local_storage/hive_storage.dart';
import 'package:kitty_community_app/app/core/utils/local_storage/local_db_constants.dart';
import 'package:kitty_community_app/app/core/values/enums/status.dart';
import 'package:kitty_community_app/app/data/models/pet_model/pet_models.dart';

class PetDetailController extends BaseController {
  final PetModel pet = Get.arguments;
  // RxInt currentIndex = 0.obs;
  Rx<String> currentAvatar = "".obs;
  final lang = HiveStorage.box.get(LocalDBConstants.LANGUAGE);

  @override
  Future<void> initialData() {
    // TODO: implement initialData
    currentAvatar.value = pet.images[0];
    setStatus(Status.success);
    return super.initialData();
  }

  void onChangeCurrentAvatar(String newAvatar) {
    currentAvatar.value = newAvatar;
  }
}
