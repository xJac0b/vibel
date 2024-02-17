import 'package:flutter/material.dart';
import 'package:vibel/presentation/styles/app_dimens.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(
      dimension: AppDimens.progressIndicatorSize,
      child: CircularProgressIndicator(
        strokeWidth: AppDimens.progressIndicatorStrokeWidth,
      ),
    );
  }
}
