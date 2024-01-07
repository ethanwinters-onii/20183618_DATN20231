import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kitty_community_app/app/core/base/main_layout.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';
import 'package:kitty_community_app/app/core/utils/extensions/string_extension.dart';
import 'package:kitty_community_app/app/core/utils/helpers/datetime_helper.dart';
import 'package:kitty_community_app/app/data/models/post_model/post_model.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_provider.dart';
import 'package:kitty_community_app/app/modules/wrap/controllers/wrap_controller.dart';
import 'package:kitty_community_app/app/routes/app_pages.dart';
import 'package:sizer/sizer.dart';

import '../../../core/utils/extensions/logger_extension.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MainLayout<HomeController>(
      appBar: AppBar(
        title: const Icon(
          Icons.pets,
          color: Colors.black,
          size: 32,
        ),
        centerTitle: true,
        leading: InkWell(
            onTap: () {
              Get.toNamed(Routes.PROFILE);
            },
            child: const Icon(
              Icons.account_circle_outlined,
              color: primaryColor,
              size: 32,
            )),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: ClipOval(
                        child: CachedNetworkImage(
                            imageUrl: controller.accountInfo.avatar ?? "",
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.person),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.CREATE_POST);
                      },
                      child: Card(
                        surfaceTintColor: Colors.white,
                        elevation: 4,
                        clipBehavior: Clip.antiAlias,
                        child: SizedBox(
                          height: 10.h,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16, left: 12),
                            child: Text(
                              "Hi ${controller.accountInfo.name}, how are you today?",
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 14.sp),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: StreamBuilder(
                  stream: FirebaseProvider.streamAllFriendPost(
                      controller.accountInfo.following ?? []),
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
                        List<PostModel> posts = [];
                        for (var i in data!) {
                          logger.d(i.data());
                          posts.add(PostModel.fromJson(i.data()));
                        }

                        posts.sort((a, b) {
                          DateTime dateTimeA = DateFormat("yyyy-MM-dd HH:mm:ss")
                              .parse(a.createdAt!);
                          DateTime dateTimeB = DateFormat("yyyy-MM-dd HH:mm:ss")
                              .parse(b.createdAt!);
                          return dateTimeB.compareTo(dateTimeA);
                        });

                        return Column(
                          children: [
                            ...posts
                                .map((post) => PostItem(
                                      post: post,
                                      onLike: () {
                                        controller.handleLikeAPost(post);
                                      },
                                      isLiked: post.hearts?.contains(
                                              controller.accountInfo.userId) ??
                                          false,
                                    ))
                                .toList()
                          ],
                        );
                    }
                  }),
            ),
            const SizedBox(
              height: 156,
            )
          ],
        ),
      ),
    );
  }
}

class PostItem extends StatelessWidget {
  const PostItem(
      {super.key,
      required this.post,
      required this.onLike,
      required this.isLiked});

  final PostModel post;
  final VoidCallback onLike;
  final bool isLiked;

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
            child: GestureDetector(
              onTap: () async {
                final accountInfo = await FirebaseProvider.getUserById(post.userId ?? "");
                if (accountInfo != null) {
                  Get.toNamed(Routes.PROFILE, arguments: [post.userId, accountInfo]);
                }
              },
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
          Center(
            child: Row(
              children: [
                const SizedBox(
                  width: 8,
                ),
                Row(
                  children: [
                    InkWell(
                        onTap: onLike,
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_outline,
                          color: isLiked ? secondaryColor : Colors.black,
                        )),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      "${post.hearts?.length}",
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 16,
                ),
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.POST_DETAIL, arguments: [1, post]);
                        },
                        child: const Icon(Icons.comment_outlined)),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      "${post.noComment ?? 0}",
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ],
                ),
              ],
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
