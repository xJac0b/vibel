import 'dart:ui';

import 'package:vibel/presentation/styles/colors/app_colors.dart';

class DarkAppColor extends BaseColors {
  const DarkAppColor()
      : super(
          primary: const Color(0xEFcf3b2c),
          background: const Color(0xFF171A1F),
          text: const Color(0xffE7E7E7),
          error: const Color(0xffFF0000),
          hint: const Color(0xDDDDDDDD),
          correct: const Color(0xff00FF00),
          warning: const Color(0xffFFA500),
        );
}
