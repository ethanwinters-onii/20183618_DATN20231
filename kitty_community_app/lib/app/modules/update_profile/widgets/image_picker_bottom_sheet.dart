import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';
import 'package:kitty_community_app/app/core/values/languages/key_language.dart';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTakePhoto,
            child: Row(
              children: [
                const Icon(Icons.add_a_photo, color: secondaryColor, size: 30,),
                const SizedBox(width: 12,),
                Text(
                  KeyLanguage.take_a_new_photo.tr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16,),
          GestureDetector(
            onTap: onPickGallery,
            child: Row(
              children: [
                const Icon(Icons.photo, color: secondaryColor, size: 30,),
                const SizedBox(width: 12,),
                Text(
                  KeyLanguage.select_from_gallery.tr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}