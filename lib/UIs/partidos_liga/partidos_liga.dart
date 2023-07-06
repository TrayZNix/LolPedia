import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol_pedia/models/leagues.dart';
import 'package:lol_pedia/repositories/esport_repository.dart';
import 'package:lol_pedia/widgets/recording_animation.dart';
import 'package:intl/intl.dart';

import '../../models/partidos_ligas.dart';

class PartidosLiga extends StatefulWidget {
  final String idLiga;

  const PartidosLiga({Key? key, required this.idLiga}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PartidosLigaState();
}

class PartidosLigaState extends State<PartidosLiga> {
  Future<ScheduleData>? leaguesFuture;
  ScrollController matchScrollController = ScrollController();
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
              matchInProgressIndex = index;
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
        title: const Text(
          "LOLPEDIA",
          style: TextStyle(fontFamily: "super_punch", fontSize: 40),
        ),
        centerTitle: true,
      ),
      floatingActionButton: matchInProgressIndex != null
          ? FloatingActionButton(
              backgroundColor: Colors.white,
              child: RecordingIndicator(),
              onPressed: () {
                print(matchInProgressIndex);
              },
            )
          : null,
      body: FutureBuilder<ScheduleData>(
        future: leaguesFuture,
        builder: (context, snapshot) {
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
            List<Event> eventos = leagues.schedule!.events!
                .where((event) => (event.match!.teams!.last.name != "TBD" &&
                    event.match!.teams!.last.name != "TBD"))
                .toList();
            return GridView.builder(
              controller: matchScrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1.75,
              ),
              itemCount: eventos.length,
              itemBuilder: (context, index) {
                final reverseIndex = eventos.length - 1 - index;
                final hoy = DateTime.now();
                final manana = DateTime.now().add(const Duration(days: 1));
                final fechaPartido =
                    DateTime.parse(eventos[reverseIndex].startTime ?? "");
                final formattedDate = DateFormat('dd-MM-yyyy - HH:mm').format(
                    DateTime.parse(eventos[reverseIndex].startTime ?? ""));
                var fechaAMostrar = "";
                if (fechaPartido.year == hoy.year &&
                    fechaPartido.month == hoy.month &&
                    fechaPartido.day == hoy.day) {
                  fechaAMostrar =
                      "Hoy - ${fechaPartido.hour}:${fechaPartido.minute}";
                } else if (fechaPartido.year == manana.year &&
                    fechaPartido.month == manana.month &&
                    fechaPartido.day == manana.day) {
                  fechaAMostrar =
                      "Mañana - ${fechaPartido.hour}:${fechaPartido.minute}";
                } else {
                  fechaAMostrar = formattedDate;
                }
                return Card(
                  color: Colors.black87,
                  child: Center(
                    child: FittedBox(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FittedBox(
                                  child: Text(
                                    fechaAMostrar,
                                    style: GoogleFonts.anekDevanagari(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: eventos[reverseIndex]
                                                .match!
                                                .teams!
                                                .first
                                                .result
                                                ?.outcome ==
                                            "win"
                                        ? Border.all(color: Colors.yellow)
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
                                          imageUrl: eventos[reverseIndex]
                                                  .match!
                                                  .teams!
                                                  .first
                                                  .image ??
                                              "",
                                          fit: BoxFit.contain,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
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
                                              style: GoogleFonts.anekDevanagari(
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
                                    borderRadius: BorderRadius.circular(15),
                                    border: eventos[reverseIndex]
                                                .match!
                                                .teams!
                                                .last
                                                .result
                                                ?.outcome ==
                                            "win"
                                        ? Border.all(color: Colors.yellow)
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
                                          imageUrl: eventos[reverseIndex]
                                                  .match!
                                                  .teams!
                                                  .last
                                                  .image ??
                                              "",
                                          fit: BoxFit.contain,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
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
                                              style: GoogleFonts.anekDevanagari(
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
                );
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
    );
  }
}
