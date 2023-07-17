import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:lol_pedia/UIs/match_details/match_details_page.dart';
import 'package:lol_pedia/dinamic_general_variables.dart';
import 'package:lol_pedia/models/leagues.dart';
import 'package:lol_pedia/models/partidos_ligas.dart';

import '../models/match_details.dart';

class EsportRepository {
  static late EsportRepository _instance;
  static Future<EsportRepository> getInstance() async {
    _instance = EsportRepository();
    return _instance;
  }

  late DynamicGeneralVariables riotDeveloperKey;
  EsportRepository() {
    riotDeveloperKey = GetIt.I.get<DynamicGeneralVariables>();
  }

  String apiUrl = "https://prod-relapi.ewp.gg/persisted/gw";

  Future<Leagues> getLeagues() async {
    var response = await http.get(
        Uri.parse(
            "$apiUrl/getLeagues?hl=${riotDeveloperKey.lang.replaceAll("_", "-")}"),
        headers: {"x-api-key": riotDeveloperKey.esportKey});
    var body = json.decode(response.body);
    return Leagues.fromJson(body);
  }

  Future<ScheduleData> getPartidos(String leagueId) async {
    var response = await http.get(
        Uri.parse(
            "$apiUrl/getSchedule?hl=${riotDeveloperKey.lang.replaceAll("_", "-")}&leagueId=$leagueId"),
        headers: {"x-api-key": riotDeveloperKey.esportKey});
    var body = json.decode(response.body) as Map<String, dynamic>;
    return ScheduleData.fromJson(body);
  }

  Future<MatchDetails> getMatchDetails(String matchId) async {
    var response = await http.get(
        Uri.parse(
            "$apiUrl/getEventDetails?hl=${riotDeveloperKey.lang.replaceAll("_", "-")}&id=$matchId"),
        headers: {"x-api-key": riotDeveloperKey.esportKey});
    var body = json.decode(response.body) as Map<String, dynamic>;
    return MatchDetails.fromJson(body);
  }
}
