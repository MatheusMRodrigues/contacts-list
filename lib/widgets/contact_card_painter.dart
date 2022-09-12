import 'package:flutter/material.dart';

class ContactCardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;
     
         
    Path path0 = Path();
    path0.moveTo(0,0);
    path0.lineTo(0,size.height);
    path0.lineTo(size.width,size.height);
    path0.lineTo(size.width,size.height*0.2142857);
    path0.lineTo(size.width*0.8750000,0);
    path0.lineTo(size.width*0.8750000,size.height*0.2142857);
    path0.lineTo(size.width,size.height*0.2142857);
    path0.lineTo(size.width*0.8750000,0);
    path0.lineTo(0,0);
    path0.close();

    canvas.drawPath(path0, paint0);
  

  Paint paint1 = Paint()
      ..color = const Color.fromARGB(255, 0, 0, 0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
     
         
    Path path1 = Path();
    path1.moveTo(0,0);
    path1.lineTo(0,size.height);
    path1.lineTo(size.width,size.height);
    path1.lineTo(size.width,size.height*0.2142857);
    path1.lineTo(size.width*0.8750000,1);
    path1.lineTo(size.width*0.8750000,size.height*0.2142857);
    path1.lineTo(size.width * 0.994,size.height*0.2142857);
    path1.lineTo(size.width*0.87550000,0);
    path1.lineTo(0,0);
    path1.close();

    canvas.drawPath(path1, paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}