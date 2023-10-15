import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sizer/sizer.dart';

import 'app/core/utils/local_storage/hive_storage.dart';
import 'app/core/values/constants.dart';
import 'app/routes/app_pages.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'app/core/network/network_connection_checker.dart';
import 'app/core/network/restful_module/restful_module.dart';
import 'app/core/network/restful_module/restful_module_impl.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/utils/extensions/logger_extension.dart';
import 'app/core/values/languages/localization_service.dart';
import 'app/routes/app_pages.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  await requestNotificationPermissions();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Configure FCM
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    logger.w("ON MESSAGE");
    showNotification(message);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    logger.w("ON MESSAGE OPENED APP");
    // Handle notification click event
  });

  await HiveStorage().init();
  await NetworkChecker.init();
  runApp(
    Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: AppConstant.APP_NAME,
          theme: DAppTheme.lightTheme,
          darkTheme: DAppTheme.darkTheme,
          themeMode: ThemeMode.system,
          defaultTransition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 300),
          fallbackLocale: LocalizationService.fallbackLocale,
          translations: LocalizationService(),
          locale: LocalizationService.locale,
          supportedLocales: const <Locale>[
            Locale(LanguageCodeConstant.VI, LanguageCountryConstant.VI),
            Locale(LanguageCodeConstant.EN, LanguageCountryConstant.EN),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          initialRoute: AppPages.INITIAL,
          initialBinding: InitialBindings(),
          getPages: AppPages.routes,
        );
      }
    ),
  );
}

class InitialBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    Get.put<RestfulModule>(RestfulModuleImpl());
    Get.put<GetConnect>(GetConnect());
  }
}

Future<void> initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> requestNotificationPermissions() async {
  // if (Platform.isIOS) {
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  logger.d('User granted permission: ${settings.authorizationStatus}');
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  showNotification(message);
}

Future<void> showNotification(RemoteMessage message) async {
  // Create a notification
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'kitty_id',
    'kitty_community',
    channelDescription: 'kitty_description',
    priority: Priority.high,
    importance: Importance.high,
  );
  const DarwinNotificationDetails iOSPlatformChannelSpecifics =
      DarwinNotificationDetails(threadIdentifier: 'thread_kitty');
  const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails, iOS: iOSPlatformChannelSpecifics);
  await _flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title,
    message.notification?.body,
    platformDetails,
  );
}
