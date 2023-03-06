import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol_pedia/champion_details/champion_details.dart';
import 'package:lol_pedia/homepage/bloc/homepage_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

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
        body: BlocBuilder<HomepageBloc, HomepageState>(
            bloc: HomepageBloc()..add(LoadChampions()),
            builder: (context, state) {
              print(state);
              if (state is HomepageLoading) {
                // ignore: prefer_const_constructors
                return Center(
                  child: const CircularProgressIndicator(),
                );
              }
              if (state.status == HomepageStatus.success) {
                return GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: List.generate(state.champions.length, (index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ChampionDetails(
                                championName: state.champions[index].name);
                          }));
                        },
                        child: Stack(
                          children: [
                            Center(
                                child: CachedNetworkImage(
                              imageUrl:
                                  "http://ddragon.leagueoflegends.com/cdn/13.4.1/img/champion/${state.champions[index].image!.full}",
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )),
                            Positioned(
                              bottom: 20,
                              right: 25,
                              child: Text(
                                state.champions[index].name,
                                // ignore: prefer_const_constructors
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: "super_punch",
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
                            )
                          ],
                        ),
                      );
                    }));
              } else
                return Text("Error loading the champions");
            }));
  }
}
