import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol_pedia/models/leagues.dart';
import 'package:lol_pedia/repositories/esport_repository.dart';

import '../../models/partidos_ligas.dart';

class PartidosLiga extends StatefulWidget {
  final String idLiga;

  const PartidosLiga({Key? key, required this.idLiga}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PartidosLigaState();
}

class PartidosLigaState extends State<PartidosLiga> {
  Future<ScheduleData>? leaguesFuture;

  @override
  void initState() {
    super.initState();
    leaguesFuture = GetIt.I.get<EsportRepository>().getPartidos(widget.idLiga);
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
            // Muestra el GridView cuando los datos están disponibles
            final leagues = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, childAspectRatio: 1.95),
              itemCount: leagues.schedule?.events?.length,
              itemBuilder: (context, index) {
                // print(leagues.events?[index].match!.teams!.first.name);
                return Card(
                  color: Colors.black87,
                  child: Center(
                    child: FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: leagues.schedule?.events?[index].match!
                                            .teams!.first.result?.outcome ==
                                        "win"
                                    ? Border.all(color: Colors.yellow)
                                    : null,
                              ),
                              width: 150,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: leagues.schedule?.events?[index]
                                              .match!.teams!.first.image ??
                                          "",
                                      fit: BoxFit.contain,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 18.0, 0, 0),
                                      child: FittedBox(
                                        child: Text(
                                          leagues.schedule?.events?[index]
                                                  .match!.teams!.first.name ??
                                              "",
                                          maxLines: 1,
                                          style: GoogleFonts.anekDevanagari(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                    )
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
                                  color: Colors.white, fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: leagues.schedule?.events?[index].match!
                                            .teams!.last.result?.outcome ==
                                        "win"
                                    ? Border.all(color: Colors.yellow)
                                    : null,
                              ),
                              width: 150,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: leagues.schedule?.events?[index]
                                              .match!.teams!.last.image ??
                                          "",
                                      fit: BoxFit.contain,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 18.0, 0, 0),
                                      child: FittedBox(
                                        child: Text(
                                          leagues.schedule?.events?[index]
                                                  .match!.teams!.last.name ??
                                              "",
                                          maxLines: 1,
                                          style: GoogleFonts.anekDevanagari(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
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
