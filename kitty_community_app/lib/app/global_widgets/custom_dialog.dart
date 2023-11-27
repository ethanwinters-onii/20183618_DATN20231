import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';
import 'package:sizer/sizer.dart';

class CustomDialog extends StatelessWidget {
  CustomDialog({super.key, this.color, required this.title, required this.content});

  Color? color;
  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 5.h,
              decoration: BoxDecoration(
                color: color ?? Colors.red
              ),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: content,
            ),
            ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("OK"),
                ))
          ],
        ),
      ),
    );
  }
}
