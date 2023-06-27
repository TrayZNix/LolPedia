import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lol_pedia/UIs/partidos_liga/partidos_liga.dart';
import 'package:lol_pedia/models/leagues.dart';
import 'package:lol_pedia/repositories/esport_repository.dart';

class ListaLigas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ListaLigasState();
}

class ListaLigasState extends State<ListaLigas> {
  Future<Leagues>? leaguesFuture;

  @override
  void initState() {
    super.initState();
    leaguesFuture = GetIt.I.get<EsportRepository>().getLeagues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "LOLPEDIA",
          style: TextStyle(fontFamily: "super_punch", fontSize: 40),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Leagues>(
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
                crossAxisCount: 2,
              ),
              itemCount: leagues.data.leagues.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return PartidosLiga(
                            idLiga: leagues.data.leagues[index].id);
                      },
                    ));
                  },
                  child: Card(
                    color: Colors.black87,
                    child: Center(
                      child: Stack(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: CachedNetworkImage(
                                imageUrl: leagues.data.leagues[index].image,
                              )),
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
