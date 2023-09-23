import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/base/base_controller.dart';

class LoginController extends BaseController {
  final TextEditingController emailEdittingController = TextEditingController();
  final TextEditingController passwordEdittingController =
      TextEditingController();

  RxBool isAvailableEmail = false.obs;
  RxBool showPassword = false.obs;

  @override
  Future<void> initialData() {
    // TODO: implement initialData
    return super.initialData();
  }

  @override
  Future<void> fetchData() {
    // TODO: implement fetchData
    return super.fetchData();
  }

  void onChangeEmail() {
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailEdittingController.text);
    isAvailableEmail.value = emailValid;
  }

  void changeShowPassword() {
    showPassword.value = !showPassword.value;
  }
}
