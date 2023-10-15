import 'package:get/get.dart';

import '../controllers/p_search_controller.dart';

class PSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PSearchController>(
      () => PSearchController(),
    );
  }
}
