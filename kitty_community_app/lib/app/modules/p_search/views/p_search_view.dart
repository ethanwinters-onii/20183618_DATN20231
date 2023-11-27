import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/base/main_layout.dart';
import 'package:kitty_community_app/app/data/models/user_model/account_info.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_provider.dart';
import 'package:sizer/sizer.dart';

import '../../../core/utils/extensions/logger_extension.dart';
import '../controllers/p_search_controller.dart';
import '../widgets/user_card.dart';

class PSearchView extends GetView<PSearchController> {
  const PSearchView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MainLayout<PSearchController>(
      appBar: AppBar(
        title: Text("Search"),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "Who to follow",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
          ),
          StreamBuilder(
              stream: FirebaseProvider.streamAllUser(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    for (var i in data!) {
                      logger.d(i.data());
                      if (!controller.accountIds.contains(i.data()["UserId"])) {
                        controller.addAccount(AccountInfo.fromJson(i.data()));
                      }
                    }
                }
                return Obx(() {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...controller.accounts.map((user) => UserCard(
                                user: user,
                                isFollowed: user.follower?.contains(
                                        controller.accountLocal.userId ?? "") ??
                                    false,
                                onFollow: () {
                                  if (user.follower?.contains(
                                          controller.accountLocal.userId ?? "") ??
                                      false) {
                                    logger.w("Unfollow");
                                    FirebaseProvider.unFollowingSomeone(user);
                                  } else {
                                    logger.w("Follow");
                                    FirebaseProvider.followingSomeone(user);
                                  }
                                },
                                onSelect: () {},
                              ))
                        ],
                      ),
                    ),
                  );
                });
              }),
        ],
      ),
    );
  }
}
