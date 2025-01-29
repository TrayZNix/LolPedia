import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol_pedia/UIs/match_details/match_details_page.dart';
import 'package:lol_pedia/dinamic_general_variables.dart';
import 'package:lol_pedia/repositories/esport_repository.dart';
import 'package:lol_pedia/services/notifications_service.dart';
import 'package:lol_pedia/widgets/recording_animation.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;
import 'package:basic_utils/basic_utils.dart';

import '../../models/partidos_ligas.dart';

class PartidosLiga extends StatefulWidget {
  final String idLiga;
  final String nombreLiga;

  const PartidosLiga(
      {super.key, required this.idLiga, required this.nombreLiga});

  @override
  State<StatefulWidget> createState() => PartidosLigaState();
}

class PartidosLigaState extends State<PartidosLiga> {
  Future<ScheduleData>? leaguesFuture;
  ItemScrollController matchScrollController = ItemScrollController();
  int? matchInProgressIndex;
  int scrollTo = 0;

  @override
  void initState() {
    super.initState();
    leaguesFuture = GetIt.I.get<EsportRepository>().getPartidos(widget.idLiga);
    findMatchInProgressIndex();
  }

  void findMatchInProgressIndex() {
    DateTime fechaActual = DateTime.now();
    DateTime fechaMasCercana = DateTime(2009);
    leaguesFuture!.then((snapshot) {
      final events = snapshot.schedule?.events;
      if (events != null) {
        for (int index = events.length - 1; index >= 0; index--) {
          DateTime fechaPartido =
              DateTime.parse(events[index].startTime.toString());
          if (fechaActual.difference(fechaMasCercana).abs() >
              fechaActual.difference(fechaPartido).abs()) {
            fechaMasCercana = fechaPartido;
            setState(() {
              scrollTo = (events.length - index - 1) >= 0
                  ? events.length - index - 1
                  : 0;
            });
          }
          if (events[index].state == "inProgress") {
            setState(() {
              matchInProgressIndex = events.length - index;
            });
            break;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Row(
          children: [
            const Text(
              "LOLPEDIA",
              style: TextStyle(
                  fontFamily: "super_punch", fontSize: 40, color: Colors.white),
            ),
            const Spacer(),
            const SizedBox(
              height: 45,
              child: VerticalDivider(
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Flexible(
              flex: 9,
              child: Center(
                child: FittedBox(
                  child: Text(
                    utf8.decode(widget.nombreLiga.runes.toList()),
                    softWrap: true,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.orange,
            height: 4.0,
          ),
        ),
      ),
      floatingActionButton: matchInProgressIndex != null
          ? FloatingbuttonIP(
              matchInProgressIndex: ((((matchInProgressIndex ?? 0) - 2) > 0)
                  ? (matchInProgressIndex ?? 0) - 2
                  : matchInProgressIndex)!,
              matchScrollController: matchScrollController,
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
        child: FutureBuilder<ScheduleData>(
          future: leaguesFuture,
          builder: (context, snapshot) {
            DynamicGeneralVariables generalVariables =
                GetIt.I.get<DynamicGeneralVariables>();
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Muestra el spinner circular mientras se carga
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              // Muestra un mensaje de error si hay un error en la carga
              return const Center(
                child: Text('Error al cargar las ligas'),
              );
            } else if (snapshot.hasData) {
              final leagues = snapshot.data!;
              List<Event> eventos = leagues.schedule!.events!.toList();
              Widget widget = ScrollablePositionedList.builder(
                itemScrollController: matchScrollController,
                itemCount: eventos.length,
                itemBuilder: (context, index) {
                  final reverseIndex = eventos.length - 1 - index;
                  final hoy = DateTime.now().toUtc();
                  final manana =
                      DateTime.now().toUtc().add(const Duration(days: 1));
                  final fechaPartido =
                      DateTime.parse(eventos[reverseIndex].startTime ?? "")
                          .toUtc();
                  var fechaAMostrar = "";
                  tz.TZDateTime tzDateTime = tz.TZDateTime.from(
                    DateTime.parse(fechaPartido.toString()),
                    tz.getLocation("UTC"),
                  ).add(generalVariables.timeZoneOffset);

                  if (tzDateTime.year == hoy.year &&
                      tzDateTime.month == hoy.month &&
                      tzDateTime.day == hoy.day) {
                    fechaAMostrar =
                        "Hoy - ${tzDateTime.hour}:${tzDateTime.minute < 10 ? '0${tzDateTime.minute}' : tzDateTime.minute}";
                  } else if (tzDateTime.year == manana.year &&
                      tzDateTime.month == manana.month &&
                      tzDateTime.day == manana.day) {
                    fechaAMostrar =
                        "Mañana - ${tzDateTime.hour}:${tzDateTime.minute < 10 ? '0${tzDateTime.minute}' : tzDateTime.minute}";
                  } else {
                    fechaAMostrar =
                        DateFormat('dd-MM-yyyy - HH:mm').format(tzDateTime);
                  }
                  if (eventos[reverseIndex].type.toString() == "match") {
                    return InkWell(
                      onTap: () {
                        if (eventos[reverseIndex].state != "unstarted") {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return MatchDetailsPage(
                                  fecha: fechaAMostrar,
                                  matchId: eventos[reverseIndex]
                                      .match!
                                      .id
                                      .toString());
                            },
                          ));
                        } else {
                          SnackBar snackBar = const SnackBar(
                              content: Text("El partido aún no ha comenzado"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: Card(
                        color: Colors.black87,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                            child: FittedBox(
                              child: Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: eventos[reverseIndex]
                                                          .match!
                                                          .teams!
                                                          .first
                                                          .result
                                                          ?.outcome ==
                                                      "win"
                                                  ? Border.all(
                                                      color: Colors.yellow)
                                                  : null,
                                            ),
                                            width: 75,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl:
                                                        eventos[reverseIndex]
                                                                .match!
                                                                .teams!
                                                                .first
                                                                .image ??
                                                            "",
                                                    fit: BoxFit.contain,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 8.0, 0, 0),
                                                    child: FittedBox(
                                                      child: Text(
                                                        eventos[reverseIndex]
                                                                .match!
                                                                .teams!
                                                                .first
                                                                .name ??
                                                            "",
                                                        maxLines: 1,
                                                        style: GoogleFonts
                                                            .anekDevanagari(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          FittedBox(
                                            child: Text(
                                              "  Vs.  ",
                                              maxLines: 1,
                                              style: GoogleFonts.anekDevanagari(
                                                color: Colors.white,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: eventos[reverseIndex]
                                                          .match
                                                          ?.teams
                                                          ?.last
                                                          .result
                                                          ?.outcome ==
                                                      "win"
                                                  ? Border.all(
                                                      color: Colors.yellow)
                                                  : null,
                                            ),
                                            width: 75,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl:
                                                        eventos[reverseIndex]
                                                                .match!
                                                                .teams!
                                                                .last
                                                                .image ??
                                                            "",
                                                    fit: BoxFit.contain,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 8.0, 0, 0),
                                                    child: FittedBox(
                                                      child: Text(
                                                        eventos[reverseIndex]
                                                                .match!
                                                                .teams!
                                                                .last
                                                                .name ??
                                                            "",
                                                        maxLines: 1,
                                                        style: GoogleFonts
                                                            .anekDevanagari(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                  Row(
                                    children: [
                                      Card(
                                        color: eventos[reverseIndex].state !=
                                                "completed"
                                            ? eventos[reverseIndex].state !=
                                                    "inProgress"
                                                ? Colors.green
                                                : Colors.yellow
                                            : Colors.red,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                eventos[reverseIndex].state !=
                                                        "completed"
                                                    ? eventos[reverseIndex]
                                                                .state !=
                                                            "inProgress"
                                                        ? fechaAMostrar
                                                        : "En curso"
                                                    : "Finalizado | $fechaAMostrar",
                                                style:
                                                    GoogleFonts.anekDevanagari(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                              ),
                                              Text(
                                                StringUtils.capitalize(
                                                    eventos[reverseIndex]
                                                        .blockName
                                                        .toString()),
                                                style:
                                                    GoogleFonts.anekDevanagari(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (eventos[reverseIndex].state ==
                                          'unstarted')
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              12, 0, 0, 0),
                                          child: AddNotification(
                                            matchId: (BigInt.parse(
                                                    eventos[reverseIndex]
                                                            .match
                                                            ?.id ??
                                                        ""))
                                                .toInt(),
                                            team1: eventos[reverseIndex]
                                                    .match
                                                    ?.teams
                                                    ?.first
                                                    .code ??
                                                "",
                                            team2: eventos[reverseIndex]
                                                    .match
                                                    ?.teams
                                                    ?.last
                                                    .code ??
                                                "",
                                            partido: eventos[reverseIndex]
                                                    .blockName ??
                                                "",
                                            liga: eventos[reverseIndex]
                                                    .league!
                                                    .name ??
                                                "",
                                            fechaPartido: tzDateTime,
                                          ),
                                        )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Card(
                      color: Colors.black87,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: FittedBox(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FittedBox(
                                        child: Card(
                                          color: eventos[reverseIndex].state !=
                                                  "completed"
                                              ? eventos[reverseIndex].state !=
                                                      "inProgress"
                                                  ? Colors.green
                                                  : Colors.yellow
                                              : Colors.red,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              eventos[reverseIndex].state !=
                                                      "completed"
                                                  ? eventos[reverseIndex]
                                                              .state !=
                                                          "inProgress"
                                                      ? fechaAMostrar
                                                      : "En curso"
                                                  : "Finalizado | $fechaAMostrar",
                                              style: GoogleFonts.anekDevanagari(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        "Show",
                                        maxLines: 1,
                                        style: GoogleFonts.anekDevanagari(
                                          color: Colors.white,
                                          fontSize: 30,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              );
              Future.delayed(const Duration(milliseconds: 250)).then(
                  (value) => matchScrollController.jumpTo(index: scrollTo));
              return widget;
            } else {
              // Si no hay datos, muestra un mensaje indicando que no hay ligas disponibles
              return const Center(
                child: Text('No hay ligas disponibles'),
              );
            }
          },
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class FloatingbuttonIP extends StatefulWidget {
  ItemScrollController matchScrollController;
  int matchInProgressIndex;

  FloatingbuttonIP(
      {super.key,
      required this.matchScrollController,
      required this.matchInProgressIndex});

  @override
  State<StatefulWidget> createState() => FloatingbuttonIPState();
}

class FloatingbuttonIPState extends State<FloatingbuttonIP> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.white,
      child: const RecordingIndicator(),
      onPressed: () {
        widget.matchScrollController
            .jumpTo(index: (widget.matchInProgressIndex));
      },
    );
  }
}

// ignore: must_be_immutable
class AddNotification extends StatefulWidget {
  String team1;
  String team2;
  String partido;
  String liga;
  int matchId;
  bool notificationPlaced = false;
  tz.TZDateTime fechaPartido;
  AddNotification(
      {super.key,
      required this.team1,
      required this.team2,
      required this.partido,
      required this.liga,
      required this.matchId,
      required this.fechaPartido});

  @override
  State<StatefulWidget> createState() => AddNotificationState();
}

class AddNotificationState extends State<AddNotification> {
  @override
  void initState() {
    super.initState();
    NotificationService()
        .checkNotificationExists(
            widget.team1, widget.team2, widget.fechaPartido.toIso8601String())
        .then((value) {
      setState(() {
        widget.notificationPlaced = value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      onTap: () {
        HapticFeedback.mediumImpact();
        if (!widget.notificationPlaced) {
          NotificationService().showNotification(widget.matchId, widget.team1,
              widget.team2, widget.partido, widget.liga, widget.fechaPartido);
        } else {
          NotificationService().cancelNotification(
              widget.team1, widget.team2, widget.fechaPartido);
        }
        setState(() {
          widget.notificationPlaced = !widget.notificationPlaced;
        });
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: ((!widget.notificationPlaced)
                  ? Colors.white
                  : Colors.orange[600])!,
              spreadRadius: 2,
              blurRadius: 8,
            ),
          ],
          color:
              (!widget.notificationPlaced) ? Colors.white : Colors.orange[600],
        ),
        child: Icon((widget.notificationPlaced)
            ? Icons.notifications_off_rounded
            : Icons.notifications_rounded),
      ),
    );
  }
}
