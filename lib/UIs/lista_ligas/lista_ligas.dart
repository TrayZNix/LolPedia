import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../BLOCS/homepage_bloc/homepage_bloc.dart';
import '../partidos_liga/partidos_liga.dart';

class ListaLigas extends StatelessWidget {
  const ListaLigas({super.key, required this.bloc});
  final HomepageBloc bloc;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomepageBloc, HomepageState>(
      bloc: bloc..add(LoadLigas()),
      builder: (context, state) {
        return state is HomepageLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : state is LeagueState
                ? state.status == HomepageStatus.success
                    ? GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).size.width ~/ 150,
                        ),
                        itemCount: state.filteredLeagues.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return PartidosLiga(
                                    idLiga: state.filteredLeagues[index].id,
                                    nombreLiga:
                                        state.filteredLeagues[index].name,
                                  );
                                },
                              ));
                            },
                            child: Card(
                              color: Colors.black12,
                              child: Center(
                                child: Stack(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(25.0),
                                        child: CachedNetworkImage(
                                          imageUrl: state
                                              .filteredLeagues[index].image,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Container()
                : Container();
      },
    );
  }
}
