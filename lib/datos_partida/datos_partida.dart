import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol_pedia/datos_partida/bloc/datos_partida_bloc.dart';

class DatosPartida extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Row(children: [
          Text(
            "LOLPEDIA",
            style: TextStyle(fontFamily: "super_punch", fontSize: 40),
          )
        ]),
        centerTitle: true,
      ),
      body: BlocBuilder<DatosPartidaBloc, DatosPartidaState>(
        bloc: DatosPartidaBloc()..add(LoadClientApiData()),
        builder: (context, state) {
          print(state.clientApiData?.activePlayer.currentGold ?? "");
          return Text(
            "data",
            style: GoogleFonts.anekDevanagari(color: Colors.white),
          );
        },
      ),
    );
  }
}
