import 'package:flutter/material.dart';

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path0 = Path();
    path0.moveTo(0, 0);
    path0.quadraticBezierTo(size.width * 0.2018625, size.height * 0.2515500,
        size.width * 0.3889625, size.height * 0.2536500);
    path0.quadraticBezierTo(size.width * 0.4022750, size.height * 0.5891000,
        size.width * 0.5002250, size.height * 0.6302000);
    path0.quadraticBezierTo(size.width * 0.5988375, size.height * 0.5912000,
        size.width * 0.6134125, size.height * 0.2522000);
    path0.quadraticBezierTo(
        size.width * 0.8005250, size.height * 0.2533000, size.width, 0);
    path0.lineTo(size.width, size.height);
    path0.lineTo(0, size.height * 0.9997000);
    path0.lineTo(0, 0);
    canvas.drawShadow(path0, Colors.black, 10, true);
    path0.close();

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}