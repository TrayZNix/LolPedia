import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_images/carousel_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/champion_details_bloc.dart';

class ChampionDetails extends StatelessWidget {
  final String championName;

  const ChampionDetails({super.key, required this.championName});
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
                for (var element in state.champions!.skins) {
                  listaSkins.add(
                      "http://ddragon.leagueoflegends.com/cdn/img/champion/splash/${state.champions?.id}_${element.num}.jpg");
                }
                return SingleChildScrollView(
                    child: Column(
                  children: [
                    Stack(
                      children: [
                        CarouselImages(
                          scaleFactor: 0.6,
                          listImages: listaSkins,
                          height: 300.0,
                          borderRadius: 30.0,
                          cachedNetworkImage: true,
                          verticalAlignment: Alignment.topCenter,
                          onTap: (index) {
                            print('Tapped on page $index');
                          },
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
                    )
                  ],
                ));
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
