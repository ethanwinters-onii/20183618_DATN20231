import 'package:flutter/material.dart';

class ErrorImageWidget extends StatelessWidget {
  const ErrorImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
      "Image Error",
      style: TextStyle(
          color: Colors.red, fontWeight: FontWeight.bold, fontSize: 24),
    ));
  }
}
