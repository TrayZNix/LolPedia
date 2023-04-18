import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol_pedia/models/league_status_response.dart';

class WidgetCreator {
  Widget statusWidgetBuilder(LeagueStatusResponse? status) {
    Widget icono = const Icon(
      Icons.check_rounded,
      color: Colors.green,
    );
    if (status == null) {
      icono = Icon(Icons.question_mark_rounded, color: Colors.grey[400]);
    }
    List<Widget> errorMessages = <Widget>[];
    if (status != null) {
      for (var incidente in status.incidents!) {
        if (incidente.incidentSeverity == "info") {
          icono = const Icon(
            Icons.priority_high_rounded,
            color: Colors.yellow,
          );
          for (var incidente in incidente.titles!) {
            if (incidente.locale == "es_ES") {
              errorMessages.add(Text(incidente.content ?? "",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.anekDevanagari(
                      color: Colors.white, fontSize: 15)));
            }
          }
        } else if (incidente.incidentSeverity == "critical") {
          icono = const Icon(
            Icons.priority_high_rounded,
            color: Colors.red,
          );
          for (var incidente in incidente.titles!) {
            if (incidente.locale == "es_ES") {
              errorMessages.add(Text(incidente.content ?? "",
                  style: GoogleFonts.anekDevanagari(
                      color: Colors.white, fontSize: 15)));
            }
          }
        }
        if (status.incidents!.isEmpty) {
          errorMessages.add(const Text("Sin incidencias"));
        }
      }
    }
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        icono,
        (status == null)
            ? Text(
                "Ha ocurrido un error y no hay datos.",
                textAlign: TextAlign.center,
                style: GoogleFonts.anekDevanagari(
                    color: Colors.white, fontSize: 15),
              )
            : Container(),
        ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: errorMessages),
      ],
    );
  }
}
