import 'dart:convert';

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
              (state.champions?.spells.length ?? 0) +
                  1, // Agregar 1 para la habilidad pasiva
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

                TextSpan textoTooltip = TextSpan(children: [
                  TextSpan(
                      style: GoogleFonts.anekDevanagari(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      text: index == 0
                          ? "Pasiva: ${utf8.decode(state.champions!.passive!.name!.codeUnits)}\n"
                          : "$spellLetter: ${utf8.decode(state.champions!.spells[index - 1].name!.codeUnits)}\n"),
                  TextSpan(
                      style: GoogleFonts.anekDevanagari(color: Colors.black),
                      text: index == 0
                          ? utf8
                              .decode(state
                                  .champions!.passive!.description!.codeUnits)
                              .replaceAll("<br>", "\n")
                              .replaceAll("<br />", "\n")
                              .replaceAllMapped(RegExp(r'<.*?>'), (match) => '')
                              .replaceAllMapped(
                                  RegExp(r'{{.*?}}'), (match) => '')
                          : utf8
                              .decode(state.champions!.spells[index - 1]
                                  .tooltip!.codeUnits)
                              .replaceAll("<br>", "\n")
                              .replaceAll("<br />", "\n")
                              .replaceAllMapped(RegExp(r'<.*?>'), (match) => '')
                              .replaceAllMapped(RegExp(r'{{(.*?)}}'), (match) {
                              String? contenido = match.group(
                                  1); // Obtén el contenido entre `{{` y `}}`
                              if (contenido != null) {
                                if (contenido
                                    .toLowerCase()
                                    .contains('duration')) {
                                  return "X"; // Reemplaza si contiene 'duration'
                                } else {
                                  return "{{$contenido}}"; // Mantén el contenido sin cambios
                                }
                              } else {
                                return "{{}}"; // En caso de contenido nulo, reemplazar con `{{}}`
                              }
                            }).replaceAll(RegExp(r'{{(.*?)}}'), ""))
                ]);

                return Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10)),
                  showDuration: const Duration(minutes: 5),
                  richMessage: textoTooltip,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: 50,
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 3, 5),
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
                    ),
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
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: pasivaYHabilidadesWidget)
                ],
              )),
            );
          } else {
            return const Center(
              child: Text(
                "Error al cargar el campeón",
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }
}
