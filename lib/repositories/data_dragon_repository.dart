import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:lol_pedia/models/league_status_response.dart';
import 'package:lol_pedia/dinamic_general_variables.dart';

import '../models/champion_details.dart';
import '../models/champion.dart';

class DataDragonRepository {
  static late DataDragonRepository _instance;
  static Future<DataDragonRepository> getInstance() async {
    _instance = DataDragonRepository();
    return _instance;
  }

  late DynamicGeneralVariables riotDeveloperKey;
  DataDragonRepository() {
    riotDeveloperKey = GetIt.I.get<DynamicGeneralVariables>();
  }

  String dataDragonUrl = "https://ddragon.leagueoflegends.com/cdn";
  String riotApiUrl = "https://euw1.api.riotgames.com/lol";

  Future<List<Datum>> getChampions() async {
    var response = await http.get(Uri.parse(
        "$dataDragonUrl/${riotDeveloperKey.versionActual}/data/${riotDeveloperKey.lang}/champion.json"));
    var body = json.decode(response.body);
    return List.from(Champions.fromJson(body).data.values);
  }

  Future<Data?> getChampionsDetails(String champ) async {
    try {
      final response = await http.get(Uri.parse(
          '$dataDragonUrl/${riotDeveloperKey.versionActual}/data/${riotDeveloperKey.lang}/champion/$champ.json'));
      if (response.statusCode != 200) return null;
      final jsonMap = json.decode(response.body) as Map<String, dynamic>;
      final dataJson = jsonMap['data'].values.first as Map<String, dynamic>;
      return Data.fromJson(dataJson);
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
    return null;
  }

  Future<LeagueStatusResponse?> getLeagueStatus() async {
    try {
      final response = await http.get(
          Uri.parse("$riotApiUrl/status/v4/platform-data"),
          headers: {"X-Riot-Token": riotDeveloperKey.key});
      if (response.statusCode != 200) return null;
      final jsonMap = json.decode(response.body) as Map<String, dynamic>;
      LeagueStatusResponse status = LeagueStatusResponse.fromJson(jsonMap);
      if (status.incidents!.isEmpty) {
        return null;
      } else {
        return status;
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return null;
  }
}
