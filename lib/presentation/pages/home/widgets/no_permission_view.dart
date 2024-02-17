import 'package:flutter/material.dart';
import 'package:vibel/presentation/pages/home/cubit/home_cubit.dart';

class NoPermissionView extends StatelessWidget {
  const NoPermissionView({
    required this.cubit,
    super.key,
  });

  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('No permission'),
          TextButton(
            onPressed: cubit.requestPermission,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
