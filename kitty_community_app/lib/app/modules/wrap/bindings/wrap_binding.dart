import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitty_community_app/app/modules/chat/controllers/chat_controller.dart';
import 'package:kitty_community_app/app/modules/home/controllers/home_controller.dart';
import 'package:kitty_community_app/app/modules/notification/controllers/notification_controller.dart';
import 'package:kitty_community_app/app/modules/p_search/controllers/p_search_controller.dart';

import '../controllers/wrap_controller.dart';

class WrapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WrapController>(
      () => WrapController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<PSearchController>(
      () => PSearchController(),
    );
    Get.lazyPut<NotificationController>(
      () => NotificationController(),
    );
    Get.lazyPut<ChatController>(
      () => ChatController(),
    );
  }
}
