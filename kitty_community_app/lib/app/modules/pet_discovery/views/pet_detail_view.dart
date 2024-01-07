import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/base/main_layout.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';
import 'package:kitty_community_app/app/core/values/languages/key_language.dart';
import 'package:kitty_community_app/app/modules/pet_discovery/controllers/pet_detail_controller.dart';
import 'package:sizer/sizer.dart';

class PetDetailView extends GetView<PetDetailController> {
  const PetDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MainLayout<PetDetailController>(
      child: Container(
        color: Colors.white,
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100.w,
                height: 27.h,
                child: Stack(
                  children: [
                    Obx(
                      () => Center(
                        child: Container(
                          width: 100.w,
                          color: Colors.grey.withOpacity(0.5),
                          child: CachedNetworkImage(
                            imageUrl: controller.currentAvatar.value,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: InkWell(
                          onTap: () => Get.back(),
                          child: const Padding(
                            padding: EdgeInsets.only(left: 8, top: 8),
                            child: SizedBox(
                                width: 36,
                                height: 36,
                                child: Icon(
                                  Icons.keyboard_backspace,
                                  color: Colors.white,
                                  size: 30,
                                )),
                          )),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: ClipOval(
                              child: Container(
                                  width: 36,
                                  height: 36,
                                  color: Colors.white,
                                  child: const Center(
                                    child: Icon(
                                      Icons.favorite,
                                      color: primaryColor,
                                    ),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          InkWell(
                            onTap: () {},
                            child: ClipOval(
                              child: Container(
                                  width: 36,
                                  height: 36,
                                  color: Colors.white,
                                  child: const Center(
                                    child: Icon(
                                      Icons.share,
                                      color: Colors.grey,
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 100.w,
                height: 10.h,
                color: Colors.lightBlue.withOpacity(0.1),
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...controller.pet.images
                            .map((e) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 16),
                                  child: InkWell(
                                    onTap: () {
                                      controller.onChangeCurrentAvatar(e);
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Obx(
                                        () => controller.currentAvatar.value == e
                                            ? CachedNetworkImage(
                                                imageUrl: e,
                                                fit: BoxFit.fill,
                                                width: 7.h,
                                                height: 7.h,
                                              )
                                            : ColorFiltered(
                                                colorFilter: ColorFilter.mode(
                                                  Colors.black.withOpacity(
                                                      0.3), // Adjust the opacity for the desired darkness
                                                  BlendMode.darken,
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl: e,
                                                  fit: BoxFit.fill,
                                                  width: 7.h,
                                                  height: 7.h,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ))
                            .toList()
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.lang == 'en'
                              ? controller.pet.enName
                              : controller.pet.vnName,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.public,
                              color: Colors.green,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              controller.pet.origin,
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "${KeyLanguage.weight.tr}:\t\t",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                                color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: controller.pet.weight,
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "${KeyLanguage.appearance.tr}\n\t\t",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                                color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: controller.lang == "en"
                                      ? controller.pet.enAppearance
                                      : controller.pet.viAppearance,
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "${KeyLanguage.temperament.tr}\n\t\t\t",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                                color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: controller.lang == "en"
                                      ? controller.pet.enTemperament
                                      : controller.pet.viTemperament,
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "${KeyLanguage.longevity.tr}:\t\t",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                                color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "${controller.pet.health} ${KeyLanguage.years.tr}",
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "${KeyLanguage.price.tr}:\t\t",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                                color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: controller.pet.price,
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "${KeyLanguage.description.tr}\n\t\t\t",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                                color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: controller.lang == "en"
                                      ? controller.pet.enDescription
                                      : controller.pet.viDescription,
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
