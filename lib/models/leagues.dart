// To parse this JSON data, do
//
//     final leagues = leaguesFromJson(jsonString);

import 'dart:convert';

Leagues leaguesFromJson(String str) => Leagues.fromJson(json.decode(str));

String leaguesToJson(Leagues data) => json.encode(data.toJson());

class Leagues {
  Data data;

  Leagues({
    required this.data,
  });

  factory Leagues.fromJson(Map<String, dynamic> json) => Leagues(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  List<League> leagues;

  Data({
    required this.leagues,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        leagues:
            List<League>.from(json["leagues"].map((x) => League.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "leagues": List<dynamic>.from(leagues.map((x) => x.toJson())),
      };
}

class League {
  String id;
  String slug;
  String name;
  String region;
  String image;
  int priority;
  DisplayPriority displayPriority;

  League({
    required this.id,
    required this.slug,
    required this.name,
    required this.region,
    required this.image,
    required this.priority,
    required this.displayPriority,
  });

  factory League.fromJson(Map<String, dynamic> json) => League(
        id: json["id"],
        slug: json["slug"],
        name: json["name"],
        region: json["region"],
        image: json["image"],
        priority: json["priority"],
        displayPriority: DisplayPriority.fromJson(json["displayPriority"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "slug": slug,
        "name": name,
        "region": region,
        "image": image,
        "priority": priority,
        "displayPriority": displayPriority.toJson(),
      };
}

class DisplayPriority {
  int position;
  Status status;

  DisplayPriority({
    required this.position,
    required this.status,
  });

  factory DisplayPriority.fromJson(Map<String, dynamic> json) =>
      DisplayPriority(
        position: json["position"],
        status: statusValues.map[json["status"]]!,
      );

  Map<String, dynamic> toJson() => {
        "position": position,
        "status": statusValues.reverse[status],
      };
}

enum Status { SELECTED, NOT_SELECTED, HIDDEN }

final statusValues = EnumValues({
  "hidden": Status.HIDDEN,
  "not_selected": Status.NOT_SELECTED,
  "selected": Status.SELECTED
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
