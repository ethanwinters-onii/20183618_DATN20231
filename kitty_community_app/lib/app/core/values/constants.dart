// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:rive/rive.dart';

class AppConstant {
  static const String APP_NAME = 'Pet Community';

  static const int TIME_OUT_SCAN_QRCODE = 120;
  // static const int DELAY_TRANSACTION_INQUIRY = 5;

  static const String OPA_DOCTYPE_ID = "1000120";
  static const String DEBT_DOCTYPE_ID = "1000032";
}

class LanguageCodeConstant {
  static const String VI = 'vi';
  static const String EN = 'en';
}

class LanguageCountryConstant {
  static const String VI = 'VN';
  static const String EN = 'EN';
}

class AssetsContants {
  // rive
  static const String kitty_splash = "assets/rive/kitty_splash.riv";
  static const String kitty_login = "assets/rive/kitty_login.riv";
  static const String check = "assets/rive/check.riv";
  static const String confetti = "assets/rive/confetti.riv";
  static const String icons = "assets/rive/icons.riv";

  // img
  static const String splash_img = "assets/images/splash_img.jpg";
  static const String img_bg = "assets/images/img_bg.jpeg";
  static const String img_home_bottom_sheet =
      "assets/images/img_home_bottom_sheet.png";

  // icon
  static const String ic_google = "assets/icons/google.png";
  static const String ic_facebook = "assets/icons/facebook.png";
}

class RiveAsset {
  final String artboard, stateMachineName, title, src;
  late SMIBool? input;

  RiveAsset(
      {required this.src,
      required this.artboard,
      required this.stateMachineName,
      required this.title});

  set setInput(SMIBool status) {
    input = status;
  }
}

List<RiveAsset> bottomNavs = [
  RiveAsset(
      src: AssetsContants.icons,
      artboard: "HOME",
      stateMachineName: "HOME_interactivity",
      title: "Home"),
  RiveAsset(
      src: AssetsContants.icons,
      artboard: "SEARCH",
      stateMachineName: "SEARCH_Interactivity",
      title: "Search"),
  RiveAsset(
      src: AssetsContants.icons,
      artboard: "CHAT",
      stateMachineName: "CHAT_Interactivity",
      title: "Chat"),
  RiveAsset(
      src: AssetsContants.icons,
      artboard: "BELL",
      stateMachineName: "BELL_Interactivity",
      title: "Bell"),
];

List<RiveAsset> sideMenus = [
  RiveAsset(
      src: AssetsContants.icons,
      artboard: "USER",
      stateMachineName: "USER_interactivity",
      title: "Profile"),
  RiveAsset(
      src: AssetsContants.icons,
      artboard: "LIKE/STAR",
      stateMachineName: "STAR_Interactivity",
      title: "Favorite"),
  RiveAsset(
      src: AssetsContants.icons,
      artboard: "SETTINGS",
      stateMachineName: "SETTINGS_Interactivity",
      title: "Log out"),
];
