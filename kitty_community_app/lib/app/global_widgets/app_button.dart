import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, required this.callback, required this.width, required this.height, required this.label});

  final double width;
  final double height;
  final String label;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFE87AB), Color(0xFFDA4873)],
        ),
        borderRadius: BorderRadius.circular(height * 0.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(height * 0.5),
          splashColor: Colors.white.withOpacity(0.5),
          onTap: callback,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
