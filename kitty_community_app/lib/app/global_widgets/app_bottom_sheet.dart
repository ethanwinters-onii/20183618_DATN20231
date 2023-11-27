import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../core/values/constants.dart';

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    required this.height,
    required this.child
  });

  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: height,
      decoration: const BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
              image: AssetImage(AssetsContants.img_home_bottom_sheet),
              fit: BoxFit.fill)),
      child: child,
    );
  }
}