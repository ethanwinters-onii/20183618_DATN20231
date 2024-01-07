import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kitty_community_app/app/core/base/main_layout.dart';
import 'package:kitty_community_app/app/core/utils/extensions/logger_extension.dart';
import 'package:kitty_community_app/app/data/models/notification_model/notification_model.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_provider.dart';
import 'package:kitty_community_app/app/modules/notification/widgets/notification_item.dart';
import 'package:kitty_community_app/app/modules/wrap/controllers/wrap_controller.dart';
import 'package:sizer/sizer.dart';

import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MainLayout<NotificationController>(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      child: StreamBuilder(
          stream: FirebaseProvider.streamUserNotification(),
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
                List<NotificationModel> notifcations = [];
                for (var i in data!) {
                  logger.d(i.data());
                  notifcations.add(NotificationModel.fromJson(i.data()));
                }

                notifcations.sort((a, b) {
                  DateTime dateTimeA = DateFormat("yyyy-MM-dd HH:mm:ss")
                      .parse(a.notificationCreateAt!);
                  DateTime dateTimeB = DateFormat("yyyy-MM-dd HH:mm:ss")
                      .parse(b.notificationCreateAt!);
                  return dateTimeB.compareTo(dateTimeA);
                });

                if (notifcations.isNotEmpty) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ...notifcations.map((e) => NotificationItem(e: e)),
                        const SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      "No notifications",
                      style: TextStyle(fontSize: 12.sp, color: Colors.black),
                    ),
                  );
                }
            }
          }),
    );
  }
}
