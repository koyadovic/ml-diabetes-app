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
  final double met;

  ActivityType(name, slug, this.met) : super(name, slug);

  factory ActivityType.fromJson(Map<String, dynamic> json) {
    return ActivityType(
      json['name'],
      json['slug'],
      json['met'],
    );
  }
}

class InsulinType extends UserDataValueObject {
  final List<String> categories;

  InsulinType(name, slug, this.categories) : super(name, slug);

  factory InsulinType.fromJson(Map<String, dynamic> json) {
    return InsulinType(
      json['name'],
      json['slug'],
      List<String>.from(json['categories']),
    );
  }
}

/*
Core Entities!
 */

class UserDataEntity {
  final int id;
  final DateTime eventDate;
  final int userId;
  final String entityType;

  UserDataEntity(this.id, this.eventDate, this.userId, this.entityType);

}


class GlucoseLevel extends UserDataEntity {
  final int level;

  GlucoseLevel({int id, DateTime eventDate, int userId, String entityType, this.level}) : super(id, eventDate, userId, entityType);

  factory GlucoseLevel.fromJson(Map<String, dynamic> json) {
    return GlucoseLevel(
      id: json['id'],
      eventDate: DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round()),
      userId: json['user_id'],
      entityType: json['entity_type'],
      level: (json['level'] as double).toInt(),
    );
  }

}

class Feeding extends UserDataEntity {
  final double carbGrams;
  final double carbSugarGrams;
  final double carbFiberGrams;
  final double proteinGrams;
  final double fatGrams;
  final double alcoholGrams;
  final double saltGrams;

  Feeding({int id, DateTime eventDate, int userId, String entityType,
    this.carbGrams, this.carbSugarGrams, this.carbFiberGrams,
    this.proteinGrams, this.fatGrams, this.alcoholGrams, this.saltGrams
  }) : super(id, eventDate, userId, entityType);

  factory Feeding.fromJson(Map<String, dynamic> json) {
    return Feeding(
      id: json['id'],
      eventDate: DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round()),
      userId: json['user_id'],
      entityType: json['entity_type'],
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
  final UserDataValueObject activityType;
  final double minutes;

  Activity({int id, DateTime eventDate, int userId, String entityType, this.activityType, this.minutes}) : super(id, eventDate, userId, entityType);

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      eventDate: DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round()),
      userId: json['user_id'],
      entityType: json['entity_type'],
      activityType: ActivityType.fromJson(json['activity_type']),
      minutes: json['minutes'],
    );
  }

  double get kCalBurned {

  }

}

class InsulinInjection extends UserDataEntity {
  final UserDataValueObject insulinType;
  final double units;

  InsulinInjection({int id, DateTime eventDate, int userId, String entityType, this.insulinType, this.units}) : super(id, eventDate, userId, entityType);

  factory InsulinInjection.fromJson(Map<String, dynamic> json) {
    return InsulinInjection(
      id: json['id'],
      eventDate: DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round()),
      userId: json['user_id'],
      entityType: json['entity_type'],
      insulinType: InsulinType.fromJson(json['insulin_type']),
      units: json['units'],
    );
  }

}

class TraitMeasure extends UserDataEntity {
  final UserDataValueObject traitType;
  final double value;

  TraitMeasure({int id, DateTime eventDate, int userId, String entityType, this.traitType, this.value}) : super(id, eventDate, userId, entityType);

  factory TraitMeasure.fromJson(Map<String, dynamic> json) {
    return TraitMeasure(
      id: json['id'],
      eventDate: DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round()),
      userId: json['user_id'],
      entityType: json['entity_type'],
      traitType: TraitType.fromJson(json['trait_type']),
      value: json['value'],
    );
  }

}


class Flag extends UserDataEntity {
  final String type;

  Flag({int id, DateTime eventDate, int userId, String entityType, this.type}) : super(id, eventDate, userId, entityType);

  factory Flag.fromJson(Map<String, dynamic> json) {
    return Flag(
      id: json['id'],
      eventDate: DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round()),
      userId: json['user_id'],
      entityType: json['entity_type'],
      type: json['type'],
    );
  }

}


/*
serialized.update({'entity_type': GlucoseLevel.__name__})
serialized.update({'entity_type': Feeding.__name__})
serialized.update({'entity_type': Activity.__name__})
serialized.update({'entity_type': InsulinInjection.__name__})
serialized.update({'entity_type': TraitMeasure.__name__})
serialized.update({'entity_type': Flag.__name__})

def serialize_trait_type(trait_type: TraitType):
    return {
        'name': trait_type.name,
        'slug': trait_type.slug,
        'unit': trait_type.unit,
        'options': trait_type.options,
    }


def serialize_insulin_type(insulin_type: InsulinType):
    return {
        'name': insulin_type.name,
        'slug': insulin_type.slug,
        'categories': insulin_type.catalog_insulin_type(),
    }


def serialize_activity_type(activity_type: ActivityType):
    return {
        'name': activity_type.name,
        'slug': activity_type.slug,
        'met': activity_type.METs,
    }

 */