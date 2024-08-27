import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../configs/device_size_config.dart';

class LoadingTagDisplay extends StatelessWidget {
  List<int> _numbers = List.generate(10, (index) => index);

  @override
  Widget build(BuildContext context) {
    double boxWidth = 175.w;

    double boxHeight = 120.h;
    return Container(
      height: 500,
      //padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 12.w,
        runSpacing: 15.h,
        alignment: WrapAlignment.center,
        children: _numbers.map((i) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: boxWidth,
              height: boxHeight,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.r),
                  topRight: Radius.circular(5.r),
                  bottomLeft: Radius.circular(5.r),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CustomPaint(
                      size: Size(
                        boxWidth / 2.5,
                        boxHeight / 1.5,
                      ),
                      painter: TrianglePainter(
                        color: const Color.fromRGBO(255, 255, 255, 0.4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height) // Điểm cuối của đoạn cong
      ..arcToPoint(
        Offset(size.width, size.height),
        clockwise: false, // Hướng vẽ (đi ngược chiều kim đồng hồ)
      ) // Điểm bắt đầu của đoạn cong
      ..close(); // Đóng path

    // Tạo một path hình tròn hoặc đường cong cho màu nền
    final backgroundPath = Path()
      ..moveTo(0, size.height) // Điểm bắt đầu của màu nền
      ..lineTo(size.width, 0) // Điểm cuối của đoạn cong
      ..lineTo(size.width, size.height) // Điểm cuối của đoạn cong
      ..arcToPoint(
        Offset(size.width, size.height),
        clockwise: false,
      )
      ..close(); // Đóng path

    canvas.saveLayer(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint(),
    );

    canvas.drawPath(backgroundPath, paint);
    canvas.drawPath(path, Paint()..color = color);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
