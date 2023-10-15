import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/base/base_controller.dart';
import 'package:kitty_community_app/app/core/values/enums/status.dart';

class HomeController extends BaseController {
  final User user = Get.arguments[0];

  @override
  Future<void> initialData() {
    // TODO: implement initialData
    setStatus(Status.success);
    return super.initialData();
  }
}
