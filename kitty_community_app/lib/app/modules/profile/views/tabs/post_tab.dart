import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/utils/extensions/logger_extension.dart';
import 'package:kitty_community_app/app/core/utils/extensions/string_extension.dart';
import 'package:kitty_community_app/app/data/models/post_model/post_model.dart';
import 'package:kitty_community_app/app/modules/home/views/home_view.dart';
import 'package:kitty_community_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:kitty_community_app/app/routes/app_pages.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils/helpers/datetime_helper.dart';

class PostTab extends GetView<ProfileController> {
  const PostTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...controller.userPosts.map((post) {
                  logger.i(post.image);
                  return MyPost(
                      post: post,
                      );
                }).toList(),
                const SizedBox(height: 100,)
              ],
            ),
          ),
        ));
  }
}

class MyPost extends StatelessWidget {
  const MyPost(
      {super.key,
      required this.post,});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      surfaceTintColor: Colors.white,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: ClipOval(
                    child: CachedNetworkImage(
                        imageUrl: post.userAvatar ?? "",
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.person),
                        fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.createdBy ?? "",
                      style: TextStyle(
                          fontSize: 12.sp, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      DateTimeHelper.calculateTimeDifference(
                          post.createdAt!.toDateTime(), DateTime.now()),
                      style: TextStyle(fontSize: 12.sp),
                    )
                  ],
                )
              ],
            ),
          ),
          if (post.description != null || post.description!.isNotEmpty)
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.POST_DETAIL, arguments: [0, post]);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: Text(
                  post.description ?? "",
                  style: TextStyle(fontSize: 12.sp),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          if (post.image != null && (post.image?.isNotEmpty ?? false))
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.POST_DETAIL, arguments: [0, post]);
              },
              child: CachedNetworkImage(
                imageUrl: post.image ?? "",
                errorWidget: (context, url, error) =>
                    const Icon(Icons.hourglass_empty),
                fit: BoxFit.cover,
                width: 100.w,
                height: 45.h,
              ),
            ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}