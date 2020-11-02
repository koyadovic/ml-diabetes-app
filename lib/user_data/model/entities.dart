/*
TYPES!
 */

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

  GlucoseLevel({int id, DateTime eventDate, String entityType, this.level}) : super(id, eventDate, entityType);

  factory GlucoseLevel.fromJson(Map<String, dynamic> json) {
    return GlucoseLevel(
      id: json['id'],
      eventDate: DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round()),
      entityType: json['entity_type'] != null ? json['entity_type'] : 'GlucoseLevel',
      level: json['level'].toInt(),
    );
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

  Feeding({int id, DateTime eventDate, String entityType,
    this.carbGrams, this.carbSugarGrams, this.carbFiberGrams,
    this.proteinGrams, this.fatGrams, this.alcoholGrams, this.saltGrams
  }) : super(id, eventDate, entityType);

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

  double get kCal {
    return (carbGrams - carbFiberGrams) * 4 + proteinGrams * 4 + fatGrams * 9 + alcoholGrams * 7;
  }

}


class Activity extends UserDataEntity {
  ActivityType activityType;
  int minutes;

  Activity({int id, DateTime eventDate, String entityType, this.activityType, this.minutes}) : super(id, eventDate, entityType);

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      eventDate: DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round()),
      entityType: json['entity_type'] != null ? json['entity_type'] : 'Activity',
      activityType: ActivityType.fromJson(json['activity_type']),
      minutes: json['minutes'],
    );
  }

  double getKCalBurned (double kg) {
    double mets = activityType.mets * (minutes / 60.0);
    return mets * kg;
  }

}

class InsulinInjection extends UserDataEntity {
  InsulinType insulinType;
  int units;

  InsulinInjection({int id, DateTime eventDate, String entityType, this.insulinType, this.units}) : super(id, eventDate, entityType);

  factory InsulinInjection.fromJson(Map<String, dynamic> json) {
    return InsulinInjection(
      id: json['id'],
      eventDate: DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round()),
      entityType: json['entity_type'] != null ? json['entity_type'] : 'InsulinInjection',
      insulinType: InsulinType.fromJson(json['insulin_type']),
      units: json['units'],
    );
  }

}

class TraitMeasure extends UserDataEntity {
  TraitType traitType;
  dynamic value;

  TraitMeasure({int id, DateTime eventDate, String entityType, this.traitType, this.value}) : super(id, eventDate, entityType);

  factory TraitMeasure.fromJson(Map<String, dynamic> json) {
    return TraitMeasure(
      id: json['id'],
      eventDate: DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round()),
      entityType: json['entity_type'] != null ? json['entity_type'] : 'TraitMeasure',
      traitType: TraitType.fromJson(json['trait_type']),
      value: json['value'],
    );
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

}
