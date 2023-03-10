import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol_pedia/champion_details/champion_details.dart';
import 'package:lol_pedia/homepage/bloc/homepage_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:animations/animations.dart';
import 'package:lol_pedia/models/champion.dart';

import '../widgets/app_bar_con_busqueda.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key, required this.bloc});
  final HomepageBloc bloc;

  

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomepageBloc, HomepageState>(
        bloc: bloc,
        builder: (context, state) {
          return state is HomepageLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : state.status == HomepageStatus.success
                  ? Builder(
                      builder: (context) {
                        return AnimationLimiter(
                          child: GridView.count(
                              crossAxisCount: 3,
                              childAspectRatio: 1,
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: List.generate(
                                  state.filteredChamps.length, (index) {
                                return AnimationConfiguration.staggeredGrid(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  columnCount: state.filteredChamps.length,
                                  child: ScaleAnimation(
                                    child: FadeInAnimation(
                                        child: InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ChampionDetails(
                                              championName: state
                                                      .filteredChamps[index]
                                                      .id ??
                                                  "");
                                        }));
                                      },
                                      child: Stack(
                                        children: [
                                          Center(
                                              child: CachedNetworkImage(
                                            imageUrl:
                                                "http://ddragon.leagueoflegends.com/cdn/13.4.1/img/champion/${state.filteredChamps[index].image!.full}",
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          )),
                                          Positioned(
                                            bottom: 20,
                                            right: 25,
                                            child: Text(
                                              state.filteredChamps[index].name,
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
                                    )),
                                  ),
                                );
                              })),
                        );
                      },
                    )
                  : const Center(
                      child: Text("Error loading the champions"),
                    );
        },
    );
  }
}
