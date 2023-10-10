import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol_pedia/UIs/lista_ligas/lista_ligas.dart';
import 'package:lol_pedia/dinamic_general_variables.dart';
import 'package:lol_pedia/UIs/status_y_seleccion/status_y_seleccion.dart';
import 'package:lol_pedia/services/notifications_service.dart';
import 'package:lol_pedia/widgets/app_bar_con_busqueda.dart';
import 'BLOCS/homepage_bloc/homepage_bloc.dart';
import 'config/locator.dart';
import 'UIs/homepage/homepage.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  await configureDependencies();
  setupAsyncDependencies();
  await setGeneralVariables();

  await NotificationService().initNotifications();
  runApp(Aplicacion());
}

// ignore: must_be_immutable
class Aplicacion extends StatefulWidget {
  Aplicacion({super.key});
  final HomepageBloc bloc = HomepageBloc();
  int currentIndex = 1;

  void filtrarCampeones(String filtro) {
    bloc.filter = filtro;
    bloc.add(FilterLoadedChampions());
  }

  void filtrarLigas(String filtro) {
    bloc.filter = filtro;
    bloc.add(FilterLoadedLigas());
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
    if (widget.currentIndex == 0 || widget.currentIndex == 2) {
      appBar = AppBarConBusqueda(
        bloc: widget.bloc,
        funcionFiltrado: widget.currentIndex == 0
            ? widget.filtrarCampeones
            : widget.filtrarLigas,
        placeholderText: widget.currentIndex == 0
            ? "Nombre de campeón"
            : "Nombre de la liga",
        integratedSearch: true,
      );
    } else {
      appBar = AppBarConBusqueda(
        bloc: widget.bloc,
        funcionFiltrado: null,
        placeholderText: "",
        integratedSearch: false,
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
            : widget.currentIndex == 1
                ? ListaLigas(
                    bloc: widget.bloc,
                  )
                : const StatusYSeleccion(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: widget.currentIndex,
          onTap: (index) {
            cambiarIndex(index);
            HapticFeedback.mediumImpact();
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
                icon: Icon(Icons.videogame_asset_rounded), label: "Esport"),
            BottomNavigationBarItem(
                icon: Icon(Icons.leaderboard_rounded), label: "Estado"),
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
  tz.initializeTimeZones();
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
  vars.timeZoneOffset = DateTime.now().timeZoneOffset;
}
