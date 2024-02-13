import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:vibel/presentation/pages/home/cubit/home_cubit.dart';
import 'package:vibel/presentation/styles/app_typography.dart';
import 'package:vibel/presentation/styles/theme/app_theme_provider.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = useBloc<HomeCubit>();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            title: const Text('Home'),
            floating: true,
            snap: true,
            actions: [
              IconButton(
                icon: const Icon(FontAwesomeIcons.sun),
                onPressed: () {
                  cubit.changeTheme(
                    AppThemeProvider.of(context).theme.brightness ==
                            Brightness.light
                        ? ThemeMode.dark
                        : ThemeMode.light,
                  );
                },
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    'Item $index',
                    style: AppTypography.of(context).body,
                  ),
                );
              },
              childCount: 100,
            ),
          ),
        ],
      ),
    );
  }
}
