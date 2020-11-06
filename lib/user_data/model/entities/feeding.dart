
import 'package:Dia/shared/model/map_tools.dart';

import 'base.dart';

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

  static Feeding fromJson(Map<String, dynamic> json) {
    return Feeding(
      id: json['id'],
      eventDate: DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round()).toLocal(),
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
      'event_date': eventDate != null ? eventDate.microsecondsSinceEpoch.toDouble() / 1000000.0 : null,
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

  bool get hasChanged {
    return changesToJson().keys.length > 0;
  }

  Feeding clone() {
    return Feeding.fromJson(toJson());
  }

  void reset() {
    Feeding original = Feeding.fromJson(_original);
    this.eventDate = original.eventDate;
    this.carbGrams = original.carbGrams;
    this.carbSugarGrams = original.carbSugarGrams;
    this.carbFiberGrams = original.carbFiberGrams;
    this.proteinGrams = original.proteinGrams;
    this.fatGrams = original.fatGrams;
    this.alcoholGrams = original.alcoholGrams;
    this.saltGrams = original.saltGrams;
  }
}

