import 'package:flutter/material.dart';

Widget gradientTitle(String text) {
  return ShaderMask(
    shaderCallback: (bounds) => LinearGradient(
      colors: [Colors.deepOrange, const Color.fromARGB(255, 68, 29, 9)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}
