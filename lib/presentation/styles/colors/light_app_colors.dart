import 'dart:ui';

import 'package:vibel/presentation/styles/colors/app_colors.dart';

class LightAppColor extends BaseColors {
  const LightAppColor()
      : super(
          primary: const Color(0xFFbdb6af),
          background: const Color(0xFFededed),
          text: const Color(0xff333333),
          error: const Color(0xffFF0000),
          hint: const Color(0xFF444444),
          correct: const Color(0xff00FF00),
          warning: const Color(0xffFFA500),
        );
}
