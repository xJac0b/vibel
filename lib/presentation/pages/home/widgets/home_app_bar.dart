import 'package:flutter/material.dart';
import 'package:vibel/presentation/pages/home/cubit/home_cubit.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    required this.cubit,
    super.key,
  });

  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      centerTitle: true,
      title: Text('Home'),
      floating: true,
      snap: true,
      actions: [],
    );
  }
}
