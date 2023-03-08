import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol_pedia/champion_details/champion_details.dart';
import 'package:lol_pedia/homepage/bloc/homepage_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:animations/animations.dart';
import 'package:lol_pedia/models/champion.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});
  final HomepageBloc bloc = HomepageBloc()..add(LoadChampions());

  void filtrarCampeones(String filtro) {
    bloc.filter = filtro;
    bloc.add(FilterLoadedChampions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBarConBusqueda(
        bloc: bloc,
        filtrarCampeones: filtrarCampeones,
      ),
      body: BlocBuilder<HomepageBloc, HomepageState>(
        bloc: bloc,
        builder: (context, state) {
          return state is HomepageLoading
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
                            children: List.generate(state.filteredChamps.length,
                                (index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ChampionDetails(
                                        championName:
                                            state.filteredChamps[index].id ??
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
                                      errorWidget: (context, url, error) =>
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
                              );
                            }));
                      },
                    )
                  : const Center(
                      child: Text("Error loading the champions"),
                    );
        },
      ),
    );
  }
}

class AppBarConBusqueda extends StatefulWidget implements PreferredSizeWidget {
  final ValueChanged<String> filtrarCampeones;
  AppBarConBusqueda(
      {super.key, required this.bloc, required this.filtrarCampeones});
  final HomepageBloc bloc;
  var estaBuscando = false;

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => AppBarConBusquedaState(bloc);
  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);
}

class AppBarConBusquedaState extends State<AppBarConBusqueda> {
  AppBarConBusquedaState(this.bloc);
  final HomepageBloc bloc;
  final myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    myFocusNode.requestFocus();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

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
                      widget.filtrarCampeones(controller.text);
                    },
                    controller: controller,
                    focusNode: myFocusNode,
                    style: GoogleFonts.anekDevanagari(color: Colors.white),
                    decoration: InputDecoration(
                        disabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.white),
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
                      widget.filtrarCampeones("");
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
