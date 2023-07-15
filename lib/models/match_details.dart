// To parse this JSON data, do
//
//     final matchDetails = matchDetailsFromJson(jsonString);

import 'dart:convert';

MatchDetails matchDetailsFromJson(String str) =>
    MatchDetails.fromJson(json.decode(str));

String matchDetailsToJson(MatchDetails data) => json.encode(data.toJson());

class MatchDetails {
  Data? data;

  MatchDetails({
    this.data,
  });

  factory MatchDetails.fromJson(Map<String, dynamic> json) => MatchDetails(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  Event? event;

  Data({
    this.event,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        event: Event.fromJson(json["event"]),
      );

  Map<String, dynamic> toJson() => {
        "event": event?.toJson(),
      };
}

class Event {
  String? id;
  String? type;
  Tournament? tournament;
  League? league;
  Match? match;
  List<dynamic>? streams;

  Event({
    this.id,
    this.type,
    this.tournament,
    this.league,
    this.match,
    this.streams,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        type: json["type"],
        tournament: Tournament.fromJson(json["tournament"]),
        league: League.fromJson(json["league"]),
        match: Match.fromJson(json["match"]),
        streams: List<dynamic>.from(json["streams"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "tournament": tournament?.toJson(),
        "league": league?.toJson(),
        "match": match?.toJson(),
        "streams":
            streams != null ? List<dynamic>.from(streams!.map((x) => x)) : [],
      };
}

class League {
  String? id;
  String? slug;
  String? image;
  String? name;

  League({
    this.id,
    this.slug,
    this.image,
    this.name,
  });

  factory League.fromJson(Map<String, dynamic> json) => League(
        id: json["id"],
        slug: json["slug"],
        image: json["image"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "slug": slug,
        "image": image,
        "name": name,
      };
}

class Match {
  Strategy? strategy;
  List<MatchTeam>? teams;
  List<Game>? games;

  Match({
    this.strategy,
    this.teams,
    this.games,
  });

  factory Match.fromJson(Map<String, dynamic> json) => Match(
        strategy: Strategy.fromJson(json["strategy"]),
        teams: List<MatchTeam>.from(
            json["teams"].map((x) => MatchTeam.fromJson(x))),
        games: List<Game>.from(json["games"].map((x) => Game.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "strategy": strategy?.toJson(),
        "teams": teams != null
            ? List<dynamic>.from(teams!.map((x) => x.toJson()))
            : [],
        "games": games != null
            ? List<dynamic>.from(games!.map((x) => x.toJson()))
            : games,
      };
}

class Game {
  int? number;
  String? id;
  String? state;
  List<GameTeam>? teams;
  List<dynamic>? vods;

  Game({
    this.number,
    this.id,
    this.state,
    this.teams,
    this.vods,
  });

  factory Game.fromJson(Map<String, dynamic> json) => Game(
        number: json["number"],
        id: json["id"],
        state: json["state"],
        teams:
            List<GameTeam>.from(json["teams"].map((x) => GameTeam.fromJson(x))),
        vods: List<dynamic>.from(json["vods"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "id": id,
        "state": state,
        "teams": teams != null
            ? List<dynamic>.from(teams!.map((x) => x.toJson()))
            : [],
        "vods": vods != null ? List<dynamic>.from(vods!.map((x) => x)) : [],
      };
}

class GameTeam {
  String? id;
  String? side;

  GameTeam({
    this.id,
    this.side,
  });

  factory GameTeam.fromJson(Map<String, dynamic> json) => GameTeam(
        id: json["id"],
        side: json["side"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "side": side,
      };
}

class Strategy {
  int? count;

  Strategy({
    this.count,
  });

  factory Strategy.fromJson(Map<String, dynamic> json) => Strategy(
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
      };
}

class MatchTeam {
  String? id;
  String? name;
  String? code;
  String? image;
  Result? result;

  MatchTeam({
    this.id,
    this.name,
    this.code,
    this.image,
    this.result,
  });

  factory MatchTeam.fromJson(Map<String, dynamic> json) => MatchTeam(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        image: json["image"],
        result: Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "image": image,
        "result": result?.toJson(),
      };
}

class Result {
  int? gameWins;

  Result({
    this.gameWins,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        gameWins: json["gameWins"],
      );

  Map<String, dynamic> toJson() => {
        "gameWins": gameWins,
      };
}

class Tournament {
  String? id;

  Tournament({
    this.id,
  });

  factory Tournament.fromJson(Map<String, dynamic> json) => Tournament(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
