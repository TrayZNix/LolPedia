import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol_pedia/BLOCS/match_data_bloc/match_detail_bloc.dart';
import 'package:lol_pedia/BLOCS/match_details_bloc/match_bloc.dart';
import 'package:lol_pedia/dinamic_general_variables.dart';
import 'package:lol_pedia/models/match_data_details_interface.dart';
import 'package:lol_pedia/models/match_data_window_interface.dart';

class MatchDetailsPage extends StatelessWidget {
  final String matchId;
  final String fecha;

  const MatchDetailsPage(
      {super.key, required this.matchId, required this.fecha});

  @override
  Widget build(BuildContext context) {
    MatchBloc bloc = MatchBloc(matchId);
    return BlocBuilder<MatchBloc, MatchState>(
      bloc: bloc..add(LoadMatchEvent()),
      builder: (context, state) {
        if (state is MatchLoading) {
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
              body: const Center(
                child: CircularProgressIndicator(),
              ));
        } else if (state is MatchDataState) {
          String gameOneState =
              (state.matchDetails?.data?.event?.match?.games?.first.state ??
                  "");
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
                  Card(
                    color: Colors.red,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          FaIcon(FontAwesomeIcons.youtube),
                        ],
                      ),
                    ),
                  )
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
                    child: SingleChildScrollView(
                      child: Column(
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
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.7,
                                          child: CachedNetworkImage(
                                            imageUrl: state
                                                    .matchDetails
                                                    ?.data
                                                    ?.event
                                                    ?.match!
                                                    .teams!
                                                    .first
                                                    .image ??
                                                "",
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 150,
                                  child: VerticalDivider(
                                    color: Colors.white,
                                  ),
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
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.7,
                                          child: CachedNetworkImage(
                                            imageUrl: state
                                                    .matchDetails
                                                    ?.data
                                                    ?.event
                                                    ?.match!
                                                    .teams!
                                                    .last
                                                    .image ??
                                                "",
                                            fit: BoxFit.contain,
                                          ),
                                        ),
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
                          ),
                          (gameOneState == "inProgress" ||
                                  gameOneState == "completed")
                              ? MatchData(
                                  currentMatchPlayed: ((state
                                              .matchDetails
                                              ?.data
                                              ?.event
                                              ?.match!
                                              .teams!
                                              .first
                                              .result
                                              ?.gameWins ??
                                          0) +
                                      (state.matchDetails?.data?.event?.match!
                                              .teams!.last.result?.gameWins ??
                                          0)),
                                  matchId: matchId,
                                  strategy: state.matchDetails?.data?.event
                                          ?.match?.strategy?.count ??
                                      1)
                              : Container()
                        ],
                      ),
                    )),
              ),
            ),
          );
        } else {
          return Text("Error al cargar");
        }
      },
    );
  }
}

class MatchData extends StatefulWidget {
  int currentMatchPlayed;
  String matchId;
  int strategy;

  MatchData(
      {super.key,
      required this.currentMatchPlayed,
      required this.matchId,
      required this.strategy});

  @override
  State<StatefulWidget> createState() => MatchDataWidgetState();
}

class MatchDataWidgetState extends State<MatchData> {
  int selectedGame = 1;
  @override
  void initState() {
    super.initState();
    selectedGame = widget.currentMatchPlayed;
  }

