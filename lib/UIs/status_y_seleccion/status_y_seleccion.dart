import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol_pedia/UIs/lista_ligas/lista_ligas.dart';

import '../../BLOCS/status_seleccion_bloc/status_bloc.dart';

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
        print(state);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (state.statusResponse == null)
                      ? Text(
                          "Ha ocurrido un error y no hay datos.",
                          style: GoogleFonts.anekDevanagari(
                              color: Colors.white, fontSize: 15),
                        )
                      : Container(),
                  (state.statusResponse?.incidents!.first.incidentSeverity
                              .toString() ==
                          "")
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.green,
                        )
                      : Container(),
                  (state.statusResponse?.incidents!.first.incidentSeverity
                              .toString() ==
                          "info")
                      ? const Icon(
                          Icons.priority_high_rounded,
                          color: Colors.yellow,
                        )
                      : Container(),
                  (state.statusResponse?.incidents!.first.incidentSeverity
                              .toString() ==
                          "warning")
                      ? const Icon(
                          Icons.close_rounded,
                          color: Colors.red,
                        )
                      : Container(),
                  (state.statusResponse?.incidents!.first.incidentSeverity
                                  .toString() ==
                              "info" ||
                          state.statusResponse?.incidents!.first
                                  .incidentSeverity
                                  .toString() ==
                              "warning")
                      ? Text(
                          state.statusResponse?.incidents!.first.titles!.first
                              .content as String,
                          style:
                              GoogleFonts.anekDevanagari(color: Colors.white),
                        )
                      : Container()
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 5,
                      child: Card(
                          color: const Color.fromARGB(98, 75, 75, 75),
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: InkWell(
                            onTap: () => {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return ListaLigas();
                                },
                              ))
                            },
                            child: SizedBox(
                                height: 100,
                                child: Stack(children: [
                                  Image.network(
                                    "https://e00-elmundo.uecdn.es/assets/multimedia/imagenes/2021/08/17/16291886670895.jpg",
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                  const Center(
                                    child: Text("PARTIDOS ESPORT",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "super_punch",
                                            fontSize: 35)),
                                  ),
                                ])),
                          )))
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
