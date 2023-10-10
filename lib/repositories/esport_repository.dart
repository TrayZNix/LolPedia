import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:lol_pedia/dinamic_general_variables.dart';
import 'package:lol_pedia/models/leagues.dart';
import 'package:lol_pedia/models/match_data_details_interface.dart';
import 'package:lol_pedia/models/match_data_window_interface.dart';
import 'package:lol_pedia/models/partidos_ligas.dart';

import '../models/match_details_interface.dart';

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
  String feedApiUrl = "https://feed.lolesports.com/livestats/v1";

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

  Future<MatchDataInterface> getMatchDetails(String matchId) async {
    var response = await http.get(
        Uri.parse(
            "$apiUrl/getEventDetails?hl=${riotDeveloperKey.lang.replaceAll("_", "-")}&id=$matchId"),
        headers: {"x-api-key": riotDeveloperKey.esportKey});
    var body = json.decode(response.body) as Map<String, dynamic>;
    return MatchDataInterface.fromJson(body);
  }

  Future<MatchDetailsWindowInterface> getConcreteMatchDataWindow(
      String id) async {
    String date = DateTime.now()
        .toUtc()
        .subtract(const Duration(minutes: 1))
        .toIso8601String();
    // String date = DateTime.fromMicrosecondsSinceEpoch(1694282403000 * 1000)
    //     .toUtc()
    //     .add(const Duration(minutes: 30))
    //     .toIso8601String();
    String finalString = "${date.substring(0, (date.lastIndexOf(".") - 1))}0Z";
    var response = await http.get(
        Uri.parse("$feedApiUrl/window/$id?startingTime=$finalString"),
        headers: {"x-api-key": riotDeveloperKey.esportKey});
    var body = json.decode(response.body) as Map<String, dynamic>;
    return MatchDetailsWindowInterface.fromJson(body);
  }

  Future<MatchDetailsInterface> getConcreteMatchDetail(String id) async {
    String date = DateTime.now()
        .toUtc()
        .subtract(const Duration(minutes: 1))
        .toIso8601String();
    // String date = DateTime.fromMicrosecondsSinceEpoch(1694282403000 * 1000)
    //     .toUtc()
    //     .add(const Duration(minutes: 30))
    //     .toIso8601String();
    String finalString = "${date.substring(0, (date.lastIndexOf(".") - 1))}0Z";
    var response = await http.get(
        Uri.parse("$feedApiUrl/details/$id?startingTime=$finalString"),
        headers: {"x-api-key": riotDeveloperKey.esportKey});
    var body = json.decode(response.body) as Map<String, dynamic>;
    return MatchDetailsInterface.fromJson(body);
  }
}
