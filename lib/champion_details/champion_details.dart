import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                // return Text(
                //    ?? "ssd",

                //   style: TextStyle(color: Colors.white),
                // );
                return Column(
                  children: [
                    Stack(
                      children: [
                        CachedNetworkImage(
                            imageUrl:
                                "http://ddragon.leagueoflegends.com/cdn/img/champion/splash/${state.champions?.id}_0.jpg"),
                    Positioned(
                        bottom: 5,
                        right: 5,
                        child: Text(
                              state.champions?.name ?? "",
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "super_punch",
                              fontSize: 40),
                        ))
                  ],
                    ),
                    Text(
                      state.champions?.lore ?? "",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                );
              } else {
                return const Text(
                  "Error loading the champions",
                  style: TextStyle(color: Colors.white),
                );
              }
            }));
  }
}
