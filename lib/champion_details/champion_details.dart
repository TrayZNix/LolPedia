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
              print(state);
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
                return Stack(
                  children: [
                    Image.network(
                        "http://ddragon.leagueoflegends.com/cdn/img/champion/splash/${state.champions!.aatrox.name}_0.jpg"),
                    Positioned(
                        bottom: 5,
                        right: 5,
                        child: Text(
                          state.champions!.aatrox.name ?? "",
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "super_punch",
                              fontSize: 40),
                        ))
                  ],
                );
              } else
                return Text(
                  "Error loading the champions",
                  style: TextStyle(color: Colors.white),
                );
            }));
  }
}
