// To parse this JSON data, do
//
//     final clientApiAllDataResponse = clientApiAllDataResponseFromMap(jsonString);

import 'dart:convert';

ClientApiAllDataResponse clientApiAllDataResponseFromMap(String str) =>
    ClientApiAllDataResponse.fromMap(json.decode(str));

String clientApiAllDataResponseToMap(ClientApiAllDataResponse data) =>
    json.encode(data.toMap());

class ClientApiAllDataResponse {
  ClientApiAllDataResponse({
    required this.activePlayer,
    required this.allPlayers,
    required this.events,
    required this.gameData,
  });

  ActivePlayer activePlayer;
  List<AllPlayer> allPlayers;
  Events events;
  GameData gameData;

  factory ClientApiAllDataResponse.fromMap(Map<String, dynamic> json) =>
      ClientApiAllDataResponse(
        activePlayer: ActivePlayer.fromMap(json["activePlayer"]),
        allPlayers: List<AllPlayer>.from(
            json["allPlayers"].map((x) => AllPlayer.fromMap(x))),
        events: Events.fromMap(json["events"]),
        gameData: GameData.fromMap(json["gameData"]),
      );

  Map<String, dynamic> toMap() => {
        "activePlayer": activePlayer.toMap(),
        "allPlayers": List<dynamic>.from(allPlayers.map((x) => x.toMap())),
        "events": events.toMap(),
        "gameData": gameData.toMap(),
      };
}

class ActivePlayer {
  ActivePlayer({
    required this.abilities,
    required this.championStats,
    required this.currentGold,
    required this.fullRunes,
    required this.level,
    required this.summonerName,
    required this.teamRelativeColors,
  });

  Abilities abilities;
  ChampionStats championStats;
  double currentGold;
  FullRunes fullRunes;
  int level;
  String summonerName;
  bool teamRelativeColors;

  factory ActivePlayer.fromMap(Map<String, dynamic> json) => ActivePlayer(
        abilities: Abilities.fromMap(json["abilities"]),
        championStats: ChampionStats.fromMap(json["championStats"]),
        currentGold: json["currentGold"]?.toDouble(),
        fullRunes: FullRunes.fromMap(json["fullRunes"]),
        level: json["level"],
        summonerName: json["summonerName"],
        teamRelativeColors: json["teamRelativeColors"],
      );

  Map<String, dynamic> toMap() => {
        "abilities": abilities.toMap(),
        "championStats": championStats.toMap(),
        "currentGold": currentGold,
        "fullRunes": fullRunes.toMap(),
        "level": level,
        "summonerName": summonerName,
        "teamRelativeColors": teamRelativeColors,
      };
}

class Abilities {
  Abilities({
    required this.e,
    required this.passive,
    required this.q,
    required this.r,
    required this.w,
  });

  E e;
  E passive;
  E q;
  E r;
  E w;

  factory Abilities.fromMap(Map<String, dynamic> json) => Abilities(
        e: E.fromMap(json["E"]),
        passive: E.fromMap(json["Passive"]),
        q: E.fromMap(json["Q"]),
        r: E.fromMap(json["R"]),
        w: E.fromMap(json["W"]),
      );

  Map<String, dynamic> toMap() => {
        "E": e.toMap(),
        "Passive": passive.toMap(),
        "Q": q.toMap(),
        "R": r.toMap(),
        "W": w.toMap(),
      };
}

class E {
  E({
    this.abilityLevel,
    required this.displayName,
    this.id,
    required this.rawDescription,
    required this.rawDisplayName,
  });

  int? abilityLevel;
  String displayName;
  String? id;
  String rawDescription;
  String rawDisplayName;

  factory E.fromMap(Map<String, dynamic> json) => E(
        abilityLevel: json["abilityLevel"],
        displayName: json["displayName"],
        id: json["id"],
        rawDescription: json["rawDescription"],
        rawDisplayName: json["rawDisplayName"],
      );

  Map<String, dynamic> toMap() => {
        "abilityLevel": abilityLevel,
        "displayName": displayName,
        "id": id,
        "rawDescription": rawDescription,
        "rawDisplayName": rawDisplayName,
      };
}

