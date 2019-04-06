import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Colors {

  const Colors();

  static const Color loginGradientStart = const Color(0xFFF2CB1D);
//  static const Color loginGradientStart = const Color(0xFFfbab66);#F2CB1D
  static const Color loginGradientEnd = const Color(0xFF2B4876);
//  static const Color loginGradientEnd = const Color(0xFFf7418c);

  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}