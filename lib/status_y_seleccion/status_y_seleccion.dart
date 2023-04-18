import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol_pedia/status_y_seleccion/bloc/status_bloc.dart';

import '../datos_partida/datos_partida.dart';
import '../widgets/widget_builder.dart';

class StatusYSeleccion extends StatelessWidget {
  const StatusYSeleccion({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Status(), MenuSeleccion()],
    );
  }
}

class Status extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatusBloc, StatusState>(
      bloc: StatusBloc()..add(LoadStatus()),
      builder: (context, state) {
        if (state is StatusLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.loaded) {
          return Center(
              child: Column(
            children: [
              Text(
                "Estado de los servidores",
                style: GoogleFonts.anekDevanagari(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              WidgetCreator().statusWidgetBuilder(state.statusResponse),
              Divider(
                color: Colors.grey[700],
                endIndent: 20,
                indent: 20,
              ),
              Row(
                children: [
                  Expanded(
                      flex: 5,
                      child: Card(
                          color: Colors.black,
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: InkWell(
                            // onTap: () => {
                            //   Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) => const Provincias()))
                            // },
                            child: SizedBox(
                                height: 100,
                                child: Stack(children: [
                                  Image.network(
                                    "https://opgg-static.akamaized.net/images/medals_new/master.png",
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 10,
                                    left: 10,
                                    child: Center(
                                      child: Text(
                                        "JUGADORES",
                                        style: GoogleFonts.anekDevanagari(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                ])),
                          ))),
                  Expanded(
                      flex: 5,
                      child: Card(
                          color: Colors.black,
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: InkWell(
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DatosPartida()))
                            },
                            child: SizedBox(
                                height: 100,
                                child: Stack(children: [
                                  Image.network(
                                    "http://ddragon.leagueoflegends.com/cdn/6.8.1/img/map/map11.png",
                                    fit: BoxFit.contain,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 10,
                                    left: 10,
                                    child: Center(
                                      child: Text(
                                        "PARTIDA",
                                        style: GoogleFonts.anekDevanagari(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                ])),
                          ))),
                ],
              )
            ],
          ));
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class MenuSeleccion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("");
  }
}