  void changeGame(int gameNumber) {
    if (widget.currentMatchPlayed >= gameNumber) {
      setState(() {
        selectedGame = gameNumber;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MatchDetailBloc bloc = MatchDetailBloc(widget.matchId, selectedGame);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    changeGame(1);
                  },
                  splashFactory: NoSplash.splashFactory,
                  child: Card(
                    color: widget.currentMatchPlayed >= 1
                        ? (selectedGame == 1
                            ? Colors.deepOrange
                            : Colors.orangeAccent)
                        : Colors.grey,
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: Text(
                          "1",
                          style:
                              GoogleFonts.anekDevanagari(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    changeGame(2);
                  },
                  splashFactory: NoSplash.splashFactory,
                  child: Card(
                    color: widget.currentMatchPlayed >= 2
                        ? (selectedGame == 2
                            ? Colors.deepOrange
                            : Colors.orangeAccent)
                        : Colors.grey,
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: Text(
                          "2",
                          style:
                              GoogleFonts.anekDevanagari(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    changeGame(3);
                  },
                  splashFactory: NoSplash.splashFactory,
                  child: Card(
                    color: widget.currentMatchPlayed >= 3
                        ? (selectedGame == 3
                            ? Colors.deepOrange
                            : Colors.orangeAccent)
                        : Colors.grey,
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: Text(
                          "3",
                          style:
                              GoogleFonts.anekDevanagari(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    changeGame(4);
                  },
                  splashFactory: NoSplash.splashFactory,
                  child: Card(
                    color: widget.currentMatchPlayed >= 4
                        ? (selectedGame == 4
                            ? Colors.deepOrange
                            : Colors.orangeAccent)
                        : Colors.grey,
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: Text(
                          "4",
                          style:
                              GoogleFonts.anekDevanagari(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    changeGame(5);
                  },
                  splashFactory: NoSplash.splashFactory,
                  child: Card(
                    color: widget.currentMatchPlayed >= 5
                        ? (selectedGame == 5
                            ? Colors.deepOrange
                            : Colors.orangeAccent)
                        : Colors.grey,
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: Text(
                          "5",
                          style:
                              GoogleFonts.anekDevanagari(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Card(
            color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                width: double.infinity,
                height: 850,
                child: Center(
                  child:
                      BlocBuilder<MatchDetailBloc, OriginalMatchDetailsState>(
                    bloc: bloc..add(LoadMatchDetailsEvent()),
                    builder: (context, state) {
                      if (state is MatchDetailLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is MatchDetailsState) {
                        Future.delayed(const Duration(seconds: 2)).then(
                            (va) => {bloc.add(RecargarDetallesPartidoEvent())});
                        DynamicGeneralVariables genVars =
                            GetIt.I.get<DynamicGeneralVariables>();
                        List<Widget> topLane = [];
                        List<Widget> jlg = [];
                        List<Widget> mid = [];
                        List<Widget> bot = [];
                        List<Widget> support = [];
                        int index = 0;
                        for (ParticipantMetadata part in state
                                .matchDetailsWindows
                                ?.gameMetadata
                                .blueTeamMetadata
                                .participantMetadata ??
                            []) {
                          ParticipantData details = state
                              .matchDetails!.frames.last.participants
                              .where((element) =>
                                  element.participantId == part.participantId)
                              .first;
                          index++;

                          List<Widget> itemWidgetRow1 = [];
                          List<Widget> itemWidgetRow2 = [];

                          int skippedNumber = 0;
                          for (var i = 0; i < 6; i++) {
                            int index = i + skippedNumber;
                            int valor = 0;
                            do {
                              try {
                                valor = details.items[index];
                              } catch (_) {}
                              if (valor == 3340 ||
                                  valor == 3364 ||
                                  valor == 3363) {
                                index++;
                                skippedNumber++;
                              }
                            } while (valor == 3340 ||
                                valor == 3364 ||
                                valor == 3363);
                            Widget itemImage = CachedNetworkImage(
                                height: 25,
                                width: 25,
                                fit: BoxFit.scaleDown,
                                errorWidget: (context, url, error) {
                                  return Container(color: Colors.transparent);
                                },
                                imageUrl:
                                    "http://ddragon.leagueoflegends.com/cdn/${genVars.versionActual}/img/item/${valor}.png");
                            (i) < 3
                                ? itemWidgetRow1.add(itemImage)
                                : itemWidgetRow2.add(itemImage);
                          }
                          Widget itemWidget = Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(5.0), //
                            ),
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: itemWidgetRow1,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: itemWidgetRow2,
                                )
                              ],
                            ),
                          );

                          Widget widget = Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CachedNetworkImage(
                                      height: 45,
                                      width: 45,
                                      fit: BoxFit.scaleDown,
                                      imageUrl:
                                          "http://ddragon.leagueoflegends.com/cdn/${genVars.versionActual}/img/champion/${part.championId}.png"),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(6, 0, 0, 0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              part.summonerName ?? "",
                                              style: GoogleFonts.anekDevanagari(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(details.kills.toString()),
                                            const Text("/"),
                                            Text(details.deaths.toString()),
                                            const Text("/"),
                                            Text(details.assists.toString()),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [itemWidget],
                                ),
                              ),
                            ],
                          );
                          index == 1
                              ? topLane.add(widget)
                              : index == 2
                                  ? jlg.add(widget)
                                  : index == 3
                                      ? mid.add(widget)
                                      : index == 4
                                          ? bot.add(widget)
                                          : support.add(widget);
                        }
                        index = 0;
                        for (ParticipantMetadata part in state
                                .matchDetailsWindows
                                ?.gameMetadata
                                .redTeamMetadata
                                .participantMetadata ??
                            []) {
                          ParticipantData details = state
                              .matchDetails!.frames.last.participants
                              .where((element) =>
                                  element.participantId == part.participantId)
                              .first;

                          int itemIndex = 0;
                          List<Widget> itemWidgetRow1 = [];
                          List<Widget> itemWidgetRow2 = [];
                          int skippedNumber = 0;
                          for (var i = 0; i < details.items.length; i++) {
                            int index = i + skippedNumber;
                            int valor = 0;
                            do {
                              try {
                                valor = details.items[index];
                              } catch (_) {}
                              if (valor == 3340 ||
                                  valor == 3364 ||
                                  valor == 3363) {
                                index++;
                                skippedNumber++;
                              }
                            } while ((valor == 3340 ||
                                    valor == 3364 ||
                                    valor == 3363) &&
                                index <= details.items.length);
                            if (valor != 0) {
                              Widget itemImage = CachedNetworkImage(
                                  height: 25,
                                  width: 25,
                                  fit: BoxFit.scaleDown,
                                  errorWidget: (context, url, error) {
                                    print(url);
                                    return Container(color: Colors.transparent);
                                  },
                                  imageUrl:
                                      "http://ddragon.leagueoflegends.com/cdn/${genVars.versionActual}/img/item/${valor}.png");
                              (i) < 3
                                  ? itemWidgetRow1.add(itemImage)
                                  : itemWidgetRow2.add(itemImage);
                            }
                          }
                          Widget itemWidget = Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(5.0), //
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: itemWidgetRow1,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: itemWidgetRow2,
                                )
                              ],
                            ),
                          );

                          index++;
                          Widget widget = Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 6, 0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Text(part.summonerName ?? "",
                                                style:
                                                    GoogleFonts.anekDevanagari(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(details.kills.toString()),
                                            const Text("/"),
                                            Text(details.deaths.toString()),
                                            const Text("/"),
                                            Text(details.assists.toString()),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  CachedNetworkImage(
                                      height: 45,
                                      width: 45,
                                      fit: BoxFit.scaleDown,
                                      imageUrl:
                                          "http://ddragon.leagueoflegends.com/cdn/${genVars.versionActual}/img/champion/${part.championId}.png"),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [itemWidget],
                                ),
                              )
                            ],
                          );
                          index == 1
                              ? topLane.add(widget)
                              : index == 2
                                  ? jlg.add(widget)
                                  : index == 3
                                      ? mid.add(widget)
                                      : index == 4
                                          ? bot.add(widget)
                                          : support.add(widget);
                        }

                        ///////////////////////////////////////////////////
                        /////////////         DRAGONS        //////////////
                        ///////////////////////////////////////////////////
                        List<Widget> redTeamDragons = [];
                        List<Widget> blueTeamDragons = [];
                        for (var dragon in state.matchDetailsWindows!.frames
                            .first.redTeam.dragons.reversed) {
                          redTeamDragons.add(SizedBox(
                              child: Image.asset(
                            "assets/img/dragons/$dragon.png",
                            scale: MediaQuery.of(context).size.width / 300,
                            fit: BoxFit.scaleDown,
                          )));
                        }
                        for (var dragon in state.matchDetailsWindows!.frames
                            .first.blueTeam.dragons) {
                          blueTeamDragons.add(SizedBox(
                              child: Image.asset(
                            "assets/img/dragons/$dragon.png",
                            scale: MediaQuery.of(context).size.width / 300,
                          )));
                        }
                        return SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: blueTeamDragons,
                                    ),
                                    Row(
                                      children: redTeamDragons,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: double.infinity,
                                child: Divider(
                                  endIndent: 10,
                                  indent: 10,
                                  color: Colors.black,
                                ),
                              ),
                              SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: topLane,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: double.infinity,
                                      child: Divider(
                                        endIndent: 10,
                                        indent: 10,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: jlg,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: double.infinity,
                                      child: Divider(
                                        endIndent: 10,
                                        indent: 10,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: mid,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: double.infinity,
                                      child: Divider(
                                        endIndent: 10,
                                        indent: 10,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: bot,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: double.infinity,
                                      child: Divider(
                                        endIndent: 10,
                                        indent: 10,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: support,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const Center(
                          child: FaIcon(
                              Icons.sentiment_very_dissatisfied_outlined),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
