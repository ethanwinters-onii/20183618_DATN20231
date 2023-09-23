import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';

class CustomSnackBar {
  static void showSnackBar(
      {required String title,
      required String message,
      Color? color,
      Widget? icon}) {
    Get.snackbar(
        title, 
        message,
        colorText: Colors.white,
        icon: icon ?? const Icon(
          Icons.error,
          color: Colors.white,
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: color ?? primaryColor,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.only(top: 18, left: 12, right: 12));
  }
}
