import 'package:flutter/material.dart';

class YuvGoLogoImage extends StatelessWidget {
  final double height;
  final bool whiteYuv;
  
  const YuvGoLogoImage({
    Key? key,
    this.height = 24,
    this.whiteYuv = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use text-based logo for consistent rendering
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'YUV',
          style: TextStyle(
            fontSize: height,
            fontWeight: FontWeight.w900,
            fontFamily: 'Mulish',
            color: whiteYuv ? Colors.white : const Color(0xFF00BFFE),
            letterSpacing: -0.5,
            height: 1.0,
          ),
        ),
        Text(
          'GO',
          style: TextStyle(
            fontSize: height,
            fontWeight: FontWeight.w900,
            fontFamily: 'Mulish',
            color: const Color(0xFF0A1929),
            letterSpacing: -0.5,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}
