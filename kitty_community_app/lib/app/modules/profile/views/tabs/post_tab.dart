import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/utils/extensions/string_extension.dart';
import 'package:kitty_community_app/app/modules/profile/controllers/profile_controller.dart';
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
            ...controller.userPosts.map((post) => Card(
              elevation: 4,
              surfaceTintColor: Colors.white,
              color: Colors.white,
              child: Container(
                width: 100.w,
                height: 63.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24)
                ),
                child: Column(
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
                          const SizedBox(width: 12,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.createdBy ?? "",
                                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                DateTimeHelper.calculateTimeDifference(post.createdAt!.toDateTime(), DateTime.now()),
                                style: TextStyle(fontSize: 12.sp),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    if(post.description != null || post.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                        child: Text(
                          post.description ?? "",
                          style: TextStyle(fontSize: 12.sp),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    CachedNetworkImage(
                      imageUrl: post.image ?? "",
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.hourglass_empty),
                      fit: BoxFit.cover,
                      width: 100.w,
                      height: 45.h,
                    ),
                    Expanded(
                      child: Center(
                        child: Row(
                          children: [
                            const SizedBox(width: 8,),
                            Row(
                              children: [
                                const Icon(Icons.favorite_outline),
                                const SizedBox(width: 8,),
                                Text(
                                  "${post.hearts?.length}",
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16,),
                            Row(
                              children: [
                                const Icon(Icons.comment_outlined),
                                const SizedBox(width: 8,),
                                Text(
                                  "0",
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )).toList()
          ],
        ),
      ),
    ));
  }
}
