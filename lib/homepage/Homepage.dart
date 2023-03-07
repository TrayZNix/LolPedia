import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol_pedia/champion_details/champion_details.dart';
import 'package:lol_pedia/homepage/bloc/homepage_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:animations/animations.dart';
import 'package:lol_pedia/models/champion.dart';


class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<StatefulWidget> createState() => HomepageWidgetState();
}

class HomepageWidgetState extends State<Homepage> {
  late List<Datum> campeones = [];

  String _text = "";

  void setCampeones(String filtro) {
    setState(() {
      _text = filtro;
      print(filtro);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomepageBloc(),
      child: BlocBuilder<HomepageBloc, HomepageState>(
        bloc: HomepageBloc()..add(LoadChampions()),
        builder: (context, state) {
          campeones = state.champions
              .where((element) =>
                  element.name.toLowerCase().contains(_text.toLowerCase()))
              .toList();
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBarConBusqueda(
              setCampeones: setCampeones,
              bloc: BlocProvider.of<HomepageBloc>(context),
              state: state,
            ),
            body: state is HomepageLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : state.status == HomepageStatus.success
                    ? Builder(
                        builder: (context) {
                          return GridView.count(
                              crossAxisCount: 3,
                              childAspectRatio: 1,
                              physics: const AlwaysScrollableScrollPhysics(),
                              children:
                                  List.generate(campeones.length, (index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ChampionDetails(
                                          championName:
                                              campeones[index].id ?? "");
                                    }));
                                  },
                                  child: Stack(
                                    children: [
                                      Center(
                                          child: CachedNetworkImage(
                                        imageUrl:
                                            "http://ddragon.leagueoflegends.com/cdn/13.4.1/img/champion/${campeones[index].image!.full}",
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
                                          campeones[index].name,
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
                        },
                      )
                    : const Center(
                        child: Text("Error loading the champions"),
                      ),
          );
        },
      ),
    );
  }
}

class AppBarConBusqueda extends StatefulWidget implements PreferredSizeWidget {
  final ValueChanged<String> setCampeones;

  AppBarConBusqueda(
      {super.key,
      required this.bloc,
      required this.state,
      required this.setCampeones});
  final HomepageBloc bloc;
  final HomepageState state;
  bool estaBuscando = false;

  @override
  State<StatefulWidget> createState() => AppBarConBusquedaState();
  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);
}

class AppBarConBusquedaState extends State<AppBarConBusqueda> {
  AppBarConBusquedaState();

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return (!widget.estaBuscando)
        ? AppBar(
            backgroundColor: Colors.black,
            title: Row(
              children: [
                const Text(
                  "LOLPEDIA",
                  style: TextStyle(fontFamily: "super_punch", fontSize: 40),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        widget.estaBuscando = !widget.estaBuscando;
                      });
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ))
              ],
            ),
            centerTitle: true,
          )
        : AppBar(
            backgroundColor: Colors.black,
            title: Row(
              children: [
                Expanded(
                  flex: 10,
                  child: TextField(
                    onChanged: (value) {
                      widget.setCampeones(controller.text);
                    },
                    controller: controller,
                    style: GoogleFonts.anekDevanagari(color: Colors.white),
                    decoration: InputDecoration(
                        disabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        prefixIcon: const Icon(Icons.search),
                        hintText: "Nombre de campeón",
                        labelStyle:
                            GoogleFonts.anekDevanagari(color: Colors.white),
                        errorStyle:
                            GoogleFonts.anekDevanagari(color: Colors.red),
                        floatingLabelStyle:
                            GoogleFonts.anekDevanagari(color: Colors.white),
                        hintStyle:
                            GoogleFonts.anekDevanagari(color: Colors.white),
                        border: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        widget.estaBuscando = !widget.estaBuscando;
                      });
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ))
              ],
            ),
            centerTitle: true,
          );
  }
}
