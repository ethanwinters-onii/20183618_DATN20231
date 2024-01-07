import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';
import 'package:kitty_community_app/app/core/values/languages/key_language.dart';
import 'package:sizer/sizer.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  const ImagePickerBottomSheet({
    super.key,
    required this.onTakePhoto,
    required this.onPickGallery,
  });

  final VoidCallback onTakePhoto;
  final VoidCallback onPickGallery;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onTakePhoto,
              child: Column(
                children: [
                  Image.asset(
                    "assets/icons/ic_cam.png",
                    width: 16.w,
                  ),
                  const SizedBox(height: 12,),
                  Text(
                    KeyLanguage.take_a_new_photo.tr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onPickGallery,
              child: Column(
                children: [
                  Image.asset(
                    "assets/icons/ic_gallery.png",
                    width: 16.w,
                  ),
                  const SizedBox(height: 12,),
                  Text(
                    KeyLanguage.select_from_gallery.tr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500
                    ),
                  )
                ],
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}