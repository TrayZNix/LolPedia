import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol_pedia/homepage/bloc/homepage_bloc.dart';
import 'package:lol_pedia/widgets/app_bar_con_busqueda.dart';
import 'config/locator.dart';
import 'homepage/Homepage.dart';

Future<void> main() async {
  await configureDependencies();
  setupAsyncDependencies();
  runApp(Aplicacion());
}

class Aplicacion extends StatefulWidget {
  Aplicacion({super.key});
  final HomepageBloc bloc = HomepageBloc();
  int currentIndex = 0;
  void filtrarCampeones(String filtro) {
    bloc.filter = filtro;
    bloc.add(FilterLoadedChampions());
  }

  @override
  State<StatefulWidget> createState() => AplicacionState();
}

class AplicacionState extends State<Aplicacion> {
  void cambiarIndex(int index) {
    setState(() {
      widget.currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.bloc.add(LoadChampions());
    PreferredSizeWidget appBar;
    if (widget.currentIndex == 0) {
      appBar = AppBarConBusqueda(
        bloc: widget.bloc,
        filtrarCampeones: widget.filtrarCampeones,
      );
    } else {
      appBar = AppBar(
        backgroundColor: Colors.black,
        title: const Row(children: [
          Text(
            "LOLPEDIA",
            style: TextStyle(fontFamily: "super_punch", fontSize: 40),
          )
        ]),
        centerTitle: true,
      );
    }

    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: appBar,
        body: Homepage(
          bloc: widget.bloc,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: widget.currentIndex,
          onTap: (index) {
            cambiarIndex(index);
          },
          selectedItemColor: Colors.white,
          unselectedLabelStyle: GoogleFonts.anekDevanagari(color: Colors.white),
          selectedIconTheme: const IconThemeData(color: Colors.yellowAccent),
          unselectedItemColor: Colors.white,
          backgroundColor: Colors.black,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.info_outline_rounded), label: "Campeones"),
            BottomNavigationBarItem(
                icon: Icon(Icons.leaderboard_rounded), label: "Online")
          ],
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
