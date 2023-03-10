import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lol_pedia/homepage/bloc/homepage_bloc.dart';
import 'package:lol_pedia/repositories/data_dragon_repository.dart';
import 'config/locator.dart';
import 'homepage/Homepage.dart';
import 'models/champion.dart';

Future<void> main() async {
  await configureDependencies();
  setupAsyncDependencies();
  runApp(const Aplicacion());
}

class Aplicacion extends StatelessWidget {
  const Aplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    HomepageBloc bloc = HomepageBloc()..add(LoadChampions());
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Homepage(
          bloc: bloc,
        ),
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
