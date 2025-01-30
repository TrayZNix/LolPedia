import 'package:injectable/injectable.dart';

@Singleton()
class DynamicGeneralVariables {
  String key = 'x';
  String esportKey = 'x'; //Lol esport web ak
  String versionActual = '1.1.1';
  String lang = 'es_ES';
  Duration timeZoneOffset = Duration.zero;
  List<String> versionList = [];
}
