import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AccountImage extends StatelessWidget {
  AccountImage(
      {super.key, this.avatarPath, required this.imageUrl, required this.callback});

  String? avatarPath;
  final String imageUrl;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          elevation: 2,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(75),
              child: avatarPath == ""
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      errorWidget: (context, _, __) => Container(
                        width: 16.h,
                        height: 16.h,
                        color: Colors.red,
                      ),
                      fit: BoxFit.cover,
                      width: 16.h,
                      height: 16.h,
                    )
                  : Image.file(
                      File(avatarPath!),
                      errorBuilder: (context, _, __) => Container(
                        width: 16.h,
                        height: 16.h,
                        color: Colors.red,
                      ),
                      fit: BoxFit.cover,
                      width: 16.h,
                      height: 16.h,
                    )),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: MaterialButton(
            onPressed: callback,
            shape: const CircleBorder(),
            color: Colors.white,
            child: const Icon(
              Icons.add_a_photo,
              color: Colors.black,
            ),
          ),
        )
      ],
    );
  }
}
