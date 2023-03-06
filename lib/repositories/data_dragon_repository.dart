import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:lol_pedia/models/ChampionDetails.dart';

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
      var response = await http.get(
          Uri.parse("$DataDragonURL/13.4.1/data/es_ES/champion/$champ.json"));
      var xd = json.decode(response.body);
      print(xd);
      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      String championName = 'Aatrox';
      String championKey = jsonMap['data'];
      // .firstWhere(
      //     (key) => key.toLowerCase() == championName.toLowerCase(),
      //     orElse: () => null);
      // if (championKey != null) {
      //   String name = jsonMap['data'][championKey]['name'];
      //   print(name); // Output: Ashe
      // }
      return ChampionDetails.fromJson(xd).data;
    } catch (error) {
      print(error.toString());
    }
  }
}
