import 'dart:ui';

import 'package:vibel/presentation/styles/colors/app_colors.dart';

class LightAppColor extends BaseColors {
  const LightAppColor()
      : super(
          primary: const Color(0xEFef5d3e),
          background: const Color(0xFFEEEEEE),
          text: const Color(0xff333333),
          error: const Color(0xffFF0000),
          hint: const Color(0xee444444),
          correct: const Color(0xff00FF00),
          warning: const Color(0xffFFA500),
        );
}
