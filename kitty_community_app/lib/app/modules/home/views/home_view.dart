import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/base/main_layout.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';
import 'package:sizer/sizer.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MainLayout<HomeController>(
      appBar: AppBar(
        title: const Icon(Icons.pets, color: Colors.black, size: 32,),
        centerTitle: true,
        leading: const Icon(Icons.account_circle_outlined, color: primaryColor, size: 32,),
      ),
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
                        imageUrl: controller.user.photoURL ?? "",
                        errorWidget: (context, url, error) => const Icon(Icons.person),
                        fit: BoxFit.cover
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16,),
                Expanded(
                  child: Card(
                    surfaceTintColor: Colors.white,
                    elevation: 4,
                    clipBehavior: Clip.antiAlias,
                    child: SizedBox(
                      height: 10.h,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, left: 12),
                        child: Text(
                          "Hi ${controller.user.displayName}, how are you today?",
                          style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16,),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Icon(Icons.wallpaper, color: Colors.green, size: 36,),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
