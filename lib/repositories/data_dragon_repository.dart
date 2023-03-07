import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../models/ChampionDetails.dart';
import '../models/champion.dart';

class DataDragonRepository {
  static late DataDragonRepository _instance;

  static Future<DataDragonRepository> getInstance() async {
    _instance = DataDragonRepository();

    return _instance;
  }

  String DataDragonURL = "https://ddragon.leagueoflegends.com/cdn";

  Future<List<Datum>> getChampions() async {
    var response = await http
        .get(Uri.parse("$DataDragonURL/13.4.1/data/es_ES/champion.json"));
    var body = json.decode(response.body);
    return List.from(Champions.fromJson(body).data.values);
  }

  Future<Data?> getChampionsDetails(String champ) async {
    try {
      final response = await http.get(
          Uri.parse('$DataDragonURL/13.4.1/data/es_ES/champion/$champ.json'));
      final jsonMap = json.decode(response.body) as Map<String, dynamic>;
      final dataJson = jsonMap['data'].values.first as Map<String, dynamic>;
      final data = Data.fromJson(dataJson);
      return data;
    } catch (error) {
      print(error.toString());
    }
  }

}
