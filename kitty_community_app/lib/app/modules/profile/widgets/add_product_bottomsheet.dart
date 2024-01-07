import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitty_community_app/app/global_widgets/app_button.dart';
import 'package:kitty_community_app/app/modules/update_profile/widgets/profile_text_field.dart';
import 'package:sizer/sizer.dart';

import '../../../core/theme/color_theme.dart';

class AddProductBottomSheet extends StatelessWidget {
  const AddProductBottomSheet({
    super.key,
    required this.nameEditingController,
    required this.priceEditingController,
    required this.imagePath,
    required this.onSelectImage,
    required this.onRemoveImage,
    required this.onAddProduct,
  });

  final TextEditingController nameEditingController;
  final TextEditingController priceEditingController;
  final String imagePath;
  final VoidCallback onSelectImage;
  final VoidCallback onRemoveImage;
  final VoidCallback onAddProduct;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "New product",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
              ),
              GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(
                    Icons.expand_more,
                    color: Colors.grey,
                    size: 26,
                  ))
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          ProfileTextField(
              label: "Product name",
              txtEditingController: nameEditingController,
              prefixIcon: const Icon(
                Icons.local_mall,
                color: secondaryColor,
              ),
              validator: (value) {
              if (value!.isEmpty) {
                return "Product name can not be empty";
              }
              return null;
            }
          ),
          const SizedBox(
            height: 12,
          ),
          ProfileTextField(
            label: "Price",
            txtEditingController: priceEditingController,
            prefixIcon: const Icon(
              Icons.local_offer,
              color: secondaryColor,
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Price can not be empty";
              }
              return null;
            },
            keyboardType: TextInputType.number,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "Image",
            style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imagePath.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SizedBox(
                    width: 10.h,
                    height: 10.h,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            width: 8.6.h,
                            height: 8.6.h,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.black54, width: 2)),
                            child: Image.file(File(imagePath)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: onRemoveImage,
                            child: Container(
                              width: 3.h,
                              height: 3.h,
                              decoration: const BoxDecoration(
                                  color: primaryColor, shape: BoxShape.circle),
                              child: const Center(
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              if (imagePath.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 1.4.h),
                  child: GestureDetector(
                    onTap: onSelectImage,
                    child: DottedBorder(
                      color: Colors.black54,
                      dashPattern: const [6, 6],
                      strokeWidth: 2,
                      strokeCap: StrokeCap.round,
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(8),
                      child: SizedBox(
                        width: 8.h,
                        height: 8.h,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_enhance,
                                color: Colors.black54,
                                size: 30,
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                "0/1",
                                style: TextStyle(color: Colors.black54),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(
            height: 64,
          ),
          AppButton(
              callback: onAddProduct, width: 100.w, height: 6.h, label: "Add +")
        ],
      ),
    );
  }
}
