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

import '../../models/partidos_ligas.dart';

class PartidosLiga extends StatefulWidget {
  final String idLiga;
  final String nombreLiga;

  const PartidosLiga({Key? key, required this.idLiga, required this.nombreLiga})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => PartidosLigaState();
}

class PartidosLigaState extends State<PartidosLiga> {
  Future<ScheduleData>? leaguesFuture;
  ItemScrollController matchScrollController = ItemScrollController();
  int? matchInProgressIndex;

  @override
  void initState() {
    super.initState();
    leaguesFuture = GetIt.I.get<EsportRepository>().getPartidos(widget.idLiga);
    findMatchInProgressIndex();
  }

  void findMatchInProgressIndex() {
    leaguesFuture!.then((snapshot) {
      final events = snapshot.schedule?.events;
      if (events != null) {
        for (int index = events.length - 1; index >= 0; index--) {
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
        backgroundColor: Colors.black,
        title: Row(
          children: [
            const Text(
              "LOLPEDIA",
              style: TextStyle(fontFamily: "super_punch", fontSize: 40),
            ),
            const Spacer(),
            SizedBox(
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
              return ScrollablePositionedList.builder(
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
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return MatchDetailsPage(
                                fecha: fechaAMostrar,
                                matchId:
                                    eventos[reverseIndex].match!.id.toString());
                          },
                        ));
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FittedBox(
                                          child: Card(
                                            color: eventos[reverseIndex]
                                                        .state !=
                                                    "completed"
                                                ? eventos[reverseIndex].state !=
                                                        "inProgress"
                                                    ? Colors.green
                                                    : Colors.yellow
                                                : Colors.red,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    eventos[reverseIndex]
                                                                .state !=
                                                            "completed"
                                                        ? eventos[reverseIndex]
                                                                    .state !=
                                                                "inProgress"
                                                            ? fechaAMostrar
                                                            : "En curso"
                                                        : "Finalizado | $fechaAMostrar",
                                                    style: GoogleFonts
                                                        .anekDevanagari(
                                                            color: Colors.white,
                                                            fontSize: 17),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text(
                                                      eventos[reverseIndex]
                                                              .blockName ??
                                                          "",
                                                      style: GoogleFonts
                                                          .anekDevanagari(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 17),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                        ),
                                        if (eventos[reverseIndex].state ==
                                            'unstarted')
                                          AddNotification(
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
                                          )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
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
                                          width: 150,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
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
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 18.0, 0, 0),
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
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
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
                                          width: 150,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
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
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 18.0, 0, 0),
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
                                      ),
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
                                                  fontSize: 17),
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
      child: RecordingIndicator(),
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
    NotificationService().checkNotificationExists(widget.matchId).then((value) {
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
          NotificationService().showNotification(
              widget.matchId,
              widget.team1,
              widget.team2,
              widget.partido,
              widget.liga,
              widget.fechaPartido.subtract(
                  GetIt.I.get<DynamicGeneralVariables>().timeZoneOffset));
        } else {
          NotificationService().cancelNotification(widget.matchId);
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
