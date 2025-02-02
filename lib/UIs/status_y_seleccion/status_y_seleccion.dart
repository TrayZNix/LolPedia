import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lolpedia/dinamic_general_variables.dart';
import 'package:lolpedia/models/league_status_response.dart';
import '../../BLOCS/status_seleccion_bloc/status_bloc.dart';

class StatusYSeleccion extends StatelessWidget {
  const StatusYSeleccion({super.key});

  @override
  Widget build(BuildContext context) {
    StatusBloc bloc = StatusBloc()..add(LoadStatus());
    return RefreshIndicator(
      onRefresh: () async => {bloc.add(LoadStatus())},
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(children: [WidgetDeReportes(bloc: bloc)]),
        ),
      ),
    );
  }
}

class WidgetDeReportes extends StatelessWidget {
  final StatusBloc bloc;
  const WidgetDeReportes({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatusBloc, StatusState>(
      bloc: bloc,
      builder: (context, state) {
        if (state is StatusLoading) {
          return const Padding(
            padding: EdgeInsets.all(18.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.loaded) {
          return MenuSeleccion(
            error: state.statusResponse == null,
            widgetsIncidencias: state.statusResponse?.incidents ?? [],
            widgetsMantenimientos: state.statusResponse?.maintenances ?? [],
          );
        } else {
          return const Padding(
            padding: EdgeInsets.all(18.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

class MenuSeleccion extends StatefulWidget {
  final List<Incidents> widgetsIncidencias;
  final List<Maintenances> widgetsMantenimientos;
  final bool error;

  const MenuSeleccion({
    super.key,
    required this.widgetsIncidencias,
    required this.widgetsMantenimientos,
    required this.error,
  });
  @override
  State<StatefulWidget> createState() => MenuSeleccionState();
}

class MenuSeleccionState extends State<MenuSeleccion> {
  DynamicGeneralVariables vars = GetIt.I.get<DynamicGeneralVariables>();
  String entorno = "";
  List<Widget> widgetsIncidencias = [];
  List<Widget> widgetsMantenimientos = [];
  void changeDevice(String device) {
    setState(() {
      if (entorno == device) {
        entorno = "";
      } else {
        widgetsIncidencias = [];
        widgetsMantenimientos = [];
        entorno = device;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    for (Incidents incidents in widget.widgetsIncidencias) {
      if (incidents.platforms.contains(entorno) || entorno == "") {
        String incidentTitle =
            incidents.titles!
                .where((element) => element.locale == vars.lang)
                .first
                .content;
        String incidentDescription =
            incidents.updates!.last.translations
                .where((element) => element.locale == vars.lang)
                .first
                .content;
        String severity = incidents.incidentSeverity ?? "";
        Widget widget = Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 5, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        severity == 'warning'
                            ? const Icon(
                              Icons.warning_rounded,
                              color: Colors.yellow,
                            )
                            : severity == "critical"
                            ? const Icon(
                              Icons.dangerous_rounded,
                              color: Colors.red,
                            )
                            : const Icon(Icons.info, color: Colors.green),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: Text(
                            severity.toUpperCase(),
                            style: GoogleFonts.anekDevanagari(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (incidents.platforms.contains("windows"))
                          const Icon(
                            Icons.window_sharp,
                            color: Colors.lightBlue,
                          ),
                        if (incidents.platforms.contains("macos"))
                          const Icon(
                            Icons.laptop_mac_sharp,
                            color: Colors.grey,
                          ),
                        if (incidents.platforms.contains("ios"))
                          const Icon(Icons.apple, color: Colors.grey),
                        if (incidents.platforms.contains("android"))
                          const Icon(Icons.android, color: Colors.green),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(endIndent: 15, indent: 15),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Text(
                  incidentTitle,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.anekDevanagari(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Text(
                  incidentDescription,
                  softWrap: true,
                  style: GoogleFonts.anekDevanagari(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        );
        widgetsIncidencias.add(widget);
      }
    }
    for (Maintenances maintenances in widget.widgetsMantenimientos) {
      if (maintenances.platforms.contains(entorno) || entorno == "") {
        String textoMant = "";
        String incidentTitle =
            maintenances.updates.last.translations
                .where((element) => element.locale == vars.lang)
                .first
                .content;
        textoMant = incidentTitle;
        DateTime? updatedAt = maintenances.updates.last.updatedAt;
        Widget widget = Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 5, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.engineering, color: Colors.orange),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: Text(
                            "INFORME DE MANTENIMIENTO",
                            style: GoogleFonts.anekDevanagari(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (maintenances.platforms.contains("windows"))
                          const Icon(
                            Icons.window_sharp,
                            color: Colors.blueAccent,
                          ),
                        if (maintenances.platforms.contains("macos"))
                          const Icon(
                            Icons.laptop_mac_sharp,
                            color: Colors.grey,
                          ),
                        if (maintenances.platforms.contains("ios"))
                          const Icon(Icons.apple, color: Colors.grey),
                        if (maintenances.platforms.contains("android"))
                          const Icon(Icons.android, color: Colors.green),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(endIndent: 15, indent: 15),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Text(
                  textoMant,
                  softWrap: true,
                  style: GoogleFonts.anekDevanagari(
                    color: Colors.black,
                    fontSize: 13,
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                child: Row(
                  children: [
                    Text(
                      "Ultima actualización: ",
                      softWrap: true,
                      maxLines: 10,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.anekDevanagari(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${DateFormat('dd/MM/yyyy HH:mm z').format(updatedAt ?? DateTime.now())} BST",
                      softWrap: true,
                      maxLines: 10,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.anekDevanagari(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
        widgetsMantenimientos.add(widget);
      }
    }
    return Center(
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                (widget.error)
                    ? Text(
                      "Ha ocurrido un error y no hay datos.",
                      style: GoogleFonts.anekDevanagari(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                    : SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  splashFactory: NoSplash.splashFactory,
                                  onTap: () {
                                    changeDevice("windows");
                                  },
                                  child: Card(
                                    color:
                                        entorno == "windows"
                                            ? Colors.orange[200]
                                            : Colors.white,
                                    child: const Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.window_sharp,
                                            color: Colors.lightBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  splashFactory: NoSplash.splashFactory,
                                  onTap: () {
                                    changeDevice("macos");
                                  },
                                  child: Card(
                                    color:
                                        entorno == "macos"
                                            ? Colors.orange[200]
                                            : Colors.white,
                                    child: const Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.laptop_mac_sharp,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  splashFactory: NoSplash.splashFactory,
                                  onTap: () {
                                    changeDevice("ios");
                                  },
                                  child: Card(
                                    color:
                                        entorno == "ios"
                                            ? Colors.orange[200]
                                            : Colors.white,
                                    child: const Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.apple,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  splashFactory: NoSplash.splashFactory,
                                  onTap: () {
                                    changeDevice("android");
                                  },
                                  child: Card(
                                    color:
                                        entorno == "android"
                                            ? Colors.orange[200]
                                            : Colors.white,
                                    child: const Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.android,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(color: Colors.orange, thickness: 2),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                            child: Text(
                              "INCIDENCIAS",
                              style: GoogleFonts.anekDevanagari(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          widgetsIncidencias.isEmpty
                              ? Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  10,
                                  0,
                                  10,
                                  0,
                                ),
                                child: Card(
                                  color: Colors.grey[600],
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "No hay incidencias registradas",
                                          style: GoogleFonts.anekDevanagari(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              : Column(children: widgetsIncidencias),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                            child: Text(
                              "MANTENIMIENTOS",
                              style: GoogleFonts.anekDevanagari(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          widgetsMantenimientos.isEmpty
                              ? Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  10,
                                  0,
                                  10,
                                  0,
                                ),
                                child: Card(
                                  color: Colors.grey[600],
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "No hay mantenimientos programados",
                                          style: GoogleFonts.anekDevanagari(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              : Column(children: widgetsMantenimientos),
                        ],
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
