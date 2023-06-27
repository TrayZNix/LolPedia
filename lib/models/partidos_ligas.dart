class ScheduleData {
  final Schedule? schedule;

  ScheduleData({this.schedule});

  factory ScheduleData.fromJson(Map<String, dynamic> json) {
    return ScheduleData(
      schedule: json['data'] != null
          ? Schedule.fromJson(json['data']['schedule'])
          : null,
    );
  }
}

class Schedule {
  final Pages? pages;
  final List<Event>? events;

  Schedule({this.pages, this.events});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      pages: json['pages'] != null ? Pages.fromJson(json['pages']) : null,
      events: json['events'] != null
          ? List<Event>.from(json['events'].map((x) => Event.fromJson(x)))
          : null,
    );
  }
}

class Pages {
  final String? older;
  final dynamic newer;

  Pages({this.older, this.newer});

  factory Pages.fromJson(Map<String, dynamic> json) {
    return Pages(
      older: json['older'],
      newer: json['newer'],
    );
  }
}

class Event {
  final String? startTime;
  final String? state;
  final String? type;
  final String? blockName;
  final League? league;
  final Match? match;

  Event(
      {this.startTime,
      this.state,
      this.type,
      this.blockName,
      this.league,
      this.match});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      startTime: json['startTime'],
      state: json['state'],
      type: json['type'],
      blockName: json['blockName'],
      league: json['league'] != null ? League.fromJson(json['league']) : null,
      match: json['match'] != null ? Match.fromJson(json['match']) : null,
    );
  }
}

class League {
  final String? name;
  final String? slug;

  League({this.name, this.slug});

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      name: json['name'],
      slug: json['slug'],
    );
  }
}

class Match {
  final String? id;
  final List<String>? flags;
  final List<Team>? teams;
  final Strategy? strategy;

  Match({this.id, this.flags, this.teams, this.strategy});

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'],
      flags: json['flags'] != null
          ? List<String>.from(json['flags'].map((x) => x))
          : null,
      teams: json['teams'] != null
          ? List<Team>.from(json['teams'].map((x) => Team.fromJson(x)))
          : null,
      strategy:
          json['strategy'] != null ? Strategy.fromJson(json['strategy']) : null,
    );
  }
}

class Team {
  final String? name;
  final String? code;
  final String? image;
  final Result? result;
  final Record? record;

  Team({this.name, this.code, this.image, this.result, this.record});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      name: json['name'],
      code: json['code'],
      image: json['image'],
      result: json['result'] != null ? Result.fromJson(json['result']) : null,
      record: json['record'] != null ? Record.fromJson(json['record']) : null,
    );
  }
}

class Result {
  final String? outcome;
  final int? gameWins;

  Result({this.outcome, this.gameWins});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      outcome: json['outcome'],
      gameWins: json['gameWins'],
    );
  }
}

class Record {
  final int? wins;
  final int? losses;

  Record({this.wins, this.losses});

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      wins: json['wins'],
      losses: json['losses'],
    );
  }
}

class Strategy {
  final String? type;
  final int? count;

  Strategy({this.type, this.count});

  factory Strategy.fromJson(Map<String, dynamic> json) {
    return Strategy(
      type: json['type'],
      count: json['count'],
    );
  }
}
