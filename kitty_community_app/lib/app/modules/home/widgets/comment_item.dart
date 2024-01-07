import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';
import 'package:kitty_community_app/app/data/models/comment_model/comment_model.dart';
import 'package:sizer/sizer.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({super.key, required this.e, required this.isLiked, required this.callback});

  final CommentModel e;
  final bool isLiked;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.6), shape: BoxShape.circle),
                child: ClipOval(
                  child: CachedNetworkImage(
                      imageUrl: e.avatar ?? "",
                      errorWidget: (context, url, error) => const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                      fit: BoxFit.cover),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: secondaryColor.withOpacity(0.2)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.name ?? "",
                      style: TextStyle(
                          fontSize: 12.sp, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      e.comment ?? "",
                      style: TextStyle(fontSize: 12.sp),
                      maxLines: 3,
                    ),
                    if (e.commentImage != null &&
                        (e.commentImage?.isNotEmpty ?? false))
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: CachedNetworkImage(
                            imageUrl: e.commentImage ?? "",
                            errorWidget: (context, _, __) => ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: Container(
                                width: 32,
                                height: 32,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.error),
                                ),
                              ),
                            ),
                            width: 40.w,
                          ),
                        ),
                      )
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 52),
            child: Row(
              children: [
                GestureDetector(
                  onTap: callback,
                  child: Text(
                    "Like",
                    style: TextStyle(fontSize: 11.sp, fontWeight: isLiked ? FontWeight.bold : FontWeight.w400, color: isLiked ? customBlueColor : Colors.black54),
                  ),
                ),
                const SizedBox(width: 12,),
                Text(
                  "${e.hearts?.length ?? 0}",
                  style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