class ChampionStats {
  ChampionStats({
    required this.abilityHaste,
    required this.abilityPower,
    required this.armor,
    required this.armorPenetrationFlat,
    required this.armorPenetrationPercent,
    required this.attackDamage,
    required this.attackRange,
    required this.attackSpeed,
    required this.bonusArmorPenetrationPercent,
    required this.bonusMagicPenetrationPercent,
    required this.critChance,
    required this.critDamage,
    required this.currentHealth,
    required this.healShieldPower,
    required this.healthRegenRate,
    required this.lifeSteal,
    required this.magicLethality,
    required this.magicPenetrationFlat,
    required this.magicPenetrationPercent,
    required this.magicResist,
    required this.maxHealth,
    required this.moveSpeed,
    required this.omnivamp,
    required this.physicalLethality,
    required this.physicalVamp,
    required this.resourceMax,
    required this.resourceRegenRate,
    required this.resourceType,
    required this.resourceValue,
    required this.spellVamp,
    required this.tenacity,
  });

  int abilityHaste;
  int abilityPower;
  double armor;
  int armorPenetrationFlat;
  int armorPenetrationPercent;
  double attackDamage;
  int attackRange;
  double attackSpeed;
  int bonusArmorPenetrationPercent;
  int bonusMagicPenetrationPercent;
  double critChance;
  int critDamage;
  double currentHealth;
  int healShieldPower;
  double healthRegenRate;
  int lifeSteal;
  int magicLethality;
  int magicPenetrationFlat;
  int magicPenetrationPercent;
  double magicResist;
  double maxHealth;
  double moveSpeed;
  int omnivamp;
  int physicalLethality;
  int physicalVamp;
  double resourceMax;
  double resourceRegenRate;
  String resourceType;
  double resourceValue;
  int spellVamp;
  int tenacity;

  factory ChampionStats.fromMap(Map<String, dynamic> json) => ChampionStats(
        abilityHaste: json["abilityHaste"],
        abilityPower: json["abilityPower"],
        armor: json["armor"]?.toDouble(),
        armorPenetrationFlat: json["armorPenetrationFlat"],
        armorPenetrationPercent: json["armorPenetrationPercent"],
        attackDamage: json["attackDamage"]?.toDouble(),
        attackRange: json["attackRange"],
        attackSpeed: json["attackSpeed"]?.toDouble(),
        bonusArmorPenetrationPercent: json["bonusArmorPenetrationPercent"],
        bonusMagicPenetrationPercent: json["bonusMagicPenetrationPercent"],
        critChance: json["critChance"]?.toDouble(),
        critDamage: json["critDamage"],
        currentHealth: json["currentHealth"]?.toDouble(),
        healShieldPower: json["healShieldPower"],
        healthRegenRate: json["healthRegenRate"]?.toDouble(),
        lifeSteal: json["lifeSteal"],
        magicLethality: json["magicLethality"],
        magicPenetrationFlat: json["magicPenetrationFlat"],
        magicPenetrationPercent: json["magicPenetrationPercent"],
        magicResist: json["magicResist"]?.toDouble(),
        maxHealth: json["maxHealth"]?.toDouble(),
        moveSpeed: json["moveSpeed"]?.toDouble(),
        omnivamp: json["omnivamp"],
        physicalLethality: json["physicalLethality"],
        physicalVamp: json["physicalVamp"],
        resourceMax: json["resourceMax"]?.toDouble(),
        resourceRegenRate: json["resourceRegenRate"]?.toDouble(),
        resourceType: json["resourceType"],
        resourceValue: json["resourceValue"]?.toDouble(),
        spellVamp: json["spellVamp"],
        tenacity: json["tenacity"],
      );

  Map<String, dynamic> toMap() => {
        "abilityHaste": abilityHaste,
        "abilityPower": abilityPower,
        "armor": armor,
        "armorPenetrationFlat": armorPenetrationFlat,
        "armorPenetrationPercent": armorPenetrationPercent,
        "attackDamage": attackDamage,
        "attackRange": attackRange,
        "attackSpeed": attackSpeed,
        "bonusArmorPenetrationPercent": bonusArmorPenetrationPercent,
        "bonusMagicPenetrationPercent": bonusMagicPenetrationPercent,
        "critChance": critChance,
        "critDamage": critDamage,
        "currentHealth": currentHealth,
        "healShieldPower": healShieldPower,
        "healthRegenRate": healthRegenRate,
        "lifeSteal": lifeSteal,
        "magicLethality": magicLethality,
        "magicPenetrationFlat": magicPenetrationFlat,
        "magicPenetrationPercent": magicPenetrationPercent,
        "magicResist": magicResist,
        "maxHealth": maxHealth,
        "moveSpeed": moveSpeed,
        "omnivamp": omnivamp,
        "physicalLethality": physicalLethality,
        "physicalVamp": physicalVamp,
        "resourceMax": resourceMax,
        "resourceRegenRate": resourceRegenRate,
        "resourceType": resourceType,
        "resourceValue": resourceValue,
        "spellVamp": spellVamp,
        "tenacity": tenacity,
      };
}

