import 'package:get/get.dart';

import '../controllers/pet_discovery_controller.dart';

class PetDiscoveryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PetDiscoveryController>(
      () => PetDiscoveryController(),
    );
  }
}
