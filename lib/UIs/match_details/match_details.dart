import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol_pedia/BLOCS/match_details_bloc/match_bloc.dart';

class MatchDetailsPage extends StatelessWidget {
  final String matchId;
  final String fecha;

  const MatchDetailsPage(
      {super.key, required this.matchId, required this.fecha});

  @override
  Widget build(BuildContext context) {
    MatchBloc bloc = MatchBloc(matchId);
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Row(
          children: [
            Text(
              "LOLPEDIA",
              style: TextStyle(fontFamily: "super_punch", fontSize: 40),
            ),
            Spacer(),
          ],
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.orange,
            height: 4.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Card(
          color: Colors.black87,
          child: SizedBox(
            width: double.infinity,
            child: BlocBuilder<MatchBloc, MatchState>(
              bloc: bloc..add(LoadMatchDetailsEvent()),
              builder: (context, state) {
                if (state is MatchLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is MatchDetailsState) {
                  return Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                          child: FittedBox(
                            child: Text(
                              "$fecha   |   Mejor de ${state.matchDetails?.data?.event?.match?.strategy?.count}",
                              style: GoogleFonts.anekDevanagari(
                                  color: Colors.white, fontSize: 20),
                            ),
                          )),
                      const Divider(
                        indent: 25,
                        endIndent: 25,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 3, 0, 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                children: [
                                  Text(
                                    state.matchDetails?.data?.event?.match!
                                            .teams!.first.name ??
                                        "",
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontFamily: "super_punch"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CachedNetworkImage(
                                      imageUrl: state.matchDetails?.data?.event
                                              ?.match!.teams!.first.image ??
                                          "",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 150,
                              child: Expanded(
                                  child: VerticalDivider(
                                color: Colors.white,
                              )),
                            ),
                            Expanded(
                              flex: 4,
                              child: Column(
                                children: [
                                  Text(
                                    state.matchDetails?.data?.event?.match!
                                            .teams!.last.name ??
                                        "",
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontFamily: "super_punch"),
                                  ),
                                  CachedNetworkImage(
                                    imageUrl: state.matchDetails?.data?.event
                                            ?.match!.teams!.last.image ??
                                        "",
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(75, 0, 75, 0),
                        child: Row(
                          children: [
                            Text(
                              state.matchDetails?.data?.event?.match!.teams!
                                      .first.result?.gameWins
                                      .toString() ??
                                  "",
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontFamily: "super_punch"),
                            ),
                            const Spacer(),
                            const Text(
                              "-",
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontFamily: "super_punch"),
                            ),
                            const Spacer(),
                            Text(
                              state.matchDetails?.data?.event?.match!.teams!
                                      .last.result?.gameWins
                                      .toString() ??
                                  "",
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontFamily: "super_punch"),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        indent: 25,
                        endIndent: 25,
                        color: Colors.white,
                      )
                    ],
                  );
                } else {
                  return const Center(
                    child: Text("Error al cargar la partida"),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
