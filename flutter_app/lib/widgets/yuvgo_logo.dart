import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class YuvGoLogo extends StatelessWidget {
  final double fontSize;
  final FontWeight fontWeight;

  const YuvGoLogo({
    super.key,
    this.fontSize = 24,
    this.fontWeight = FontWeight.w700,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'YUV',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              color: Color(0xFF00C3FF), // Exact cyan from logo
              letterSpacing: -1.0,
            ),
          ),
          TextSpan(
            text: 'GO',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E293B), // Exact dark navy from logo
              letterSpacing: -1.0,
            ),
          ),
        ],
      ),
    );
  }
}
