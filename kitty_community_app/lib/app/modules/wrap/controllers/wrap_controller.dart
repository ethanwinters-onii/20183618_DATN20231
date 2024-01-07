import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitty_community_app/app/core/base/base_controller.dart';
import 'package:kitty_community_app/app/core/values/constants.dart';
import 'package:kitty_community_app/app/core/values/enums/status.dart';
import 'package:kitty_community_app/app/data/providers/aws/aws_provider.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_constants.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_provider.dart';
import 'package:kitty_community_app/app/modules/chat/controllers/chat_controller.dart';

import '../../../core/utils/extensions/logger_extension.dart';

class WrapController extends BaseController
    with GetSingleTickerProviderStateMixin {
  RxInt currentTab = 0.obs;
  RxBool isFabExpand = false.obs;

  late AnimationController animationController;
  late Animation<double> expandAnimation;

  @override
  Future<void> initialData() {
    // TODO: implement initialData
    setStatus(Status.success);
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

    SystemChannels.lifecycle.setMessageHandler((message) {
      logger.w(message);
      /* 
        - resumed: App đang chạy trên Foreground và nhận các sự kiện tương tác.
         Đây là một trạng thái bình thường của Foreground apps
        - inactive: App đang chạy ở Foreground nhưng không nhận bất kì sự kiện tương tác nào.
         Nó có thể xảy ra trong trường hợp có cuộc gọi hoặc có tin nhắn tới
        - paused: App chạy dưới background nhưng không thực thi code. 
        Hệ thống sẽ tự động chuyển trạng thái của app sang trạng thái và 
        không báo cho chúng ta biết trước
        - detached: App chạy dưới background và vẫn thực thi code
      */

      if (message.toString().contains("paused")) {
        FirebaseProvider.updateActiveStatus(false);
      }

      if (message.toString().contains("resumed")) {
        FirebaseProvider.updateActiveStatus(true);
      }

      return Future.value(message);
    });
    return super.initialData();
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
      if (index == 2) {
        if (Get.isRegistered<ChatController>()) {
          // Get.find<TransactionHistoryController>().fetchData();
          Get.delete<ChatController>();
          Get.lazyPut<ChatController>(() => ChatController());
        }
      }
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

  void handlePickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      logger.d(image.path);
      setStatus(Status.waiting);
      Stopwatch stopwatch = new Stopwatch()..start();
      final res = await AWSProvider.predictImage(image.path);
      res.fold((l) {
        setStatus(Status.success);
        showErrorDialog(l.message);
      }, (r) {
        setStatus(Status.success);
        print(r);
      });
      print('doSomething() executed in ${stopwatch.elapsed}');
    }
  }

  void handleTakePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      logger.d(image.path);
      setStatus(Status.waiting);
      final res = await AWSProvider.predictImage(image.path);
      res.fold((l) {
        setStatus(Status.success);
        showErrorDialog(l.message);
      }, (r) {
        setStatus(Status.success);
        print(r);
      });
    }
  }
}
