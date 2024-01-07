import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';
import 'package:kitty_community_app/app/core/utils/extensions/logger_extension.dart';
import 'package:kitty_community_app/app/core/utils/extensions/string_extension.dart';
import 'package:kitty_community_app/app/data/models/product_model/product_model.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_provider.dart';
import 'package:kitty_community_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:sizer/sizer.dart';

class StoreTab extends GetView<ProfileController> {
  const StoreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseProvider.streamProducts(controller.selectUserID.value),
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
              List<ProductModel> products = [];
              for (var i in data!) {
                logger.d(i.data());
                products.add(ProductModel.fromJson(i.data()));
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    runSpacing: 8,
                    children: [
                      ...products.map((e) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              width: 28.w,
                              height: 45.w,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: customBlueColor, width: 2),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: CachedNetworkImage(
                                        imageUrl: e.image ?? "",
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.lock_clock),
                                        fit: BoxFit.contain,
                                        width: 25.w,
                                        height: 20.w,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      e.name ?? "",
                                      style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w400),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "${e.price?.toCurrencyFromLocale()} đ",
                                      style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w400,
                                          color: primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              );
          }
        });
  }
}
