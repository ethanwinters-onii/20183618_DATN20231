import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/base/main_layout.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';
import 'package:kitty_community_app/app/modules/home/controllers/create_post_controller.dart';
import 'package:rive/rive.dart';
import 'package:sizer/sizer.dart';

import '../../../core/values/constants.dart';

class CreatePostView extends GetView<CreatePostController> {
  const CreatePostView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MainLayout<CreatePostController>(
      resizeToAvoidBottomInset: false,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 GestureDetector(
                   onTap: () {
                     Get.back();
                   }, child: const Icon(Icons.clear, size: 26,)
                 ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text("Create New Post", style: TextStyle(fontSize: 14.sp),),
                  ),
                  InkWell(
                      onTap: () {
                        controller.handleCreateNewPost();
                      },
                      child: Text("Post", style: TextStyle(fontSize: 14.sp, color: primaryColor, fontWeight: FontWeight.w500),)
                  )
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: ClipOval(
                      child: CachedNetworkImage(
                          imageUrl: controller.accountInfo.avatar ?? "",
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.person),
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 12,),
                  Text(
                    "${controller.accountInfo.name}",
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Obx(
                () => TextFormField(
                  autofocus: true,
                  controller: controller.txtEditingController,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                      ),
                      hintText: "Have something to share with the community?"
                  ),
                  maxLines: controller.photoPath.value == "" ? 10 : 1,
                ),
              ),
            ),
            Obx(() {
              if (controller.photoPath.value == "") {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: const Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.handleSelectPhoto();
                            },
                            child: Row(
                              children: [
                                Icon(Icons.photo, color: Colors.blue,),
                                const SizedBox(width: 12,),
                                Text("Photo", style: TextStyle(fontSize: 14.sp),)
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.videocam_rounded, color: Colors.green,),
                              const SizedBox(width: 12,),
                              Text("Video", style: TextStyle(fontSize: 14.sp))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: const Divider(),
                    ),
                    SizedBox(
                      width: 100.w,
                      height: 30.h,
                      child: const RiveAnimation.asset(AssetsContants.kitty_splash),
                    )
                  ],
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Image.file(
                      File(controller.photoPath.value),
                      width: 100.w,
                      height: 60.h,
                  ),
                );
              }
            })

          ],
        ),
      ),
    );
  }
}
