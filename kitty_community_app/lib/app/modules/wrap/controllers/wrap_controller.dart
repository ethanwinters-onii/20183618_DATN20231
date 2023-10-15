import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/values/constants.dart';

class WrapController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxInt currentTab = 0.obs;
  RxBool isFabExpand = false.obs;

  late AnimationController animationController;
  late Animation<double> expandAnimation;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      value: 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: animationController,
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void onChangeTab(int index) {
    if (currentTab.value != index) {
      currentTab.value = index;
    }
    bottomNavs[index].input!.change(true);
    Future.delayed(const Duration(milliseconds: 800), () {
      bottomNavs[index].input!.change(false);
    });
  }

  void toggleFab() {
    print('abc');
    isFabExpand.value = !isFabExpand.value;
    if (isFabExpand.value) {
      print("for");
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }
}
