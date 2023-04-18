import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:lol_pedia/models/client_api_all_data_response.dart';


class ClientApiRepository {
  static late ClientApiRepository _instance;
  static Future<ClientApiRepository> getInstance() async {
    _instance = ClientApiRepository();
    return _instance;
  }

  String clientApiUrl = "http://192.168.1.21:3000";
  
  Future<ClientApiAllDataResponse?> getClientApiFullData() async {
    // try {
      final response = await http.get(
          Uri.parse(clientApiUrl));
      if (response.statusCode != 200) return null;
      final jsonMap = json.decode(response.body) as Map<String, dynamic>;
      ClientApiAllDataResponse status = ClientApiAllDataResponse.fromMap(jsonMap);
      return status;
    // } catch (error) {
    //   if (kDebugMode) {
    //     print(error);
    //   }
    // }
    return null;
  }
}
