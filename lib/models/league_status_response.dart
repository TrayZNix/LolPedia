class LeagueStatusResponse {
  LeagueStatusResponse({
    required this.id,
    required this.name,
    required this.locales,
    required this.maintenances,
    required this.incidents,
  });
  late final String id;
  late final String name;
  late final List<String> locales;
  late final List<Maintenances> maintenances;
  late final List<Incidents> incidents;

  LeagueStatusResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    locales = List.castFrom<dynamic, String>(json['locales']);
    maintenances = List.from(json['maintenances'])
        .map((e) => Maintenances.fromJson(e))
        .toList();
    incidents =
        List.from(json['incidents']).map((e) => Incidents.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['locales'] = locales;
    _data['maintenances'] = maintenances.map((e) => e.toJson()).toList();
    _data['incidents'] = incidents.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Maintenances {
  Maintenances({
    required this.archiveAt,
    required this.titles,
    required this.maintenanceStatus,
    required this.id,
    required this.createdAt,
    required this.updates,
    required this.incidentSeverity,
    required this.platforms,
    required this.updatedAt,
  });
  late final String archiveAt;
  late final List<Titles> titles;
  late final String maintenanceStatus;
  late final int id;
  late final String createdAt;
  late final List<Updates> updates;
  late final String? incidentSeverity;
  late final List<String> platforms;
  late final DateTime? updatedAt;

  Maintenances.fromJson(Map<String, dynamic> json) {
    archiveAt = json['archive_at'];
    titles = List.from(json['titles']).map((e) => Titles.fromJson(e)).toList();
    maintenanceStatus = json['maintenance_status'];
    id = json['id'];
    createdAt = json['created_at'];
    updates =
        List.from(json['updates']).map((e) => Updates.fromJson(e)).toList();
    incidentSeverity = json['incident_severity'];
    platforms = List.castFrom<dynamic, String>(json['platforms']);
    updatedAt =
        json['updated_at'] == null ? null : DateTime.parse(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['archive_at'] = archiveAt;
    _data['titles'] = titles.map((e) => e.toJson()).toList();
    _data['maintenance_status'] = maintenanceStatus;
    _data['id'] = id;
    _data['created_at'] = createdAt;
    _data['updates'] = updates.map((e) => e.toJson()).toList();
    _data['incident_severity'] = incidentSeverity;
    _data['platforms'] = platforms;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}

class Titles {
  Titles({
    required this.content,
    required this.locale,
  });
  late final String content;
  late final String locale;

  Titles.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    locale = json['locale'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['content'] = content;
    _data['locale'] = locale;
    return _data;
  }
}

class Updates {
  Updates({
    required this.translations,
    required this.id,
    required this.createdAt,
    required this.publish,
    required this.updatedAt,
    required this.author,
    required this.publishLocations,
  });
  late final List<Translations> translations;
  late final int id;
  late final DateTime? createdAt;
  late final bool publish;
  late final DateTime? updatedAt;
  late final String author;
  late final List<String> publishLocations;

  Updates.fromJson(Map<String, dynamic> json) {
    translations = List.from(json['translations'])
        .map((e) => Translations.fromJson(e))
        .toList();
    id = json['id'];
    createdAt =
        json['created_at'] == null ? null : DateTime.parse(json['created_at']);
    publish = json['publish'];
    updatedAt =
        json['updated_at'] == null ? null : DateTime.parse(json['updated_at']);
    author = json['author'];
    publishLocations =
        List.castFrom<dynamic, String>(json['publish_locations']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['translations'] = translations.map((e) => e.toJson()).toList();
    _data['id'] = id;
    _data['created_at'] = createdAt;
    _data['publish'] = publish;
    _data['updated_at'] = updatedAt;
    _data['author'] = author;
    _data['publish_locations'] = publishLocations;
    return _data;
  }
}

class Translations {
  Translations({
    required this.content,
    required this.locale,
  });
  late final String content;
  late final String locale;

  Translations.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    locale = json['locale'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['content'] = content;
    _data['locale'] = locale;
    return _data;
  }
}

class Incidents {
  Incidents({
    this.archiveAt,
    this.id,
    this.updates,
    this.createdAt,
    this.maintenanceStatus,
    required this.updatedAt,
    required this.platforms,
    this.titles,
    this.incidentSeverity,
  });
  late final String? archiveAt;
  late final int? id;
  late final List<Updates>? updates;
  late final String? createdAt;
  late final String? maintenanceStatus;
  late final DateTime? updatedAt;
  late final List<String> platforms;
  late final List<Titles>? titles;
  late final String? incidentSeverity;

  Incidents.fromJson(Map<String, dynamic> json) {
    archiveAt = json['archive_at'];
    id = json['id'];
    updates =
        List.from(json['updates']).map((e) => Updates.fromJson(e)).toList();
    createdAt = json['created_at'];
    maintenanceStatus = json['maintenance_status'];
    updatedAt =
        json['updated_at'] == null ? null : DateTime.parse(json['updated_at']);
    platforms = List<String>.from(json['platforms']);
    titles = List.from(json['titles']).map((e) => Titles.fromJson(e)).toList();
    incidentSeverity = json['incident_severity'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['archive_at'] = archiveAt;
    _data['id'] = id;
    _data['updates'] = updates;
    _data['created_at'] = createdAt;
    _data['maintenance_status'] = maintenanceStatus;
    _data['updated_at'] = updatedAt;
    _data['platforms'] = platforms;
    _data['titles'] = titles;
    _data['incident_severity'] = incidentSeverity;
    return _data;
  }
}

class Id {
  Id({
    required this.locale,
    required this.content,
  });
  late final String locale;
  late final String content;

  Id.fromJson(Map<String, dynamic> json) {
    locale = json['locale'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['locale'] = locale;
    _data['content'] = content;
    return _data;
  }
}

class UpdatedAt {
  UpdatedAt({
    required this.content,
    required this.locale,
  });
  late final String content;
  late final String locale;

  UpdatedAt.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    locale = json['locale'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['content'] = content;
    _data['locale'] = locale;
    return _data;
  }
}

class IncidentSeverity {
  IncidentSeverity({
    required this.createdAt,
    required this.author,
    required this.publish,
    required this.translations,
    required this.publishLocations,
    required this.id,
    required this.updatedAt,
  });
  late final String createdAt;
  late final String author;
  late final bool publish;
  late final List<Translations> translations;
  late final List<String> publishLocations;
  late final int id;
  late final String updatedAt;

  IncidentSeverity.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    author = json['author'];
    publish = json['publish'];
    translations = List.from(json['translations'])
        .map((e) => Translations.fromJson(e))
        .toList();
    publishLocations =
        List.castFrom<dynamic, String>(json['publish_locations']);
    id = json['id'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['created_at'] = createdAt;
    _data['author'] = author;
    _data['publish'] = publish;
    _data['translations'] = translations.map((e) => e.toJson()).toList();
    _data['publish_locations'] = publishLocations;
    _data['id'] = id;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}
