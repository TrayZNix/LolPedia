class MatchDetailsInterface {
  MatchDetailsInterface({
    required this.frames,
  });
  late final List<Frames> frames;

  MatchDetailsInterface.fromJson(Map<String, dynamic> json) {
    frames = List.from(json['frames']).map((e) => Frames.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['frames'] = frames.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Frames {
  Frames({
    required this.rfc460Timestamp,
    required this.participants,
  });
  late final String rfc460Timestamp;
  late final List<ParticipantData> participants;

  Frames.fromJson(Map<String, dynamic> json) {
    rfc460Timestamp = json['rfc460Timestamp'];
    participants = List.from(json['participants'])
        .map((e) => ParticipantData.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['rfc460Timestamp'] = rfc460Timestamp;
    _data['participants'] = participants.map((e) => e.toJson()).toList();
    return _data;
  }
}

class ParticipantData {
  ParticipantData({
    required this.participantId,
    required this.level,
    required this.kills,
    required this.deaths,
    required this.assists,
    required this.totalGoldEarned,
    required this.creepScore,
    required this.killParticipation,
    required this.championDamageShare,
    required this.wardsPlaced,
    required this.wardsDestroyed,
    required this.attackDamage,
    required this.abilityPower,
    required this.criticalChance,
    required this.attackSpeed,
    required this.lifeSteal,
    required this.armor,
    required this.magicResistance,
    required this.tenacity,
    required this.items,
    required this.perkMetadata,
    required this.abilities,
  });
  late final int participantId;
  late final int level;
  late final int kills;
  late final int deaths;
  late final int assists;
  late final int totalGoldEarned;
  late final int creepScore;
  late final double killParticipation;
  late final double championDamageShare;
  late final int wardsPlaced;
  late final int wardsDestroyed;
  late final int attackDamage;
  late final int abilityPower;
  late final double criticalChance;
  late final int attackSpeed;
  late final int lifeSteal;
  late final int armor;
  late final int magicResistance;
  late final double tenacity;
  late final List<int> items;
  late final PerkMetadata perkMetadata;
  late final List<String> abilities;

  ParticipantData.fromJson(Map<String, dynamic> json) {
    participantId = json['participantId'];
    level = json['level'];
    kills = json['kills'];
    deaths = json['deaths'];
    assists = json['assists'];
    totalGoldEarned = json['totalGoldEarned'];
    creepScore = json['creepScore'];
    killParticipation = json['killParticipation'];
    championDamageShare = json['championDamageShare'];
    wardsPlaced = json['wardsPlaced'];
    wardsDestroyed = json['wardsDestroyed'];
    attackDamage = json['attackDamage'];
    abilityPower = json['abilityPower'];
    criticalChance = json['criticalChance'];
    attackSpeed = json['attackSpeed'];
    lifeSteal = json['lifeSteal'];
    armor = json['armor'];
    magicResistance = json['magicResistance'];
    tenacity = json['tenacity'];
    items = List.castFrom<dynamic, int>(json['items']);
    perkMetadata = PerkMetadata.fromJson(json['perkMetadata']);
    abilities = List.castFrom<dynamic, String>(json['abilities']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['participantId'] = participantId;
    _data['level'] = level;
    _data['kills'] = kills;
    _data['deaths'] = deaths;
    _data['assists'] = assists;
    _data['totalGoldEarned'] = totalGoldEarned;
    _data['creepScore'] = creepScore;
    _data['killParticipation'] = killParticipation;
    _data['championDamageShare'] = championDamageShare;
    _data['wardsPlaced'] = wardsPlaced;
    _data['wardsDestroyed'] = wardsDestroyed;
    _data['attackDamage'] = attackDamage;
    _data['abilityPower'] = abilityPower;
    _data['criticalChance'] = criticalChance;
    _data['attackSpeed'] = attackSpeed;
    _data['lifeSteal'] = lifeSteal;
    _data['armor'] = armor;
    _data['magicResistance'] = magicResistance;
    _data['tenacity'] = tenacity;
    _data['items'] = items;
    _data['perkMetadata'] = perkMetadata.toJson();
    _data['abilities'] = abilities;
    return _data;
  }
}

class PerkMetadata {
  PerkMetadata({
    required this.styleId,
    required this.subStyleId,
    required this.perks,
  });
  late final int styleId;
  late final int subStyleId;
  late final List<int> perks;

  PerkMetadata.fromJson(Map<String, dynamic> json) {
    styleId = json['styleId'];
    subStyleId = json['subStyleId'];
    perks = List.castFrom<dynamic, int>(json['perks']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['styleId'] = styleId;
    _data['subStyleId'] = subStyleId;
    _data['perks'] = perks;
    return _data;
  }
}
