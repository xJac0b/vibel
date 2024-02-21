import 'dart:ui';

import 'package:vibel/presentation/styles/colors/app_colors.dart';

class DarkAppColor extends BaseColors {
  const DarkAppColor()
      : super(
          primary: const Color(0xff7eabef),
          background: const Color(0xff24293e),
          text: const Color(0xfff4f5fc),
          error: const Color(0xffFF0000),
          hint: const Color(0xff2D3652),
          correct: const Color(0xff00FF00),
          warning: const Color(0xffFFA500),
        );
}
