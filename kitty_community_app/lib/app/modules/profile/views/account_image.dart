import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AccountImage extends StatelessWidget {
  AccountImage({
    super.key,
    this.image,
    required this.callback,
    this.haveButton = true
  });

  final String? image;
  final VoidCallback callback;
  bool haveButton;

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
              child: CachedNetworkImage(
                imageUrl: image ?? "",
                errorWidget: (context, _, __) => Container(
                  width: 8.h,
                  height: 8.h,
                  child: Image.asset(
                    "assets/icons/logo.png",
                    fit: BoxFit.cover,
                  ),
                ),
                fit: BoxFit.cover,
                width: 16.h,
                height: 16.h,
              )),
        ),
        if (haveButton)
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