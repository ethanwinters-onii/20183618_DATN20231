import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';
import 'package:kitty_community_app/app/core/utils/extensions/string_extension.dart';
import 'package:kitty_community_app/app/core/utils/helpers/datetime_helper.dart';
import 'package:kitty_community_app/app/data/models/post_model/post_model.dart';
import 'package:sizer/sizer.dart';

class FPost extends StatelessWidget {
  const FPost({
    super.key,
    required this.post,
    required this.isLiked,
    required this.onLike,
  });

  final PostModel post;
  final bool isLiked;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              const BackButton(),
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
                    style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
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
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Text(
              post.description ?? "",
              style: TextStyle(fontSize: 12.sp),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (post.image != null && (post.image?.isNotEmpty ?? false))
          CachedNetworkImage(
            imageUrl: post.image ?? "",
            errorWidget: (context, url, error) =>
                const Icon(Icons.hourglass_empty),
            fit: BoxFit.cover,
            width: 100.w,
            height: 45.h,
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
                      onTap: () {
                        onLike();
                      },
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_outline,
                        color: isLiked ? secondaryColor : Colors.black,
                        size: 32,
                      )),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "${post.hearts?.length ?? 0}",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ],
              ),
              const SizedBox(
                width: 16,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.comment_outlined,
                    size: 32,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "${post.noComment ?? 0}",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}