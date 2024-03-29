import 'package:iDietFit/shared/model/validations.dart';
import 'package:iDietFit/shared/tools/map_tools.dart';
import 'package:collection/collection.dart';
import 'base.dart';
import 'package:easy_localization/easy_localization.dart';


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

  String toString() => name;

}



class TraitMeasure extends UserDataEntity {
  TraitType traitType;
  dynamic value;
  Map<String, dynamic> _original;

  TraitMeasure({int id, DateTime eventDate, String entityType, this.traitType, this.value}) : super(id, eventDate, entityType) {
    _original = toJson();
  }

  static TraitMeasure fromJson(Map<String, dynamic> json) {
    return TraitMeasure(
      id: json['id'],
      eventDate: json['event_date'] == null ? null : DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round(), isUtc: true).toUtc(),
      entityType: json['entity_type'] != null ? json['entity_type'] : 'TraitMeasure',
      traitType: json['trait_type'] != null ? TraitType.fromJson(json['trait_type']) : null,
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_date': eventDate != null ? eventDate.toUtc().microsecondsSinceEpoch.toDouble() / 1000000.0 : null,
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

  /*
  Validations
   */

  @override
  Map<String, dynamic> toMapForValidation() {
    return {
      'traitType': traitType,
      'value': value,
    };
  }

  static Map<String, List<Validator>> validators = {
    'traitType': [NotNullValidator()],
    'value': [NotNullValidator()],
  };

  @override
  Map<String, List<Validator>> getValidators() {
    return TraitMeasure.validators;
  }

  @override
  void validate() {
    super.validate();
    if(isValid) {
      switch(traitType.slug) {
        case 'birth-seconds-epoch':
          if(!(value is double) && !(value is int)) {
            addPropertyValidationText('value', 'Invalid Date time'.tr());
          } else {
            try {
              DateTime now = DateTime.now();
              DateTime eighteenYearsAgo = DateTime(now.year - 18, now.month, now.day, now.hour, now.minute, now.second, now.millisecond, now.microsecond);
              DateTime parsed = DateTime.fromMillisecondsSinceEpoch((value * 1000.0).round(), isUtc: true);
              // Disabled by now
              // if(parsed.millisecondsSinceEpoch > eighteenYearsAgo.millisecondsSinceEpoch) {
              //   addPropertyValidationText('value', 'You don\'t have a minimum of 18 years old.');
              // }
            } catch (err) {
              addPropertyValidationText('value', 'Invalid date'.tr());
            }
          }
          break;
        case 'gender':
          if(!(value is String) && !['male', 'female'].contains(value)) {
            addPropertyValidationText('value', 'Value not is male or female'.tr());
          }
          break;
        default:
          if(value < 1) {
            addPropertyValidationText('value', 'Value cannot be zero'.tr());
          }
      }
    }
  }

  bool operator == (o) => o is TraitMeasure && o.id == id && o.traitType == traitType && o.value == value && o.eventDate == eventDate;
  int get hashCode => id.hashCode ^ traitType.hashCode ^ value.hashCode ^ eventDate.hashCode;

}
