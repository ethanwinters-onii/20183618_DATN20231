import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/base/main_layout.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';
import 'package:kitty_community_app/app/core/utils/extensions/logger_extension.dart';
import 'package:kitty_community_app/app/data/models/comment_model/comment_model.dart';
import 'package:kitty_community_app/app/data/models/post_model/post_model.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_provider.dart';
import 'package:kitty_community_app/app/modules/home/controllers/post_detail_controller.dart';
import 'package:kitty_community_app/app/modules/home/widgets/comment_item.dart';
import 'package:kitty_community_app/app/modules/home/widgets/f_post.dart';
import 'package:sizer/sizer.dart';

class PostDetailView extends GetView<PostDetailController> {
  const PostDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout<PostDetailController>(
        child: Container(
      width: 100.w,
      height: 100.h,
      color: Colors.white,
      child: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder(
                      stream: FirebaseProvider.streamAPost(
                          controller.selectedPost.postId ?? "-"),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;

                            if (data?.isNotEmpty ?? false) {
                              final post = PostModel.fromJson(data![0].data());
                              controller.numOfComment.value =
                                  post.noComment ?? 0;
                              return FPost(
                                post: post,
                                isLiked: post.hearts?.contains(
                                        controller.accountInfo.userId) ??
                                    false,
                                onLike: controller.updateLike,
                              );
                            } else {
                              return const SizedBox();
                            }
                        }
                      }),
                  StreamBuilder(
                      stream: FirebaseProvider.streamComment(
                          controller.selectedPost.postId ?? "-"),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            List<CommentModel> comments = [];
                            for (var i in data!) {
                              logger.d(i.data());
                              comments.add(CommentModel.fromJson(i.data()));
                            }

                            comments = comments.reversed.toList();

                            if (comments.isNotEmpty) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ...comments.map((e) => CommentItem(
                                    e: e, 
                                    isLiked: e.hearts?.contains(controller.accountInfo.userId) ?? false,
                                    callback: () => controller.likeComment(e),
                                  )),
                                ],
                              );
                            } else {
                              return const SizedBox();
                            }
                        }
                      }),
                  SizedBox(
                    height: 15.h,
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 100.w,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(3, -3),
                    blurRadius: 6)
              ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 12, bottom: 12),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.handleSelectPhoto();
                          },
                          child: const Icon(
                            Icons.camera_enhance_outlined,
                            color: secondaryColor,
                            size: 32,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            controller: controller.txtController,
                            maxLines: null,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Write a comment",
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32),
                                    borderSide: const BorderSide(
                                        color: secondaryColor)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32),
                                    borderSide: const BorderSide(
                                        color: secondaryColor)),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                )),
                            autofocus: Get.arguments[0] == 1,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        InkWell(
                          onTap: () {
                            controller.handleSendComment();
                          },
                          child: const Icon(
                            Icons.send,
                            color: secondaryColor,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                  Obx(() => controller.photoPath.isEmpty
                      ? const SizedBox(
                          height: 48,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 20, bottom: 50),
                          child: SizedBox(
                            width: 10.h,
                            height: 10.h,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                    width: 8.6.h,
                                    height: 8.6.h,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Colors.black54, width: 2)),
                                    child: Image.file(
                                        File(controller.photoPath.value)),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.photoPath.value = "";
                                    },
                                    child: Container(
                                      width: 3.h,
                                      height: 3.h,
                                      decoration: const BoxDecoration(
                                          color: primaryColor,
                                          shape: BoxShape.circle),
                                      child: const Center(
                                        child: Icon(
                                          Icons.clear,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
