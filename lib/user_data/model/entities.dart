/*
TYPES!
 */

import 'package:Dia/shared/model/tools.dart';

class UserDataValueObject {
  final String name;
  final String slug;
  UserDataValueObject(this.name, this.slug);
}


class TraitType extends UserDataValueObject {
  final String unit;
  final List<String> options;

  TraitType(name, slug, this.unit, this.options) : super(name, slug);

  factory TraitType.fromJson(Map<String, dynamic> json) {
    return TraitType(
      json['name'],
      json['slug'],
      json['unit'],
      List<String>.from(json['options']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'unit': unit,
      'options': options,
    };
  }
}

class ActivityType extends UserDataValueObject {
  final double mets;

  ActivityType(name, slug, this.mets) : super(name, slug);

  factory ActivityType.fromJson(Map<String, dynamic> json) {
    return ActivityType(
      json['name'],
      json['slug'],
      json['METs'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'METs': mets,
    };
  }
}

class InsulinType extends UserDataValueObject {
  final List<String> categories;
  final int uPerMl;

  InsulinType(name, slug, this.categories, this.uPerMl) : super(name, slug);

  factory InsulinType.fromJson(Map<String, dynamic> json) {
    return InsulinType(
      json['name'],
      json['slug'],
      List<String>.from(json['categories']),
      json['u_per_ml'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'categories': categories,
      'u_per_ml': uPerMl,
    };
  }
}

/*
Core Entities!
 */

class UserDataEntity {
  final int id;
  final DateTime eventDate;
  final String entityType;

  UserDataEntity(this.id, this.eventDate, this.entityType);
}


class GlucoseLevel extends UserDataEntity {
  int level;
  Map<String, dynamic> _original;

  GlucoseLevel({int id, DateTime eventDate, String entityType, this.level}) : super(id, eventDate, entityType) {
    _original = toJson();
  }

  factory GlucoseLevel.fromJson(Map<String, dynamic> json) {
    return GlucoseLevel(
      id: json['id'],
      eventDate: DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round()),
      entityType: json['entity_type'] != null ? json['entity_type'] : 'GlucoseLevel',
      level: json['level'].toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_date': eventDate.microsecondsSinceEpoch.toDouble() / 1000000.0,
      'entity_type': entityType,
      'level': level,
    };
  }

  Map<String, dynamic> changesToJson() {
    return mapDifferences(_original, toJson());
  }
}

class Feeding extends UserDataEntity {
  double carbGrams;
  double carbSugarGrams;
  double carbFiberGrams;
  double proteinGrams;
  double fatGrams;
  double alcoholGrams;
  double saltGrams;

  Map<String, dynamic> _original;

  Feeding({int id, DateTime eventDate, String entityType,
    this.carbGrams, this.carbSugarGrams, this.carbFiberGrams,
    this.proteinGrams, this.fatGrams, this.alcoholGrams, this.saltGrams
  }) : super(id, eventDate, entityType) {
    _original = toJson();
  }

  double get kCal {
    return (carbGrams - carbFiberGrams) * 4 + proteinGrams * 4 + fatGrams * 9 + alcoholGrams * 7;
  }

  factory Feeding.fromJson(Map<String, dynamic> json) {
    return Feeding(
      id: json['id'],
      eventDate: DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round()),
      entityType: json['entity_type'] != null ? json['entity_type'] : 'Feeding',
      carbGrams: json['carb_g'],
      carbSugarGrams: json['carb_sugar_g'],
      carbFiberGrams: json['carb_fiber_g'],
      proteinGrams: json['protein_g'],
      fatGrams: json['fat_g'],
      alcoholGrams: json['alcohol_g'],
      saltGrams: json['salt_g'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_date': eventDate.microsecondsSinceEpoch.toDouble() / 1000000.0,
      'entity_type': entityType,
      'carb_g': carbGrams,
      'carb_sugar_g': carbSugarGrams,
      'carb_fiber_g': carbFiberGrams,
      'protein_g': proteinGrams,
      'fat_g': fatGrams,
      'alcohol_g': alcoholGrams,
      'salt_g': saltGrams,
    };
  }

  Map<String, dynamic> changesToJson() {
    return mapDifferences(_original, toJson());
  }
}


class Activity extends UserDataEntity {
  ActivityType activityType;
  int minutes;

  Map<String, dynamic> _original;

  Activity({int id, DateTime eventDate, String entityType, this.activityType, this.minutes}) : super(id, eventDate, entityType) {
    _original = toJson();
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      eventDate: DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round()),
      entityType: json['entity_type'] != null ? json['entity_type'] : 'Activity',
      activityType: ActivityType.fromJson(json['activity_type']),
      minutes: json['minutes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_date': eventDate.microsecondsSinceEpoch.toDouble() / 1000000.0,
      'entity_type': entityType,
      'activity_type': activityType.toJson(),
      'minutes': minutes,
    };
  }

  double getKCalBurned (double kg) {
    double mets = activityType.mets * (minutes / 60.0);
    return mets * kg;
  }

  Map<String, dynamic> changesToJson() {
    return mapDifferences(_original, toJson());
  }
}

class InsulinInjection extends UserDataEntity {
  InsulinType insulinType;
  int units;

  Map<String, dynamic> _original;

  InsulinInjection({int id, DateTime eventDate, String entityType, this.insulinType, this.units}) : super(id, eventDate, entityType) {
    _original = toJson();
  }

  factory InsulinInjection.fromJson(Map<String, dynamic> json) {
    return InsulinInjection(
      id: json['id'],
      eventDate: DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round()),
      entityType: json['entity_type'] != null ? json['entity_type'] : 'InsulinInjection',
      insulinType: InsulinType.fromJson(json['insulin_type']),
      units: json['units'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_date': eventDate.microsecondsSinceEpoch.toDouble() / 1000000.0,
      'entity_type': entityType,
      'insulin_type': insulinType.toJson(),
      'units': units,
    };
  }

  Map<String, dynamic> changesToJson() {
    return mapDifferences(_original, toJson());
  }
}

class TraitMeasure extends UserDataEntity {
  TraitType traitType;
  dynamic value;

  Map<String, dynamic> _original;

  TraitMeasure({int id, DateTime eventDate, String entityType, this.traitType, this.value}) : super(id, eventDate, entityType) {
    _original = toJson();
  }

  factory TraitMeasure.fromJson(Map<String, dynamic> json) {
    return TraitMeasure(
      id: json['id'],
      eventDate: DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round()),
      entityType: json['entity_type'] != null ? json['entity_type'] : 'TraitMeasure',
      traitType: TraitType.fromJson(json['trait_type']),
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_date': eventDate.microsecondsSinceEpoch.toDouble() / 1000000.0,
      'entity_type': entityType,
      'trait_type': traitType.toJson(),
      'value': value,
    };
  }

  Map<String, dynamic> changesToJson() {
    return mapDifferences(_original, toJson());
  }
}


class Flag extends UserDataEntity {
  final String type;

  Flag({int id, DateTime eventDate, String entityType, this.type}) : super(id, eventDate, entityType);

  factory Flag.fromJson(Map<String, dynamic> json) {
    return Flag(
      id: json['id'],
      eventDate: DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round()),
      entityType: json['entity_type'] != null ? json['entity_type'] : 'Flag',
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_date': eventDate.microsecondsSinceEpoch.toDouble() / 1000000.0,
      'entity_type': entityType,
      'type': type,
    };
  }
}
