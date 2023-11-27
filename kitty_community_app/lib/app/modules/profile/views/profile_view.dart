import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/base/main_layout.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';
import 'package:kitty_community_app/app/core/values/constants.dart';
import 'package:kitty_community_app/app/modules/profile/views/account_image.dart';
import 'package:kitty_community_app/app/modules/profile/views/tabs/like_tab.dart';
import 'package:kitty_community_app/app/modules/profile/views/tabs/post_tab.dart';
import 'package:sizer/sizer.dart';

import '../controllers/profile_controller.dart';
import '../widgets/circle_tab_bar.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MainLayout<ProfileController>(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 32.h,
            child: Stack(
              children: [
                Container(
                  width: 100.w,
                  height: 22.h,
                  // color: Colors.lightBlue,
                  child: Image.asset(
                    AssetsContants.img_bg,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Positioned(
                  top: 14.h,
                  left: 24,
                  child: AccountImage(
                    image: controller.accountInfo.avatar,
                    callback: () {},
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: SafeArea(
                    child: SizedBox(
                      width: 100.w,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Icon(Icons.keyboard_backspace, color: Colors.white, size: 32,)
                            ),
                            GestureDetector(
                                onTap: () {
                                  // Get.back();
                                  controller.handleSignOut();
                                },
                                child: Icon(Icons.logout, color: Colors.white, size: 32,)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.accountInfo.name ?? "User",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(Icons.data_usage_outlined, color: secondaryColor,),
                    const SizedBox(width: 8,),
                    Text(
                      controller.accountInfo.description ?? "Have a good day",
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                const SizedBox(height: 8,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.cake_outlined, color: secondaryColor,),
                    const SizedBox(width: 8,),
                    Text(
                      controller.accountInfo.dateOfBirth ?? "",
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                const SizedBox(height: 12,),
                Row(
                  children: [
                    Text(
                      "${controller.accountInfo.following?.length ?? 0}",
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " Following",
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    const SizedBox(width: 16,),
                    Text(
                      "${controller.accountInfo.follower?.length ?? 0}",
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " Followers",
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 100.w,
            height: 36,
            child: TabBar(
              labelPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              controller: controller.tabController,
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.black,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.white,
              indicatorColor: Colors.white,
              indicator: const CircleTabBarDecoration(
                  color: secondaryColor, radius: 4),
              tabs: [
                Tab(
                    child: Text(
                        'Posts',
                        style: TextStyle(fontSize: 12.sp),
                    )
                ),
                Tab(
                    child: Text(
                      'Likes',
                      style: TextStyle(fontSize: 12.sp),
                    )
                ),
                Tab(
                    child: Text(
                      'My store',
                      style: TextStyle(fontSize: 12.sp),
                    )
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: const <Widget>[
                PostTab(),
                LikeTab(),
                const SizedBox(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
