import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/utils/extensions/string_extension.dart';
import 'package:kitty_community_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils/helpers/datetime_helper.dart';

class LikeTab extends GetView<ProfileController> {
  const LikeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Lights, camera...\nattachments!",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16,),
          Text(
            "Your favorite photos and videos will show up here",
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
