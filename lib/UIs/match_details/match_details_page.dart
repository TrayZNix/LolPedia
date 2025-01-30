import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lolpedia/BLOCS/match_data_bloc/match_detail_bloc.dart';
import 'package:lolpedia/BLOCS/match_details_bloc/match_bloc.dart';
import 'package:lolpedia/dinamic_general_variables.dart';
import 'package:lolpedia/models/items_interface.dart';
import 'package:lolpedia/models/match_data_details_interface.dart';
import 'package:lolpedia/models/match_data_window_interface.dart';
import 'package:lolpedia/models/match_details_interface.dart';
import 'package:url_launcher/url_launcher.dart';

class MatchDetailsPage extends StatelessWidget {
  final String matchId;
  final String fecha;

  const MatchDetailsPage({
    super.key,
    required this.matchId,
    required this.fecha,
  });

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
              foregroundColor: Colors.white,
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
                child: Container(color: Colors.orange, height: 4.0),
              ),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (state is MatchDataState) {
          String gameOneState =
              (state.matchDetails?.data?.event?.match?.games?.first.state ??
                  "");
          final Streams? stream;
          stream =
              state.matchDetails?.data?.event?.streams?.isNotEmpty == true
                  ? state.matchDetails!.data!.event!.streams!
                      .where((element) => element.locale!.contains("es-ES"))
                      // ignore: sdk_version_since
                      .firstOrNull
                  : null;
          stream == null
              ? state.matchDetails!.data!.event!.streams!
                  .where((element) => element.locale!.contains("en-US"))
                  // ignore: sdk_version_since
                  .firstOrNull
              : null;

          int strategy =
              state.matchDetails?.data?.event?.match?.strategy?.count ?? -1;
          int blueTeamGameWins =
              state
                  .matchDetails
                  ?.data
                  ?.event
                  ?.match
                  ?.teams
                  ?.first
                  .result
                  ?.gameWins ??
              -1;
          int redTeamGameWins =
              state
                  .matchDetails
                  ?.data
                  ?.event
                  ?.match
                  ?.teams
                  ?.last
                  .result
                  ?.gameWins ??
              -1;
          return Scaffold(
            backgroundColor: Colors.grey[800],
            appBar: AppBar(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
              title: Row(
                children: [
                  const Text(
                    "LOLPEDIA",
                    style: TextStyle(fontFamily: "super_punch", fontSize: 40),
                  ),
                  const Spacer(),
                  (stream?.provider == "twitch")
                      ? InkWell(
                        onTap: () {
                          if (stream != null) {
                            launchUrl(
                              Uri.parse(
                                "https://www.twitch.tv/${stream.parameter}",
                              ),
                            );
                          }
                        },
                        child: const Card(
                          color: Color.fromARGB(255, 169, 112, 255),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [FaIcon(FontAwesomeIcons.twitch)],
                            ),
                          ),
                        ),
                      )
                      : Container(),
                ],
              ),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: Container(color: Colors.orange, height: 4.0),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: RefreshIndicator(
                  onRefresh: () async {
                    bloc.add(LoadMatchEvent());
                  },
                  child: SingleChildScrollView(
                    child: Card(
                      color: Colors.black87,
                      child: SizedBox(
                        width: double.infinity,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                child: FittedBox(
                                  child: Text(
                                    "$fecha   |   Mejor de ${state.matchDetails?.data?.event?.match?.strategy?.count}",
                                    style: GoogleFonts.anekDevanagari(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(
                                indent: 25,
                                endIndent: 25,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  0,
                                  3,
                                  0,
                                  15.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FittedBox(
                                                child: Text(
                                                  ("${state.matchDetails?.data?.event?.match!.teams!.first.name} ${(strategy == 5
                                                      ? (blueTeamGameWins == 3 ? "👑" : "")
                                                      : strategy == 3
                                                      ? (blueTeamGameWins == 2 ? "👑" : "")
                                                      : strategy == 1
                                                      ? (blueTeamGameWins == 1 ? "👑" : "")
                                                      : "")}"),
                                                  softWrap: true,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 23,
                                                    fontFamily: "super_punch",
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width /
                                                  2.7,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    state
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FittedBox(
                                                child: Text(
                                                  ("${state.matchDetails?.data?.event?.match!.teams!.last.name} ${(strategy == 5
                                                      ? (redTeamGameWins == 3 ? "👑" : "")
                                                      : strategy == 3
                                                      ? (redTeamGameWins == 2 ? "👑" : "")
                                                      : strategy == 1
                                                      ? (redTeamGameWins == 1 ? "👑" : "")
                                                      : "")}"),
                                                  softWrap: true,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 23,
                                                    fontFamily: "super_punch",
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width /
                                                  2.7,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    state
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
                                padding: const EdgeInsets.fromLTRB(
                                  75,
                                  0,
                                  75,
                                  0,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      state
                                              .matchDetails
                                              ?.data
                                              ?.event
                                              ?.match!
                                              .teams!
                                              .first
                                              .result
                                              ?.gameWins
                                              .toString() ??
                                          "",
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontFamily: "super_punch",
                                      ),
                                    ),
                                    const Spacer(),
                                    const Text(
                                      "-",
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontFamily: "super_punch",
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      state
                                              .matchDetails
                                              ?.data
                                              ?.event
                                              ?.match!
                                              .teams!
                                              .last
                                              .result
                                              ?.gameWins
                                              .toString() ??
                                          "",
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontFamily: "super_punch",
                                      ),
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
                                    currentMatchPlayed:
                                        ((state
                                                    .matchDetails
                                                    ?.data
                                                    ?.event
                                                    ?.match!
                                                    .teams!
                                                    .first
                                                    .result
                                                    ?.gameWins ??
                                                0) +
                                            (state
                                                    .matchDetails
                                                    ?.data
                                                    ?.event
                                                    ?.match!
                                                    .teams!
                                                    .last
                                                    .result
                                                    ?.gameWins ??
                                                0)),
                                    games:
                                        state
                                            .matchDetails
                                            ?.data
                                            ?.event
                                            ?.match
                                            ?.games,
                                    strategy:
                                        state
                                            .matchDetails
                                            ?.data
                                            ?.event
                                            ?.match
                                            ?.strategy
                                            ?.count ??
                                        1,
                                  )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Text("Error al cargar");
        }
      },
    );
  }
}

// ignore: must_be_immutable
class MatchData extends StatefulWidget {
  int currentMatchPlayed;
  List<Game>? games;
  int strategy;

  MatchData({
    super.key,
    required this.currentMatchPlayed,
    required this.games,
    required this.strategy,
  });

  @override
  State<StatefulWidget> createState() => MatchDataWidgetState();
}

class MatchDataWidgetState extends State<MatchData> {
  int selectedGame = 1;
  int gameQuantity = 0;
  @override
  void initState() {
    super.initState();
    gameQuantity =
        widget.games
            ?.where(
              (element) =>
                  (element.state != 'unstarted') &&
                  (element.state != 'unneeded'),
            )
            .length ??
        0;
    selectedGame = gameQuantity;
  }

  void changeGame(int gameNumber) {
    if (gameQuantity >= gameNumber) {
      setState(() {
        selectedGame = gameNumber;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MatchDetailBloc bloc = MatchDetailBloc(widget.games ?? [], selectedGame, 0);
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
                    HapticFeedback.mediumImpact();
                  },
                  splashFactory: NoSplash.splashFactory,
                  child: Card(
                    color:
                        gameQuantity >= 1
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
                          style: GoogleFonts.anekDevanagari(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    changeGame(2);
                    HapticFeedback.mediumImpact();
                  },
                  splashFactory: NoSplash.splashFactory,
                  child: Card(
                    color:
                        gameQuantity >= 2
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
                          style: GoogleFonts.anekDevanagari(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    changeGame(3);
                    HapticFeedback.mediumImpact();
                  },
                  splashFactory: NoSplash.splashFactory,
                  child: Card(
                    color:
                        gameQuantity >= 3
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
                          style: GoogleFonts.anekDevanagari(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    changeGame(4);
                    HapticFeedback.mediumImpact();
                  },
                  splashFactory: NoSplash.splashFactory,
                  child: Card(
                    color:
                        gameQuantity >= 4
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
                          style: GoogleFonts.anekDevanagari(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    changeGame(5);
                    HapticFeedback.mediumImpact();
                  },
                  splashFactory: NoSplash.splashFactory,
                  child: Card(
                    color:
                        gameQuantity >= 5
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
                          style: GoogleFonts.anekDevanagari(
                            color: Colors.white,
                          ),
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
                child: SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: BlocBuilder<
                      MatchDetailBloc,
                      OriginalMatchDetailsState
                    >(
                      bloc: bloc..add(LoadMatchDetailsEvent()),
                      builder: (context, state) {
                        if (state is MatchDetailLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is MatchDetailsState) {
                          Future.delayed(const Duration(seconds: 8)).then(
                            (va) => {bloc.add(RecargarDetallesPartidoEvent())},
                          );
                          return Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        bloc.currentDetailIndex = 0;
                                        bloc.add(ChangeDetailsTabEvent());
                                        HapticFeedback.lightImpact();
                                      },
                                      child: Card(
                                        color:
                                            bloc.currentDetailIndex == 0
                                                ? Colors.deepOrange
                                                : Colors.orangeAccent,
                                        child: SizedBox(
                                          width: 80,
                                          height: 20,
                                          child: Center(
                                            child: Text(
                                              "General",
                                              style: GoogleFonts.anekDevanagari(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        bloc.currentDetailIndex = 1;
                                        bloc.add(ChangeDetailsTabEvent());
                                        HapticFeedback.lightImpact();
                                      },
                                      child: Card(
                                        color:
                                            bloc.currentDetailIndex == 1
                                                ? Colors.deepOrange
                                                : Colors.orangeAccent,
                                        child: SizedBox(
                                          width: 80,
                                          height: 20,
                                          child: Center(
                                            child: Text(
                                              "Estadisticas",
                                              style: GoogleFonts.anekDevanagari(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              bloc.currentDetailIndex == 0
                                  ? GeneralTabWidget(
                                    matchDetails: state.matchDetails!,
                                    matchDetailsWindows:
                                        state.matchDetailsWindows!,
                                  )
                                  : bloc.currentDetailIndex == 1
                                  ? StatsTabWidget(
                                    matchDetails: state.matchDetails!,
                                    matchDetailsWindows:
                                        state.matchDetailsWindows!,
                                    bloc: bloc,
                                  )
                                  : Container(),
                            ],
                          );
                        } else {
                          return const Center(
                            child: FaIcon(
                              Icons.sentiment_very_dissatisfied_outlined,
                            ),
                          );
                        }
                      },
                    ),
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

class GeneralTabWidget extends StatelessWidget {
  final MatchDetailsWindowInterface matchDetailsWindows;
  final MatchDetailsInterface matchDetails;

  const GeneralTabWidget({
    super.key,
    required this.matchDetails,
    required this.matchDetailsWindows,
  });

  @override
  Widget build(BuildContext context) {
    DynamicGeneralVariables genVars = GetIt.I.get<DynamicGeneralVariables>();
    List<Widget> topLane = [];
    List<Widget> jlg = [];
    List<Widget> mid = [];
    List<Widget> bot = [];
    List<Widget> support = [];
    int index = 0;
    for (ParticipantMetadata part
        in matchDetailsWindows
            .gameMetadata
            .blueTeamMetadata
            .participantMetadata) {
      ParticipantData details = matchDetails.frames.last.participants
          .singleWhere(
            (element) => element.participantId == part.participantId,
          );
      index++;
      List<Widget> itemWidgetRow1 = [];
      List<Widget> itemWidgetRow2 = [];

      int controlWardsQuantity =
          details.items.where((element) => element == 2055).length;
      if (controlWardsQuantity != 0) {
        details.items.removeWhere((element) => element == 2055);
        details.items.add(2055);
      }
      int potionsQuantity =
          details.items.where((element) => element == 2003).length;
      if (potionsQuantity != 0) {
        details.items.removeWhere((element) => element == 2003);
        details.items.add(2003);
      }
      details.items.removeWhere(
        (element) =>
            (element == 3364) ||
            (element == 3340) ||
            (element == 3363) ||
            (element == 2140) ||
            (element == 2139) ||
            (element == 2138),
      );
      for (var i = 0; i < details.items.length; i++) {
        int valor = details.items[i];
        if (valor != 0) {
          Widget itemImage = CachedNetworkImage(
            height: 25,
            width: 25,
            fit: BoxFit.scaleDown,
            errorWidget: (context, url, error) {
              return Container(color: Colors.transparent);
            },
            imageUrl:
                "http://ddragon.leagueoflegends.com/cdn/${genVars.versionActual}/img/item/$valor.png",
          );
          if (valor == 2055) {
            itemImage = Stack(
              fit: StackFit.passthrough,
              alignment: Alignment.bottomRight,
              children: [
                CachedNetworkImage(
                  height: 25,
                  width: 25,
                  fit: BoxFit.scaleDown,
                  errorWidget: (context, url, error) {
                    return Container(color: Colors.transparent);
                  },
                  imageUrl:
                      "http://ddragon.leagueoflegends.com/cdn/${genVars.versionActual}/img/item/$valor.png",
                ),
                if (controlWardsQuantity > 1)
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(
                      controlWardsQuantity.toString(),
                      style: GoogleFonts.anekDevanagari(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            );
          }
          if (valor == 2003) {
            itemImage = Stack(
              fit: StackFit.passthrough,
              alignment: Alignment.bottomRight,
              children: [
                CachedNetworkImage(
                  height: 25,
                  width: 25,
                  fit: BoxFit.scaleDown,
                  errorWidget: (context, url, error) {
                    return Container(color: Colors.transparent);
                  },
                  imageUrl:
                      "http://ddragon.leagueoflegends.com/cdn/${genVars.versionActual}/img/item/$valor.png",
                ),
                if (potionsQuantity > 1)
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(
                      potionsQuantity.toString(),
                      style: GoogleFonts.anekDevanagari(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            );
          }
          (i) < 3
              ? itemWidgetRow1.add(itemImage)
              : itemWidgetRow2.add(itemImage);
        }
      }
      Widget itemWidget = Container(
        height: 68,
        width: 93,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(5.0), //
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: itemWidgetRow1,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: itemWidgetRow2,
            ),
          ],
        ),
      );

      Widget widget = Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          part.summonerName ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: GoogleFonts.anekDevanagari(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CachedNetworkImage(
                        height: 45,
                        width: 45,
                        fit: BoxFit.scaleDown,
                        imageUrl:
                            "http://ddragon.leagueoflegends.com/cdn/${genVars.versionActual}/img/champion/${part.championId}.png",
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 4, 0),
                        child: Text(
                          details.level.toString(),
                          style: GoogleFonts.anekDevanagari(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            shadows: [
                              const Shadow(
                                color: Colors.black, // Color de la sombra
                                offset: Offset(
                                  2,
                                  2,
                                ), // Desplazamiento de la sombra (x, y)
                                blurRadius:
                                    5, // Radio de difuminado de la sombra
                              ),
                              const Shadow(
                                color: Colors.black, // Color de la sombra
                                offset: Offset(
                                  2,
                                  3,
                                ), // Desplazamiento de la sombra (x, y)
                                blurRadius:
                                    5, // Radio de difuminado de la sombra
                              ),
                            ],
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
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
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

    Widget widget = const SizedBox(height: 125, child: VerticalDivider());

    topLane.add(widget);
    jlg.add(widget);
    mid.add(widget);
    bot.add(widget);
    support.add(widget);

    for (ParticipantMetadata part
        in matchDetailsWindows
            .gameMetadata
            .redTeamMetadata
            .participantMetadata) {
      ParticipantData details = matchDetails.frames.last.participants
          .singleWhere(
            (element) => element.participantId == part.participantId,
          );
      index++;

      List<Widget> itemWidgetRow1 = [];
      List<Widget> itemWidgetRow2 = [];
      int controlWardsQuantity =
          details.items.where((element) => element == 2055).length;
      if (controlWardsQuantity != 0) {
        details.items.removeWhere((element) => element == 2055);
        details.items.add(2055);
      }

      int potionsQuantity =
          details.items.where((element) => element == 2003).length;
      if (potionsQuantity != 0) {
        details.items.removeWhere((element) => element == 2003);
        details.items.add(2003);
      }

      details.items.removeWhere(
        (element) =>
            (element == 3364) ||
            (element == 3340) ||
            (element == 3363) ||
            (element == 2138) ||
            (element == 2139) ||
            (element == 2140),
      );
      for (var i = 0; i < details.items.length; i++) {
        int valor = details.items[i];
        if (valor != 0) {
          Widget itemImage = CachedNetworkImage(
            height: 25,
            width: 25,
            fit: BoxFit.scaleDown,
            errorWidget: (context, url, error) {
              return Container(color: Colors.transparent);
            },
            imageUrl:
                "http://ddragon.leagueoflegends.com/cdn/${genVars.versionActual}/img/item/$valor.png",
          );
          if (valor == 2055) {
            itemImage = Stack(
              fit: StackFit.passthrough,
              alignment: Alignment.bottomRight,
              children: [
                CachedNetworkImage(
                  height: 25,
                  width: 25,
                  fit: BoxFit.scaleDown,
                  errorWidget: (context, url, error) {
                    return Container(color: Colors.transparent);
                  },
                  imageUrl:
                      "http://ddragon.leagueoflegends.com/cdn/${genVars.versionActual}/img/item/$valor.png",
                ),
                if (controlWardsQuantity > 1)
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(
                      controlWardsQuantity.toString(),
                      style: GoogleFonts.anekDevanagari(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            );
          }
          if (valor == 2003) {
            itemImage = Stack(
              fit: StackFit.passthrough,
              alignment: Alignment.bottomRight,
              children: [
                CachedNetworkImage(
                  height: 25,
                  width: 25,
                  fit: BoxFit.scaleDown,
                  errorWidget: (context, url, error) {
                    return Container(color: Colors.transparent);
                  },
                  imageUrl:
                      "http://ddragon.leagueoflegends.com/cdn/${genVars.versionActual}/img/item/$valor.png",
                ),
                if (potionsQuantity > 1)
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(
                      potionsQuantity.toString(),
                      style: GoogleFonts.anekDevanagari(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            );
          }
          (i) < 3
              ? itemWidgetRow1.add(itemImage)
              : itemWidgetRow2.add(itemImage);
        }
      }
      Widget itemWidget = Container(
        height: 68,
        width: 93,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(5.0), //
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: itemWidgetRow1,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: itemWidgetRow2,
            ),
          ],
        ),
      );

      Widget widget = Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    CachedNetworkImage(
                      height: 45,
                      width: 45,
                      fit: BoxFit.scaleDown,
                      imageUrl:
                          "http://ddragon.leagueoflegends.com/cdn/${genVars.versionActual}/img/champion/${part.championId}.png",
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 10, 0, 0),
                      child: Text(
                        details.level.toString(),
                        style: GoogleFonts.anekDevanagari(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          shadows: [
                            const Shadow(
                              color: Colors.black, // Color de la sombra
                              offset: Offset(
                                2,
                                3,
                              ), // Desplazamiento de la sombra (x, y)
                              blurRadius: 5, // Radio de difuminado de la sombra
                            ),
                            const Shadow(
                              color: Colors.black, // Color de la sombra
                              offset: Offset(
                                2,
                                3,
                              ), // Desplazamiento de la sombra (x, y)
                              blurRadius: 5, // Radio de difuminado de la sombra
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        part.summonerName ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.anekDevanagari(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
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

    ///////////////////////////////////////////////////
    /////////////         DRAGONS        //////////////
    ///////////////////////////////////////////////////

    List<Widget> redTeamDragons = [];
    List<Widget> blueTeamDragons = [];
    for (var dragon
        in matchDetailsWindows.frames.last.redTeam.dragons.reversed) {
      redTeamDragons.add(
        SizedBox(
          child: Image.asset(
            "assets/img/dragons/$dragon.png",
            scale: 1.75 - MediaQuery.of(context).size.width / 10000,
            fit: BoxFit.scaleDown,
          ),
        ),
      );
    }
    for (var dragon in matchDetailsWindows.frames.last.blueTeam.dragons) {
      blueTeamDragons.add(
        SizedBox(
          child: Image.asset(
            "assets/img/dragons/$dragon.png",
            scale: 1.75 - MediaQuery.of(context).size.width / 10000,
          ),
        ),
      );
    }
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("./assets/img/misc/gold.png"),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(3, 6, 0, 0),
                      child: Text(
                        matchDetailsWindows.frames.last.blueTeam.totalGold
                            .toString(),
                        style: GoogleFonts.anekDevanagari(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                  child: Text(
                    "Oro total",
                    style: GoogleFonts.anekDevanagari(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 6, 3, 0),
                      child: Text(
                        matchDetailsWindows.frames.last.redTeam.totalGold
                            .toString(),
                        style: GoogleFonts.anekDevanagari(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Image.asset("./assets/img/misc/gold.png"),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: blueTeamDragons),
                Row(children: redTeamDragons),
              ],
            ),
          ),
          const SizedBox(
            width: double.infinity,
            child: Divider(endIndent: 10, indent: 10, color: Colors.black),
          ),
          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: support,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatsTabWidget extends StatelessWidget {
  final MatchDetailsWindowInterface matchDetailsWindows;
  final MatchDetailsInterface matchDetails;
  final MatchDetailBloc bloc;

  const StatsTabWidget({
    super.key,
    required this.matchDetails,
    required this.matchDetailsWindows,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    DynamicGeneralVariables genVars = GetIt.I.get<DynamicGeneralVariables>();
    List<Widget> topLane = [];
    List<Widget> jlg = [];
    List<Widget> mid = [];
    List<Widget> bot = [];
    List<Widget> support = [];
    int index = 0;
    for (ParticipantMetadata part
        in matchDetailsWindows
            .gameMetadata
            .blueTeamMetadata
            .participantMetadata) {
      ParticipantData details = matchDetails.frames.last.participants
          .singleWhere(
            (element) => element.participantId == part.participantId,
          );
      index++;
      List<int> playerItems =
          matchDetails.frames.last.participants
              .firstWhere(
                (element) => element.participantId == part.participantId,
              )
              .items;

      List<Item> playerItemsDetailed =
          bloc.items.items.where((element) {
            return playerItems.contains(int.parse(element.id ?? "0"));
          }).toList();
      double letalidad = 0.0;
      double armorPen = 0.0;
      double tenacidad = 0.0;
      double lifesteal = 0.0;
      double magicPen = 0.0;
      for (var element in playerItemsDetailed) {
        letalidad += element.letalidad ?? 0.0;
        tenacidad += element.tenacity ?? 0;
        armorPen += element.armorPen ?? 0;
        magicPen += element.magicPen ?? 0;
        lifesteal += element.lifesteal ?? 0;
      }
      var extraArmorPen = letalidad * (0.6 + (0.4 * details.level / 18));
      armorPen = armorPen + extraArmorPen;

      Widget widget = Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          part.summonerName ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: GoogleFonts.anekDevanagari(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: CachedNetworkImage(
                    height: 45,
                    width: 45,
                    fit: BoxFit.scaleDown,
                    imageUrl:
                        "http://ddragon.leagueoflegends.com/cdn/${genVars.versionActual}/img/champion/${part.championId}.png",
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 1, 0, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset("assets/img/stats/health.png"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              matchDetailsWindows
                                  .frames
                                  .last
                                  .blueTeam
                                  .participants
                                  .firstWhere(
                                    (element) =>
                                        element.participantId ==
                                        part.participantId,
                                  )
                                  .maxHealth
                                  .toString(),
                              style: GoogleFonts.anekDevanagari(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 1, 0, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset(
                              "assets/img/stats/attack_damage.png",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              details.attackDamage.toString(),
                              style: GoogleFonts.anekDevanagari(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 1, 0, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset(
                              "assets/img/stats/ability_power.png",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              details.abilityPower.toString(),
                              style: GoogleFonts.anekDevanagari(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 1, 0, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset(
                              "assets/img/stats/magic_pen.png",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              magicPen.toString(),
                              style: GoogleFonts.anekDevanagari(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 1, 0, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset(
                              "assets/img/stats/attack_speed.png",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              (details.attackSpeed / 100).toString(),
                              style: GoogleFonts.anekDevanagari(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100, child: VerticalDivider()),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 1, 0, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset("assets/img/stats/tenacity.png"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              tenacidad.toString(),
                              style: GoogleFonts.anekDevanagari(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 1, 0, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset("assets/img/stats/armor.png"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              details.armor.toString(),
                              style: GoogleFonts.anekDevanagari(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 1, 0, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset(
                              "assets/img/stats/magic_resist.png",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              details.magicResistance.toString(),
                              style: GoogleFonts.anekDevanagari(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 1, 0, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset(
                              "assets/img/stats/armor_pen.png",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              "${armorPen.floorToDouble()}%",
                              style: GoogleFonts.anekDevanagari(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 1, 0, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset(
                              "assets/img/stats/life_steal.png",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              "${lifesteal.floor()}%",
                              style: GoogleFonts.anekDevanagari(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
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

    Widget widget = const SizedBox(height: 175, child: VerticalDivider());

    topLane.add(widget);
    jlg.add(widget);
    mid.add(widget);
    bot.add(widget);
    support.add(widget);

    for (ParticipantMetadata part
        in matchDetailsWindows
            .gameMetadata
            .redTeamMetadata
            .participantMetadata) {
      ParticipantData details = matchDetails.frames.last.participants
          .singleWhere(
            (element) => element.participantId == part.participantId,
          );
      index++;
      List<int> playerItems =
          matchDetails.frames.last.participants
              .firstWhere(
                (element) => element.participantId == part.participantId,
              )
              .items;

      List<Item> playerItemsDetailed =
          bloc.items.items.where((element) {
            return playerItems.contains(int.parse(element.id ?? "0"));
          }).toList();
      double letalidad = 0.0;
      double armorPen = 0.0;
      double tenacidad = 0.0;
      double lifesteal = 0.0;
      double magicPen = 0.0;
      for (var element in playerItemsDetailed) {
        letalidad += element.letalidad ?? 0.0;
        tenacidad += element.tenacity ?? 0;
        armorPen += element.armorPen ?? 0;
        magicPen += element.magicPen ?? 0;
        lifesteal += element.lifesteal ?? 0;
      }
      var extraArmorPen = letalidad * (0.6 + (0.4 * details.level / 18));
      armorPen = armorPen + extraArmorPen;

      Widget widget = Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: CachedNetworkImage(
                  height: 45,
                  width: 45,
                  fit: BoxFit.scaleDown,
                  imageUrl:
                      "http://ddragon.leagueoflegends.com/cdn/${genVars.versionActual}/img/champion/${part.championId}.png",
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        part.summonerName ?? "",
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.anekDevanagari(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 1, 0, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset("assets/img/stats/health.png"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              matchDetailsWindows
                                  .frames
                                  .last
                                  .redTeam
                                  .participants
                                  .firstWhere(
                                    (element) =>
                                        element.participantId ==
                                        part.participantId,
                                  )
                                  .maxHealth
                                  .toString(),
                              style: GoogleFonts.anekDevanagari(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 1, 0, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset(
                              "assets/img/stats/attack_damage.png",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              details.attackDamage.toString(),
                              style: GoogleFonts.anekDevanagari(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 1, 0, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset(
                              "assets/img/stats/ability_power.png",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              details.abilityPower.toString(),
                              style: GoogleFonts.anekDevanagari(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 1, 0, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset(
                              "assets/img/stats/magic_pen.png",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              magicPen.toString(),
                              style: GoogleFonts.anekDevanagari(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 1, 0, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset(
                              "assets/img/stats/attack_speed.png",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              (details.attackSpeed / 100).toString(),
                              style: GoogleFonts.anekDevanagari(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100, child: VerticalDivider()),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 1, 0, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset("assets/img/stats/tenacity.png"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              tenacidad.toString(),
                              style: GoogleFonts.anekDevanagari(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 1, 0, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset("assets/img/stats/armor.png"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              details.armor.toString(),
                              style: GoogleFonts.anekDevanagari(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 1, 0, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset(
                              "assets/img/stats/magic_resist.png",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              details.magicResistance.toString(),
                              style: GoogleFonts.anekDevanagari(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 1, 0, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset(
                              "assets/img/stats/armor_pen.png",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              "${armorPen.floorToDouble()}%",
                              style: GoogleFonts.anekDevanagari(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 1, 0, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset(
                              "assets/img/stats/life_steal.png",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              "${lifesteal.floor()}%",
                              style: GoogleFonts.anekDevanagari(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
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

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(
            width: double.infinity,
            child: Divider(endIndent: 10, indent: 10, color: Colors.black),
          ),
          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: support,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
