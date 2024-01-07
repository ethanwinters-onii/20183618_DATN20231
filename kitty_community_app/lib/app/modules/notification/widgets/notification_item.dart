import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';
import 'package:kitty_community_app/app/core/utils/extensions/string_extension.dart';
import 'package:kitty_community_app/app/core/utils/helpers/datetime_helper.dart';
import 'package:kitty_community_app/app/data/models/notification_model/notification_model.dart';
import 'package:sizer/sizer.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.e
  });

  final NotificationModel e;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 12.h,
      decoration: BoxDecoration(
          color: e.read == true ? Colors.white : primaryColor.withOpacity(0.2)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(120),
                  child: CachedNetworkImage(
                      imageUrl: e.userNotifyAvatar ?? "",
                      errorWidget: (context, _, __) => ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: Container(
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.person,
                                  size: 48,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      width: 84,
                      height: 84,
                      fit: BoxFit.cover),
                ),
                if (e.notifyType == "post")
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Transform.translate(
                      offset: Offset(4, 4),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xff94f2a2), Colors.green],
                            ),
                            shape: BoxShape.circle),
                        child: const Icon(
                          Icons.newspaper,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                else if (e.notifyType == "comment")
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Transform.translate(
                      offset: Offset(4, 4),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xff94ebff), Colors.blue],
                            ),
                            shape: BoxShape.circle),
                        child: const Icon(
                          Icons.notes,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                else if (e.notifyType == "event")
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Transform.translate(
                      offset: Offset(4, 4),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xfff78897), Colors.red],
                            ),
                            shape: BoxShape.circle),
                        child: const Icon(
                          Icons.event_available,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
              ],
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: e.userNotifyName ?? "User",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.sp,
                            color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: " ${e.notificationContent}",
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400)),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      DateTimeHelper.calculateTimeDifference(
                          e.notificationCreateAt!.toDateTime(), DateTime.now()),
                      style: TextStyle(fontSize: 10.sp),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}