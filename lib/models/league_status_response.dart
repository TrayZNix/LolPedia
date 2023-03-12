import 'dart:convert';

LeagueStatusResponse leagueStatusResponseFromJson(String str) =>
    LeagueStatusResponse.fromJson(json.decode(str));

String leagueStatusResponseToJson(LeagueStatusResponse data) =>
    json.encode(data.toJson());

class LeagueStatusResponse {
  LeagueStatusResponse({
    this.id,
    this.name,
    this.locales,
    this.maintenances,
    this.incidents,
  });

  String? id;
  String? name;
  List<String>? locales;
  List<dynamic>? maintenances;
  List<Incident>? incidents;

  factory LeagueStatusResponse.fromJson(Map<String, dynamic> json) =>
      LeagueStatusResponse(
        id: json["id"],
        name: json["name"],
        locales: List<String>.from(json["locales"].map((x) => x)),
        maintenances: List<dynamic>.from(json["maintenances"].map((x) => x)),
        incidents: List<Incident>.from(
            json["incidents"].map((x) => Incident.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "locales": List<dynamic>.from(locales!.map((x) => x)),
        "maintenances": List<dynamic>.from(maintenances!.map((x) => x)),
        "incidents": List<dynamic>.from(incidents!.map((x) => x.toJson())),
      };
}

class Incident {
  Incident({
    this.titles,
    this.maintenanceStatus,
    this.incidentSeverity,
    this.updatedAt,
    this.archiveAt,
    this.createdAt,
    this.updates,
    this.platforms,
    this.id,
  });

  List<Title>? titles;
  dynamic maintenanceStatus;
  String? incidentSeverity;
  DateTime? updatedAt;
  dynamic archiveAt;
  DateTime? createdAt;
  List<Update>? updates;
  List<String>? platforms;
  int? id;

  factory Incident.fromJson(Map<String, dynamic> json) => Incident(
        titles: List<Title>.from(json["titles"].map((x) => Title.fromJson(x))),
        maintenanceStatus: json["maintenance_status"],
        incidentSeverity: json["incident_severity"],
        updatedAt: DateTime.parse(json["updated_at"]),
        archiveAt: json["archive_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updates:
            List<Update>.from(json["updates"].map((x) => Update.fromJson(x))),
        platforms: List<String>.from(json["platforms"].map((x) => x)),
        id: json["id"],
      );

  Map<String?, dynamic>? toJson() => {
        "titles": titles != null
            ? List<dynamic>.from(titles!.map((x) => x.toJson()))
            : null,
        "maintenance_status": maintenanceStatus,
        "incident_severity": incidentSeverity,
        "updated_at": updatedAt?.toIso8601String(),
        "archive_at": archiveAt,
        "created_at": createdAt?.toIso8601String(),
        "updates": updates != null
            ? List<dynamic>.from(updates!.map((x) => x.toJson()))
            : null,
        "platforms": platforms != null
            ? List<dynamic>.from(platforms!.map((x) => x))
            : null,
        "id": id,
      };
}

class Title {
  Title({
    this.locale,
    this.content,
  });

  String? locale;
  String? content;

  factory Title.fromJson(Map<String, dynamic> json) => Title(
        locale: json["locale"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "locale": locale,
        "content": content,
      };
}

class Update {
  Update({
    this.translations,
    this.updatedAt,
    this.author,
    this.createdAt,
    this.publish,
    this.publishLocations,
    this.id,
  });

  List<Title>? translations;
  DateTime? updatedAt;
  String? author;
  DateTime? createdAt;
  bool? publish;
  List<String>? publishLocations;
  int? id;

  factory Update.fromJson(Map<String, dynamic> json) => Update(
        translations: json["translations"] != null
            ? List<Title>.from(
                json["translations"].map((x) => Title.fromJson(x)))
            : null,
        updatedAt: DateTime.parse(json["updated_at"]),
        author: json["author"],
        createdAt: DateTime.parse(json["created_at"]),
        publish: json["publish"],
        publishLocations:
            List<String>.from(json["publish_locations"].map((x) => x)),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "translations":
            List<dynamic>.from(translations!.map((x) => x.toJson())),
        "updated_at": updatedAt?.toIso8601String(),
        "author": author,
        "created_at": createdAt?.toIso8601String(),
        "publish": publish,
        "publish_locations":
            List<dynamic>.from(publishLocations!.map((x) => x)),
        "id": id,
      };
}
