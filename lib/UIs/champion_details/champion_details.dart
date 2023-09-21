import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_images/carousel_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../BLOCS/champion_details_bloc/champion_details_bloc.dart';
import '../../dinamic_general_variables.dart';

class ChampionDetails extends StatelessWidget {
  final String championName;
  final DynamicGeneralVariables riotDeveloperKey;

  ChampionDetails({Key? key, required this.championName})
      : riotDeveloperKey = GetIt.I.get<DynamicGeneralVariables>(),
        super(key: key);
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
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4.0),
              child: Container(
                color: Colors.orange,
                height: 4.0,
              ),
            )),
        body: BlocBuilder<ChampionDetailsBloc, ChampionDetailsState>(
            bloc: ChampionDetailsBloc(championName)..add(LoadChampionDetails()),
            builder: (context, state) {
              if (state is ChampionDetailsLoading) {
                // ignore: prefer_const_constructors
                return Center(
                  child: const CircularProgressIndicator(),
                );
              }
              if (state.status == ChampionDetailsStatus.success) {
                List<String> listaSkins = [];
                for (var element in state.champions?.skins ?? []) {
                  listaSkins.add(
                      "http://ddragon.leagueoflegends.com/cdn/img/champion/splash/${state.champions?.id}_${element.num}.jpg");
                }
                List<Widget> pasivaYHabilidadesWidget = List.generate(
                  state.champions?.spells.length ??
                      0 + 1, // Agregar 1 para la habilidad pasiva
                  (index) {
                    String imageUrl;
                    String spellLetter = "";
                    if (index == 0) {
                      imageUrl =
                          "http://ddragon.leagueoflegends.com/cdn/${riotDeveloperKey.versionActual}/img/passive/${state.champions?.passive?.image?.full}";
                      spellLetter = "P";
                    } else {
                      imageUrl =
                          "http://ddragon.leagueoflegends.com/cdn/${riotDeveloperKey.versionActual}/img/spell/${state.champions!.spells[index - 1].image!.full}";
                      if (index == 1) {
                        spellLetter = "Q";
                      } else if (index == 2) {
                        spellLetter = "W";
                      } else if (index == 3) {
                        spellLetter = "E";
                      } else if (index == 4) {
                        spellLetter = "R";
                      }
                    }
                    return Expanded(
                      flex: 2,
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: 50,
                            height: 50,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 20,
                            child: Text(
                              spellLetter,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: "super_punch",
                                fontSize: 20,
                                shadows: [
                                  Shadow(
                                      color: Colors.black,
                                      offset: Offset(5, 5),
                                      blurRadius: 6),
                                  Shadow(
                                      color: Colors.black,
                                      offset: Offset(0, 0),
                                      blurRadius: 6),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      Stack(
                        children: [
                          CarouselImages(
                            scaleFactor: 0.6,
                            listImages: listaSkins,
                            height: 200,
                            borderRadius: 30.0,
                            cachedNetworkImage: true,
                            verticalAlignment: Alignment.topCenter,
                          ),
                          Positioned(
                              bottom: 15,
                              right: 45,
                              child: Text(
                                state.champions?.name ?? "",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: "super_punch",
                                  fontSize: 40,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black,
                                        offset: Offset(5, 5),
                                        blurRadius: 6),
                                    Shadow(
                                        color: Colors.black,
                                        offset: Offset(0, 0),
                                        blurRadius: 6),
                                  ],
                                ),
                              ))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          state.champions?.lore ?? "",
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.anekDevanagari(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(25),
                        child: Row(
                          children: pasivaYHabilidadesWidget,
                        ),
                      )
                    ],
                  )),
                );
              } else {
                return const Text(
                  "Error loading the champions",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.white),
                );
              }
            }));
  }
}
