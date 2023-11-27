import 'dart:math';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';
import 'package:kitty_community_app/app/core/utils/extensions/logger_extension.dart';
import 'package:kitty_community_app/app/core/utils/helpers/rive_utils.dart';
import 'package:kitty_community_app/app/core/values/constants.dart';
import 'package:kitty_community_app/app/modules/chat/views/chat_view.dart';
import 'package:kitty_community_app/app/modules/home/views/home_view.dart';
import 'package:kitty_community_app/app/modules/notification/views/notification_view.dart';
import 'package:kitty_community_app/app/modules/p_search/views/p_search_view.dart';
import 'package:kitty_community_app/app/modules/wrap/widgets/side_menu.dart';
import 'package:kitty_community_app/app/modules/wrap/widgets/animated_bar.dart';
import 'package:kitty_community_app/app/modules/wrap/widgets/fab_expandable.dart';
import 'package:kitty_community_app/app/modules/wrap/widgets/rps_custom_painter.dart';
import 'package:kitty_community_app/app/routes/app_pages.dart';
import 'package:rive/rive.dart';
import 'package:sizer/sizer.dart';

import '../controllers/wrap_controller.dart';

class WrapView extends GetView<WrapController> {
  const WrapView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(() => _getPage(controller.currentTab.value)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(100.w,
                      25.w.toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                  painter: RPSCustomPainter(),
                ),
                SizedBox(
                  width: 100.w,
                  height: 25.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ...List.generate(bottomNavs.length, (index) {
                        double paddingLeft = 0;
                        double paddingRight = 0;
                        if (index == 1) {
                          paddingRight = 16;
                        } else if (index == 2) {
                          paddingLeft = 16;
                        }
                        return GestureDetector(
                          onTap: () {
                            controller.onChangeTab(index);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: paddingLeft, right: paddingRight),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Obx(() => AnimatedBar(
                                    isActive:
                                        controller.currentTab.value == index)),
                                SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: ColorFiltered(
                                    colorFilter: const ColorFilter.mode(
                                        primaryColor, BlendMode.modulate),
                                    child: RiveAnimation.asset(
                                      bottomNavs[index].src,
                                      artboard: bottomNavs[index].artboard,
                                      onInit: (artboard) {
                                        StateMachineController riveController =
                                            RiveUtils.getRiveController(
                                                artboard,
                                                stateMachineName:
                                                    bottomNavs[index]
                                                        .stateMachineName);
                                        bottomNavs[index].input = riveController
                                            .findSMI("active") as SMIBool;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FabExpandable(
              distance: 90.0,
              children: [
                ActionButton(
                  onPressed: () {
                    
                  },
                  icon: const Icon(Icons.photo_camera),
                ),
                ActionButton(
                  onPressed: () {
                    Get.toNamed(Routes.PET_DISCOVERY);
                  },
                  icon: const Icon(Icons.pets),
                ),
                ActionButton(
                  onPressed: () {
                    print("abcffasf");
                  },
                  icon: const Icon(Icons.image_search),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _getPage(int index) {
  switch (index) {
    case 0:
      return const HomeView();
    case 1:
      return const PSearchView();
    case 2:
      return const ChatView();
    case 3:
      return const NotificationView();
  }
  return Container();
}
