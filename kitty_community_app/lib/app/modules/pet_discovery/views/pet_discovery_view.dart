import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/base/main_layout.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';
import 'package:kitty_community_app/app/core/values/constants.dart';
import 'package:kitty_community_app/app/routes/app_pages.dart';
import 'package:rive/rive.dart';
import 'package:sizer/sizer.dart';

import '../controllers/pet_discovery_controller.dart';

class PetDiscoveryView extends GetView<PetDiscoveryController> {
  const PetDiscoveryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MainLayout<PetDiscoveryController>(
      appBar: AppBar(
        title: const Text(
          'Discovery',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 24, right: 24),
              child: Obx(
                () => TextField(
                  controller: controller.txtEditingController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(1000)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(1000)),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: controller.onSearch.value
                          ? InkWell(
                              onTap: controller.removeSearch,
                              child: const Icon(
                                Icons.clear,
                                color: Colors.black,
                              ),
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16)),
                  onChanged: (value) {
                    controller.searchPet(value);
                  },
                ),
              ),
            ),
            Obx(() => controller.petListOnSearch.isNotEmpty
                ? SizedBox(
                    width: 100.w,
                    height: 40.h,
                    child: PageView.builder(
                      controller: controller.pageController,
                      itemBuilder: (context, index) {
                        final e = controller.petListOnSearch[
                            index % controller.petListOnSearch.length];
                        return Column(
                          children: [
                            SizedBox(
                              height: 2.h,
                            ),
                            Container(
                              width: 100.w,
                              height: 30.h,
                              margin: const EdgeInsets.symmetric(horizontal: 24),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: InkWell(
                                    onTap: () {
                                      Get.toNamed(Routes.PET_DETAIL,
                                          arguments: e);
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: e.avatar,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              controller.lang == "en" ? e.enName : e.vnName,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  )
                : const SizedBox()),
            Obx(() => controller.petListOnSearch.isNotEmpty
                ? SizedBox(
                    width: 100.w,
                    height: 30.h,
                    child: const RiveAnimation.asset(AssetsContants.kitty_splash),
                  )
                : const SizedBox())
          ],
        ),
      ),
    );
  }
}
