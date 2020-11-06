import 'package:Dia/shared/model/map_tools.dart';
import 'package:collection/collection.dart';
import 'base.dart';


Function eq = const ListEquality().equals;


class TraitType extends UserDataValueObject {
  final String unit;
  final List<String> options;

  TraitType(name, slug, this.unit, this.options) : super(name, slug);

  static TraitType fromJson(Map<String, dynamic> json) {
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

  dynamic getDefaultValue() {
    switch (slug) {
      case 'gender':
        return 'male';
      case 'birth-seconds-epoch':
        return DateTime.now().millisecondsSinceEpoch.toDouble() ~/ 1000.0;
      default:
        return 0;
    }
  }

  @override
  bool operator == (Object other) {
    return identical(this, other) ||
        other is TraitType &&
            runtimeType == other.runtimeType &&
            name == other.name &&
            slug == other.slug &&
            unit == other.unit;
  }

  @override
  int get hashCode => name.hashCode ^ slug.hashCode ^ unit.hashCode;

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
      eventDate: DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round()).toLocal(),
      entityType: json['entity_type'] != null ? json['entity_type'] : 'TraitMeasure',
      traitType: json['trait_type'] != null ? TraitType.fromJson(json['trait_type']) : null,
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_date': eventDate != null ? eventDate.microsecondsSinceEpoch.toDouble() / 1000000.0 : null,
      'entity_type': entityType,
      'trait_type': traitType != null ? traitType.toJson() : null,
      'value': value,
    };
  }

  Map<String, dynamic> changesToJson() {
    return mapDifferences(_original, toJson());
  }

  bool get hasChanged {
    return changesToJson().keys.length > 0;
  }

  TraitMeasure clone() {
    return TraitMeasure.fromJson(toJson());
  }

  void reset() {
    TraitMeasure original = TraitMeasure.fromJson(_original);
    this.eventDate = original.eventDate;
    this.traitType = original.traitType;
    this.value = original.value;
  }
}
