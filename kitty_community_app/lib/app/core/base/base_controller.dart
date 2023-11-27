import 'package:flutter/material.dart';
import 'package:kitty_community_app/app/core/values/enums/status.dart';
import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/values/languages/key_language.dart';
import 'package:kitty_community_app/app/global_widgets/custom_dialog.dart';
import 'package:sizer/sizer.dart';

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

  void showErrorDialog(String message) async {
    return Get.dialog(CustomDialog(
      title: KeyLanguage.error.tr.toUpperCase(),
      content: Text(
        message,
        style: TextStyle(fontSize: 14.sp, color: Colors.black),
        textAlign: TextAlign.center,
      ),
    ));
  }

  void showSuccessDialog(String message) async {
    return Get.dialog(CustomDialog(
      title: KeyLanguage.notice.tr.toUpperCase(),
      color: Colors.lightBlueAccent,
      content: Text(
        message,
        style: TextStyle(fontSize: 14.sp, color: Colors.black),
        textAlign: TextAlign.center,
      ),
    ));
  }
  
}
