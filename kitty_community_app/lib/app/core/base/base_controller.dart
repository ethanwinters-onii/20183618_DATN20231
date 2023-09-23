import 'package:kitty_community_app/app/core/values/enums/status.dart';
import 'package:get/get.dart';

class BaseController extends GetxController {
  Rx<Status> status = Status.loading.obs;

  @override
  void onInit() {
    super.onInit();
    initialData();
  }

  Future<void> initialData() async {
    await fetchData();
  }

  Future<void> fetchData() async {}

  void setStatus(Status s) {
    status.value = s;
  }

  Status getStatus() => status.value;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
  
}
