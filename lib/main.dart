import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol_pedia/dinamic_general_variables.dart';
import 'package:lol_pedia/repositories/data_dragon_repository.dart';
import 'package:lol_pedia/UIs/status_y_seleccion/status_y_seleccion.dart';
import 'package:lol_pedia/widgets/app_bar_con_busqueda.dart';
import 'BLOCS/homepage_bloc/homepage_bloc.dart';
import 'config/locator.dart';
import 'UIs/homepage/Homepage.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  await configureDependencies();
  setupAsyncDependencies();
  await setGeneralVariables();
  runApp(Aplicacion());
}

// ignore: must_be_immutable
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
        body: widget.currentIndex == 0
            ? Homepage(
                bloc: widget.bloc,
              )
            : StatusYSeleccion(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: widget.currentIndex,
          onTap: (index) {
            cambiarIndex(index);
          },
          selectedItemColor: Colors.white,
          unselectedLabelStyle:
              GoogleFonts.anekDevanagari(color: Colors.grey[700]),
          selectedIconTheme: const IconThemeData(color: Colors.white),
          unselectedItemColor: Colors.grey[700],
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

setGeneralVariables() async {
  DynamicGeneralVariables vars = GetIt.I.get<DynamicGeneralVariables>();
  List<String> versiones = [];
  final response = await http
      .get(Uri.parse('https://ddragon.leagueoflegends.com/api/versions.json'));
  if (response.statusCode == 200) {
    final decodedResponse = json.decode(response.body);
    if (decodedResponse is List<dynamic>) {
      versiones = List<String>.from(decodedResponse);
    }
  }

  vars.versionList = versiones;
  vars.versionActual = versiones.first.toString();
}
