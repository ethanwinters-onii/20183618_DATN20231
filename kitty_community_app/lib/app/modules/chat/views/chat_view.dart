import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/base/main_layout.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';
import 'package:kitty_community_app/app/routes/app_pages.dart';
import 'package:rive/rive.dart';
import 'package:sizer/sizer.dart';

import '../../../core/values/constants.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MainLayout<ChatController>(
      appBar: AppBar(
        title: const Text('Message'),
        centerTitle: true,
      ),
      child: Obx(() {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Container(
                          width: 56,
                          height: 56,
                          color: secondaryColor,
                          child:
                              RiveAnimation.asset(AssetsContants.kitty_login),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: const BoxDecoration(
                              color: Colors.lightGreen, shape: BoxShape.circle),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 70.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My Assistant",
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "How can I help you today?",
                          style: TextStyle(
                              fontSize: 10.sp, fontWeight: FontWeight.w300),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ...controller.friends.map((user) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.MESSAGE, arguments: user);
                    },
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: CachedNetworkImage(
                                  imageUrl: user.avatar ?? "",
                                  errorWidget: (context, _, __) => ClipRRect(
                                        borderRadius: BorderRadius.circular(32),
                                        child: Container(
                                          width: 56,
                                          height: 56,
                                          color: Colors.grey[300],
                                          child: const Center(
                                            child: Icon(Icons.person),
                                          ),
                                        ),
                                      ),
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: const BoxDecoration(
                                    color: Colors.lightGreen,
                                    shape: BoxShape.circle),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 40.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name ?? "",
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                user.description ?? "Have a good day \u2764",
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w300),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Spacer(),
                        Text("1:11 AM"),
                        const SizedBox(width: 12),
                      ],
                    ),
                  ),
                ))
          ],
        );
      }),
    );
  }
}
