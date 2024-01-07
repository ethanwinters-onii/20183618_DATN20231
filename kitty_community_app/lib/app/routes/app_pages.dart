import 'package:get/get.dart';
import 'package:kitty_community_app/app/modules/event/controllers/create_event_controller.dart';
import 'package:kitty_community_app/app/modules/event/controllers/event_detail_controller.dart';
import 'package:kitty_community_app/app/modules/event/views/create_event_view.dart';
import 'package:kitty_community_app/app/modules/event/views/event_detail_view.dart';

import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/controllers/message_controller.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/chat/views/message_view.dart';
import '../modules/event/bindings/event_binding.dart';
import '../modules/event/views/event_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/controllers/create_post_controller.dart';
import '../modules/home/controllers/post_detail_controller.dart';
import '../modules/home/views/create_post_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/views/post_detail_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/p_search/bindings/p_search_binding.dart';
import '../modules/p_search/views/p_search_view.dart';
import '../modules/pet_discovery/bindings/pet_discovery_binding.dart';
import '../modules/pet_discovery/controllers/pet_detail_controller.dart';
import '../modules/pet_discovery/views/pet_detail_view.dart';
import '../modules/pet_discovery/views/pet_discovery_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/splashscreen/bindings/splashscreen_binding.dart';
import '../modules/splashscreen/views/splashscreen_view.dart';
import '../modules/update_profile/bindings/update_profile_binding.dart';
import '../modules/update_profile/views/update_profile_view.dart';
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
      name: _Paths.CREATE_POST,
      page: () => const CreatePostView(),
      binding: BindingsBuilder(() =>
          Get.lazyPut<CreatePostController>(() => CreatePostController())),
    ),
    GetPage(
      name: _Paths.POST_DETAIL,
      page: () => const PostDetailView(),
      binding: BindingsBuilder(() =>
          Get.lazyPut<PostDetailController>(() => PostDetailController())),
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
      name: _Paths.MESSAGE,
      page: () => const MessageView(),
      binding: BindingsBuilder(
          () => Get.lazyPut<MessageController>(() => MessageController())),
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
      binding: BindingsBuilder(
          () => Get.lazyPut<PetDetailController>(() => PetDetailController())),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_PROFILE,
      page: () => const UpdateProfileView(),
      binding: UpdateProfileBinding(),
    ),
    GetPage(
      name: _Paths.EVENT,
      page: () => const EventView(),
      binding: EventBinding(),
    ),
    GetPage(
      name: _Paths.EVENT_DETAIL,
      page: () => const EventDetailView(),
      binding: BindingsBuilder(() =>
          Get.lazyPut<EventDetailController>(() => EventDetailController())),
    ),
    GetPage(
      name: _Paths.CREATE_EVENT,
      page: () => const CreateEventView(),
      binding: BindingsBuilder(() =>
          Get.lazyPut<CreateEventController>(() => CreateEventController())),
    ),
  ];
}
