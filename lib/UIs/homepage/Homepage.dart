import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get_it/get_it.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lolpedia/UIs/champion_details/champion_details.dart';

import '../../BLOCS/homepage_bloc/homepage_bloc.dart';
import '../../dinamic_general_variables.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key, required this.bloc})
    : riotDeveloperKey = GetIt.I.get<DynamicGeneralVariables>();
  final DynamicGeneralVariables riotDeveloperKey;
  final HomepageBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomepageBloc, HomepageState>(
      bloc: bloc,
      builder: (context, state) {
        return state is HomepageLoading
            ? const Center(child: CircularProgressIndicator())
            : state is ChampionState
            ? state.status == HomepageStatus.success
                ? Builder(
                  builder: (context) {
                    return AnimationLimiter(
                      child: GridView.count(
                        crossAxisCount:
                            MediaQuery.of(context).size.width ~/ 100,
                        childAspectRatio: 1,
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: List.generate(state.filteredChamps.length, (
                          index,
                        ) {
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            columnCount: state.filteredChamps.length,
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ChampionDetails(
                                            championName:
                                                state
                                                    .filteredChamps[index]
                                                    .id ??
                                                "",
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "http://ddragon.leagueoflegends.com/cdn/${riotDeveloperKey.versionActual}/img/champion/${state.filteredChamps[index].image!.full}",
                                          fit: BoxFit.cover,
                                          placeholder:
                                              (context, url) =>
                                                  const CircularProgressIndicator(),
                                          errorWidget:
                                              (context, url, error) =>
                                                  const Icon(Icons.error),
                                        ),
                                      ),
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
                                                blurRadius: 6,
                                              ),
                                              Shadow(
                                                color: Colors.black,
                                                offset: Offset(0, 0),
                                                blurRadius: 6,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  },
                )
                : const Center(child: Text("Error loading the champions"))
            : Container();
      },
    );
  }
}
