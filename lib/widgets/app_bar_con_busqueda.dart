import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../BLOCS/homepage_bloc/homepage_bloc.dart';

//ignore: must_be_immutable
class AppBarConBusqueda extends StatefulWidget implements PreferredSizeWidget {
  final ValueChanged<String>? funcionFiltrado;
  AppBarConBusqueda(
      {super.key,
      required this.bloc,
      required this.placeholderText,
      this.funcionFiltrado,
      required this.integratedSearch});
  final HomepageBloc bloc;
  late bool integratedSearch = false;
  final String placeholderText;
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
                widget.integratedSearch
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            widget.estaBuscando = !widget.estaBuscando;
                          });
                        },
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ))
                    : Container()
              ],
            ),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4.0),
              child: Container(
                color: Colors.orange,
                height: 4.0,
              ),
            ))
        : AppBar(
            backgroundColor: Colors.black,
            title: Row(
              children: [
                Expanded(
                  flex: 10,
                  child: TextField(
                    onChanged: (value) {
                      if (widget.funcionFiltrado != null) {
                        widget.funcionFiltrado!(controller.text);
                      }
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
                        hintText: widget.placeholderText,
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
                      if (widget.funcionFiltrado != null) {
                        widget.funcionFiltrado!("");
                      }
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
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4.0),
              child: Container(
                color: Colors.orange,
                height: 4.0,
              ),
            ));
  }
}
