import 'package:get/get.dart';
import 'package:kitty_community_app/app/modules/pet_discovery/controllers/pet_detail_controller.dart';
import 'package:kitty_community_app/app/modules/pet_discovery/views/pet_detail_view.dart';

import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/p_search/bindings/p_search_binding.dart';
import '../modules/p_search/views/p_search_view.dart';
import '../modules/pet_discovery/bindings/pet_discovery_binding.dart';
import '../modules/pet_discovery/views/pet_discovery_view.dart';
import '../modules/splashscreen/bindings/splashscreen_binding.dart';
import '../modules/splashscreen/views/splashscreen_view.dart';
import '../modules/wrap/bindings/wrap_binding.dart';
import '../modules/wrap/views/wrap_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASHSCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SPLASHSCREEN,
      page: () => const SplashscreenView(),
      binding: SplashscreenBinding(),
    ),
    GetPage(
      name: _Paths.WRAP,
      page: () => const WrapView(),
      binding: WrapBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.P_SEARCH,
      page: () => const PSearchView(),
      binding: PSearchBinding(),
    ),
    GetPage(
      name: _Paths.PET_DISCOVERY,
      page: () => const PetDiscoveryView(),
      binding: PetDiscoveryBinding(),
    ),
    GetPage(
      name: _Paths.PET_DETAIL,
      page: () => const PetDetailView(),
      binding: BindingsBuilder(() =>
          Get.lazyPut<PetDetailController>(() => PetDetailController())),
    ),
  ];
}
