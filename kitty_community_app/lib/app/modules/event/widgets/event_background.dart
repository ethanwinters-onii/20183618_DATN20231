import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EventBackground extends StatelessWidget {
  const EventBackground({
    super.key, required this.callback, required this.imagePath,
  });

  final VoidCallback callback;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 24.h,
      color: Colors.grey.withOpacity(0.2),
      child: imagePath.isEmpty ? Stack(
        children: [
          Positioned(
            bottom: 12,
            right: 12,
            child: InkWell(
              onTap: callback,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(12)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Add",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ) : GestureDetector(
        onTap: callback,
        child: Image.file(File(imagePath), fit: BoxFit.fill,)
      ),
    );
  }
}
