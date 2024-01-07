import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/base/main_layout.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';
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
        title: Obx(
          () => controller.isSearching.value
              ? TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Find new friends...",
                    fillColor: Colors.transparent,
                    filled: true,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                  ),
                  style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                  onChanged: (value) {
                    controller.searchList.clear();
                    for (var user in controller.accounts) {
                      if (user.name!
                          .toLowerCase()
                          .contains(value.toLowerCase())) {
                        controller.searchList.add(user);
                      }
                    }
                  },
                )
              : const Text(
                  'Search',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 19),
                ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
              onPressed: () {
                controller.handleOnSearching();
              },
              icon: Obx(() => Icon(controller.isSearching.value
                  ? CupertinoIcons.clear_circled_solid
                  : Icons.search))),
        ],
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

                    return Obx(() {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: SizedBox(
                          height: 70.h,
                          child:  SingleChildScrollView(
                            child: Column(
                              children: [
                                if (controller.isSearching.value)
                                  ...controller.searchList.map((user) => UserCard(
                                        user: user,
                                        isFollowed: user.follower?.contains(
                                                controller.accountLocal.userId ??
                                                    "") ??
                                            false,
                                        onFollow: () {
                                          if (user.follower?.contains(
                                                  controller.accountLocal.userId ??
                                                      "") ??
                                              false) {
                                            logger.w("Unfollow");
                                            FirebaseProvider.unFollowingSomeone(
                                                user);
                                          } else {
                                            logger.w("Follow");
                                            FirebaseProvider.followingSomeone(user);
                                          }
                                        },
                                        onSelect: () {},
                                      ))
                                else
                                  ...controller.accounts.map((user) => UserCard(
                                        user: user,
                                        isFollowed: user.follower?.contains(
                                                controller.accountLocal.userId ??
                                                    "") ??
                                            false,
                                        onFollow: () {
                                          if (user.follower?.contains(
                                                  controller.accountLocal.userId ??
                                                      "") ??
                                              false) {
                                            logger.w("Unfollow");
                                            FirebaseProvider.unFollowingSomeone(
                                                user);
                                          } else {
                                            logger.w("Follow");
                                            FirebaseProvider.followingSomeone(user);
                                          }
                                        },
                                        onSelect: () {},
                                      )),
                                const SizedBox(height: 64,),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                }
              }),
        ],
      ),
    );
  }
}


