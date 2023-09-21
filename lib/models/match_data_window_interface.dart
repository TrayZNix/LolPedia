class MatchDetailsWindowInterface {
  MatchDetailsWindowInterface({
    required this.esportsGameId,
    required this.esportsMatchId,
    required this.gameMetadata,
    required this.frames,
  });
  late final String? esportsGameId;
  late final String? esportsMatchId;
  late final GameMetadata gameMetadata;
  late final List<Frames> frames;

  MatchDetailsWindowInterface.fromJson(Map<String, dynamic> json) {
    esportsGameId = json['esportsGameId'];
    esportsMatchId = json['esportsMatchId'];
    gameMetadata = GameMetadata.fromJson(json['gameMetadata']);
    frames = List.from(json['frames']).map((e) => Frames.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['esportsGameId'] = esportsGameId;
    _data['esportsMatchId'] = esportsMatchId;
    _data['gameMetadata'] = gameMetadata.toJson();
    _data['frames'] = frames.map((e) => e.toJson()).toList();
    return _data;
  }
}

class GameMetadata {
  GameMetadata({
    required this.patchVersion,
    required this.blueTeamMetadata,
    required this.redTeamMetadata,
  });
  late final String? patchVersion;
  late final BlueTeamMetadata blueTeamMetadata;
  late final RedTeamMetadata redTeamMetadata;

  GameMetadata.fromJson(Map<String, dynamic> json) {
    patchVersion = json['patchVersion'];
    blueTeamMetadata = BlueTeamMetadata.fromJson(json['blueTeamMetadata']);
    redTeamMetadata = RedTeamMetadata.fromJson(json['redTeamMetadata']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['patchVersion'] = patchVersion;
    _data['blueTeamMetadata'] = blueTeamMetadata.toJson();
    _data['redTeamMetadata'] = redTeamMetadata.toJson();
    return _data;
  }
}

class BlueTeamMetadata {
  BlueTeamMetadata({
    required this.esportsTeamId,
    required this.participantMetadata,
  });
  late final String? esportsTeamId;
  late final List<ParticipantMetadata> participantMetadata;

  BlueTeamMetadata.fromJson(Map<String, dynamic> json) {
    esportsTeamId = json['esportsTeamId'];
    participantMetadata = List.from(json['participantMetadata'])
        .map((e) => ParticipantMetadata.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['esportsTeamId'] = esportsTeamId;
    _data['participantMetadata'] =
        participantMetadata.map((e) => e.toJson()).toList();
    return _data;
  }
}

class ParticipantMetadata {
  ParticipantMetadata({
    required this.participantId,
    required this.esportsPlayerId,
    required this.summonerName,
    required this.championId,
    required this.role,
  });
  late final int? participantId;
  late final String? esportsPlayerId;
  late final String? summonerName;
  late final String? championId;
  late final String? role;

  ParticipantMetadata.fromJson(Map<String, dynamic> json) {
    participantId = json['participantId'];
    esportsPlayerId = json['esportsPlayerId'];
    summonerName = json['summonerName'];
    championId = json['championId'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['participantId'] = participantId;
    _data['esportsPlayerId'] = esportsPlayerId;
    _data['summonerName'] = summonerName;
    _data['championId'] = championId;
    _data['role'] = role;
    return _data;
  }
}

class RedTeamMetadata {
  RedTeamMetadata({
    required this.esportsTeamId,
    required this.participantMetadata,
  });
  late final String esportsTeamId;
  late final List<ParticipantMetadata> participantMetadata;

  RedTeamMetadata.fromJson(Map<String, dynamic> json) {
    esportsTeamId = json['esportsTeamId'];
    participantMetadata = List.from(json['participantMetadata'])
        .map((e) => ParticipantMetadata.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['esportsTeamId'] = esportsTeamId;
    _data['participantMetadata'] =
        participantMetadata.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Frames {
  Frames({
    required this.rfc460Timestamp,
    required this.gameState,
    required this.blueTeam,
    required this.redTeam,
  });
  late final String? rfc460Timestamp;
  late final String? gameState;
  late final BlueTeam blueTeam;
  late final RedTeam redTeam;

  Frames.fromJson(Map<String, dynamic> json) {
    rfc460Timestamp = json['rfc460Timestamp'];
    gameState = json['gameState'];
    blueTeam = BlueTeam.fromJson(json['blueTeam']);
    redTeam = RedTeam.fromJson(json['redTeam']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['rfc460Timestamp'] = rfc460Timestamp;
    _data['gameState'] = gameState;
    _data['blueTeam'] = blueTeam.toJson();
    _data['redTeam'] = redTeam.toJson();
    return _data;
  }
}

class BlueTeam {
  BlueTeam({
    required this.totalGold,
    required this.inhibitors,
    required this.towers,
    required this.barons,
    required this.totalKills,
    required this.dragons,
    required this.participants,
  });
  late final int? totalGold;
  late final int? inhibitors;
  late final int? towers;
  late final int? barons;
  late final int? totalKills;
  late final List<dynamic> dragons;
  late final List<Participants> participants;

  BlueTeam.fromJson(Map<String, dynamic> json) {
    totalGold = json['totalGold'];
    inhibitors = json['inhibitors'];
    towers = json['towers'];
    barons = json['barons'];
    totalKills = json['totalKills'];
    dragons = List.castFrom<dynamic, dynamic>(json['dragons']);
    participants = List.from(json['participants'])
        .map((e) => Participants.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['totalGold'] = totalGold;
    _data['inhibitors'] = inhibitors;
    _data['towers'] = towers;
    _data['barons'] = barons;
    _data['totalKills'] = totalKills;
    _data['dragons'] = dragons;
    _data['participants'] = participants.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Participants {
  Participants({
    required this.participantId,
    required this.totalGold,
    required this.level,
    required this.kills,
    required this.deaths,
    required this.assists,
    required this.creepScore,
    required this.currentHealth,
    required this.maxHealth,
  });
  late final int? participantId;
  late final int? totalGold;
  late final int? level;
  late final int? kills;
  late final int? deaths;
  late final int? assists;
  late final int? creepScore;
  late final int? currentHealth;
  late final int? maxHealth;

  Participants.fromJson(Map<String, dynamic> json) {
    participantId = json['participantId'];
    totalGold = json['totalGold'];
    level = json['level'];
    kills = json['kills'];
    deaths = json['deaths'];
    assists = json['assists'];
    creepScore = json['creepScore'];
    currentHealth = json['currentHealth'];
    maxHealth = json['maxHealth'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['participantId'] = participantId;
    _data['totalGold'] = totalGold;
    _data['level'] = level;
    _data['kills'] = kills;
    _data['deaths'] = deaths;
    _data['assists'] = assists;
    _data['creepScore'] = creepScore;
    _data['currentHealth'] = currentHealth;
    _data['maxHealth'] = maxHealth;
    return _data;
  }
}

class RedTeam {
  RedTeam({
    required this.totalGold,
    required this.inhibitors,
    required this.towers,
    required this.barons,
    required this.totalKills,
    required this.dragons,
    required this.participants,
  });
  late final int? totalGold;
  late final int? inhibitors;
  late final int? towers;
  late final int? barons;
  late final int? totalKills;
  late final List<String?> dragons;
  late final List<Participants> participants;

  RedTeam.fromJson(Map<String, dynamic> json) {
    totalGold = json['totalGold'];
    inhibitors = json['inhibitors'];
    towers = json['towers'];
    barons = json['barons'];
    totalKills = json['totalKills'];
    dragons = List.castFrom<dynamic, String>(json['dragons']);
    participants = List.from(json['participants'])
        .map((e) => Participants.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['totalGold'] = totalGold;
    _data['inhibitors'] = inhibitors;
    _data['towers'] = towers;
    _data['barons'] = barons;
    _data['totalKills'] = totalKills;
    _data['dragons'] = dragons;
    _data['participants'] = participants.map((e) => e.toJson()).toList();
    return _data;
  }
}
