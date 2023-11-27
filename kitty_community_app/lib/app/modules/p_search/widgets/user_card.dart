import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';
import 'package:sizer/sizer.dart';

import '../../../data/models/user_model/account_info.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.user,
    required this.isFollowed,
    required this.onFollow,
    required this.onSelect,
  });

  final AccountInfo user;
  final bool isFollowed;
  final VoidCallback onFollow;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      child: Card(
        child: Container(
          width: 100.w,
          height: 8.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 8),
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
                          fontSize: 12.sp, fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      user.description ?? "Have a good day \u2764",
                      style: TextStyle(
                          fontSize: 10.sp, fontWeight: FontWeight.w300),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onFollow,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: isFollowed ? Colors.grey : customBlueColor,
                      padding: const EdgeInsets.symmetric(horizontal: 4)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.pets,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        isFollowed ? "Unfollow" : "Follow",
                        style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