class FullRunes {
  FullRunes({
    required this.generalRunes,
    required this.keystone,
    required this.primaryRuneTree,
    required this.secondaryRuneTree,
    required this.statRunes,
  });

  List<Keystone> generalRunes;
  Keystone keystone;
  Keystone primaryRuneTree;
  Keystone secondaryRuneTree;
  List<StatRune> statRunes;

  factory FullRunes.fromMap(Map<String, dynamic> json) => FullRunes(
        generalRunes: List<Keystone>.from(
            json["generalRunes"].map((x) => Keystone.fromMap(x))),
        keystone: Keystone.fromMap(json["keystone"]),
        primaryRuneTree: Keystone.fromMap(json["primaryRuneTree"]),
        secondaryRuneTree: Keystone.fromMap(json["secondaryRuneTree"]),
        statRunes: List<StatRune>.from(
            json["statRunes"].map((x) => StatRune.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "generalRunes": List<dynamic>.from(generalRunes.map((x) => x.toMap())),
        "keystone": keystone.toMap(),
        "primaryRuneTree": primaryRuneTree.toMap(),
        "secondaryRuneTree": secondaryRuneTree.toMap(),
        "statRunes": List<dynamic>.from(statRunes.map((x) => x.toMap())),
      };
}

class Keystone {
  Keystone({
    required this.displayName,
    required this.id,
    required this.rawDescription,
    required this.rawDisplayName,
  });

  String displayName;
  int id;
  String rawDescription;
  String rawDisplayName;

  factory Keystone.fromMap(Map<String, dynamic> json) => Keystone(
        displayName: json["displayName"],
        id: json["id"],
        rawDescription: json["rawDescription"],
        rawDisplayName: json["rawDisplayName"],
      );

  Map<String, dynamic> toMap() => {
        "displayName": displayName,
        "id": id,
        "rawDescription": rawDescription,
        "rawDisplayName": rawDisplayName,
      };
}

class StatRune {
  StatRune({
    required this.id,
    required this.rawDescription,
  });

  int id;
  String rawDescription;

  factory StatRune.fromMap(Map<String, dynamic> json) => StatRune(
        id: json["id"],
        rawDescription: json["rawDescription"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "rawDescription": rawDescription,
      };
}

class AllPlayer {
  AllPlayer({
    required this.championName,
    required this.isBot,
    required this.isDead,
    required this.items,
    required this.level,
    required this.position,
    required this.rawChampionName,
    required this.respawnTimer,
    this.runes,
    required this.scores,
    required this.skinId,
    required this.summonerName,
    required this.summonerSpells,
    required this.team,
    this.rawSkinName,
    this.skinName,
  });

  String championName;
  bool isBot;
  bool isDead;
  List<Item> items;
  int level;
  String position;
  String rawChampionName;
  int respawnTimer;
  Runes? runes;
  Scores scores;
  int skinId;
  String summonerName;
  SummonerSpells summonerSpells;
  String team;
  String? rawSkinName;
  String? skinName;

  factory AllPlayer.fromMap(Map<String, dynamic> json) => AllPlayer(
        championName: json["championName"],
        isBot: json["isBot"],
        isDead: json["isDead"],
        items: List<Item>.from(json["items"].map((x) => Item.fromMap(x))),
        level: json["level"],
        position: json["position"],
        rawChampionName: json["rawChampionName"],
        respawnTimer: json["respawnTimer"],
        runes: json["runes"] == null ? null : Runes.fromMap(json["runes"]),
        scores: Scores.fromMap(json["scores"]),
        skinId: json["skinID"],
        summonerName: json["summonerName"],
        summonerSpells: SummonerSpells.fromMap(json["summonerSpells"]),
        team: json["team"],
        rawSkinName: json["rawSkinName"],
        skinName: json["skinName"],
      );

  Map<String, dynamic> toMap() => {
        "championName": championName,
        "isBot": isBot,
        "isDead": isDead,
        "items": List<dynamic>.from(items.map((x) => x.toMap())),
        "level": level,
        "position": position,
        "rawChampionName": rawChampionName,
        "respawnTimer": respawnTimer,
        "runes": runes?.toMap(),
        "scores": scores.toMap(),
        "skinID": skinId,
        "summonerName": summonerName,
        "summonerSpells": summonerSpells.toMap(),
        "team": team,
        "rawSkinName": rawSkinName,
        "skinName": skinName,
      };
}

class Item {
  Item({
    required this.canUse,
    required this.consumable,
    required this.count,
    required this.displayName,
    required this.itemId,
    required this.price,
    required this.rawDescription,
    required this.rawDisplayName,
    required this.slot,
  });

  bool canUse;
  bool consumable;
  int count;
  String displayName;
  int itemId;
  int price;
  String rawDescription;
  String rawDisplayName;
  int slot;

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        canUse: json["canUse"],
        consumable: json["consumable"],
        count: json["count"],
        displayName: json["displayName"],
        itemId: json["itemID"],
        price: json["price"],
        rawDescription: json["rawDescription"],
        rawDisplayName: json["rawDisplayName"],
        slot: json["slot"],
      );

  Map<String, dynamic> toMap() => {
        "canUse": canUse,
        "consumable": consumable,
        "count": count,
        "displayName": displayName,
        "itemID": itemId,
        "price": price,
        "rawDescription": rawDescription,
        "rawDisplayName": rawDisplayName,
        "slot": slot,
      };
}

class Runes {
  Runes({
    required this.keystone,
    required this.primaryRuneTree,
    required this.secondaryRuneTree,
  });

  Keystone keystone;
  Keystone primaryRuneTree;
  Keystone secondaryRuneTree;

  factory Runes.fromMap(Map<String, dynamic> json) => Runes(
        keystone: Keystone.fromMap(json["keystone"]),
        primaryRuneTree: Keystone.fromMap(json["primaryRuneTree"]),
        secondaryRuneTree: Keystone.fromMap(json["secondaryRuneTree"]),
      );

  Map<String, dynamic> toMap() => {
        "keystone": keystone.toMap(),
        "primaryRuneTree": primaryRuneTree.toMap(),
        "secondaryRuneTree": secondaryRuneTree.toMap(),
      };
}

class Scores {
  Scores({
    required this.assists,
    required this.creepScore,
    required this.deaths,
    required this.kills,
    required this.wardScore,
  });

  int assists;
  int creepScore;
  int deaths;
  int kills;
  int wardScore;

  factory Scores.fromMap(Map<String, dynamic> json) => Scores(
        assists: json["assists"],
        creepScore: json["creepScore"],
        deaths: json["deaths"],
        kills: json["kills"],
        wardScore: json["wardScore"],
      );

  Map<String, dynamic> toMap() => {
        "assists": assists,
        "creepScore": creepScore,
        "deaths": deaths,
        "kills": kills,
        "wardScore": wardScore,
      };
}

class SummonerSpells {
  SummonerSpells({
    this.summonerSpellOne,
    this.summonerSpellTwo,
  });

  E? summonerSpellOne;
  E? summonerSpellTwo;

  factory SummonerSpells.fromMap(Map<String, dynamic> json) => SummonerSpells(
        summonerSpellOne: json["summonerSpellOne"] == null
            ? null
            : E.fromMap(json["summonerSpellOne"]),
        summonerSpellTwo: json["summonerSpellTwo"] == null
            ? null
            : E.fromMap(json["summonerSpellTwo"]),
      );

  Map<String, dynamic> toMap() => {
        "summonerSpellOne": summonerSpellOne?.toMap(),
        "summonerSpellTwo": summonerSpellTwo?.toMap(),
      };
}

class Events {
  Events({
    required this.events,
  });

  List<Event> events;

  factory Events.fromMap(Map<String, dynamic> json) => Events(
        events: List<Event>.from(json["Events"].map((x) => Event.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "Events": List<dynamic>.from(events.map((x) => x.toMap())),
      };
}

class Event {
  Event({
    required this.eventId,
    required this.eventName,
    required this.eventTime,
  });

  int eventId;
  String eventName;
  double eventTime;

  factory Event.fromMap(Map<String, dynamic> json) => Event(
        eventId: json["EventID"],
        eventName: json["EventName"],
        eventTime: json["EventTime"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "EventID": eventId,
        "EventName": eventName,
        "EventTime": eventTime,
      };
}

class GameData {
  GameData({
    required this.gameMode,
    required this.gameTime,
    required this.mapName,
    required this.mapNumber,
    required this.mapTerrain,
  });

  String gameMode;
  double gameTime;
  String mapName;
  int mapNumber;
  String mapTerrain;

  factory GameData.fromMap(Map<String, dynamic> json) => GameData(
        gameMode: json["gameMode"],
        gameTime: json["gameTime"]?.toDouble(),
        mapName: json["mapName"],
        mapNumber: json["mapNumber"],
        mapTerrain: json["mapTerrain"],
      );

  Map<String, dynamic> toMap() => {
        "gameMode": gameMode,
        "gameTime": gameTime,
        "mapName": mapName,
        "mapNumber": mapNumber,
        "mapTerrain": mapTerrain,
      };
}
