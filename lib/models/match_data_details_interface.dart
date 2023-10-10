class MatchDetailsInterface {
  MatchDetailsInterface({
    required this.frames,
  });
  late final List<Frames> frames;

  MatchDetailsInterface.fromJson(Map<String, dynamic> json) {
    frames = List.from(json['frames']).map((e) => Frames.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['frames'] = frames.map((e) => e.toJson()).toList();
    return data;
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
    final data = <String, dynamic>{};
    data['rfc460Timestamp'] = rfc460Timestamp;
    data['participants'] = participants.map((e) => e.toJson()).toList();
    return data;
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
    final data = <String, dynamic>{};
    data['participantId'] = participantId;
    data['level'] = level;
    data['kills'] = kills;
    data['deaths'] = deaths;
    data['assists'] = assists;
    data['totalGoldEarned'] = totalGoldEarned;
    data['creepScore'] = creepScore;
    data['killParticipation'] = killParticipation;
    data['championDamageShare'] = championDamageShare;
    data['wardsPlaced'] = wardsPlaced;
    data['wardsDestroyed'] = wardsDestroyed;
    data['attackDamage'] = attackDamage;
    data['abilityPower'] = abilityPower;
    data['criticalChance'] = criticalChance;
    data['attackSpeed'] = attackSpeed;
    data['lifeSteal'] = lifeSteal;
    data['armor'] = armor;
    data['magicResistance'] = magicResistance;
    data['tenacity'] = tenacity;
    data['items'] = items;
    data['perkMetadata'] = perkMetadata.toJson();
    data['abilities'] = abilities;
    return data;
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
    final data = <String, dynamic>{};
    data['styleId'] = styleId;
    data['subStyleId'] = subStyleId;
    data['perks'] = perks;
    return data;
  }
}
