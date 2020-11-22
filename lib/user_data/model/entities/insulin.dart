import 'package:flutter/material.dart';
import 'package:iDietFit/shared/model/validations.dart';
import 'package:iDietFit/shared/tools/map_tools.dart';
import 'package:collection/collection.dart';
import 'base.dart';


Function eq = const ListEquality().equals;


abstract class InsulinType extends UserDataValueObject {
  final List<String> categories;
  final int uPerMl;
  final String color;

  InsulinType(name, slug, this.categories, this.uPerMl, this.color) : super(name, slug);

  static InsulinType fromJson(Map<String, dynamic> json) {
    if(json.containsKey('insulin_type_1')){
      return MixedInsulinType.fromJson(json);
    }
    return SingleInsulinType.fromJson(json);
  }

  Color getFlutterColor() {
    String externalColor = color;
    if (externalColor.substring(0, 1) == '#') {
      externalColor = externalColor.substring(1);
    }
    if(externalColor.length == 6) {
      externalColor = externalColor + 'ff';
    }
    externalColor = externalColor.substring(6, 8) + externalColor.substring(0, 6);
    return Color(int.parse(externalColor, radix: 16));
  }

  Map<String, dynamic> toJson();

  String toString() => name;

}


class SingleInsulinType extends InsulinType {
  final int onset;
  final int peakStart;
  final int peakEnd;
  final int duration;

  SingleInsulinType(name, slug, categories, uPerMl, color, this.onset, this.peakStart, this.peakEnd, this.duration) : super(name, slug, categories, uPerMl, color);

  static SingleInsulinType fromJson(Map<String, dynamic> json) {
    return SingleInsulinType(
      json['name'],
      json['slug'],
      List<String>.from(json['categories']),
      json['u_per_ml'],
      json['color'],
      json['onset'],
      json['peak_start'],
      json['peak_end'],
      json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'categories': categories,
      'u_per_ml': uPerMl,
      'color': color,
      'onset': onset,
      'peak_start': peakStart,
      'peak_end': peakEnd,
      'duration': duration,
    };
  }

  @override
  bool operator == (Object other) {
    Function eq = const ListEquality().equals;
    return identical(this, other) ||
        other is SingleInsulinType &&
            name == other.name &&
            slug == other.slug &&
            uPerMl == other.uPerMl &&
            color == other.color &&
            eq(categories, other.categories) &&
            onset == other.onset &&
            peakStart == other.peakStart &&
            peakEnd == other.peakEnd &&
            duration == other.duration;
  }

  @override
  int get hashCode => name.hashCode ^ slug.hashCode ^ uPerMl.hashCode ^ color.hashCode ^ categories.hashCode ^ onset.hashCode ^ peakStart.hashCode ^ peakEnd.hashCode ^ duration.hashCode;
}

class MixedInsulinType extends InsulinType {
  final SingleInsulinType insulinType1;
  final double insulinType1Percentage;
  final SingleInsulinType insulinType2;
  final double insulinType2Percentage;

  MixedInsulinType(name, slug, categories, uPerMl, color, this.insulinType1, this.insulinType1Percentage, this.insulinType2, this.insulinType2Percentage) : super(name, slug, categories, uPerMl, color);

  static MixedInsulinType fromJson(Map<String, dynamic> json) {
    return MixedInsulinType(
      json['name'],
      json['slug'],
      List<String>.from(json['categories']),
      json['u_per_ml'],
      json['color'],
      SingleInsulinType.fromJson(json['insulin_type_1']),
      json['insulin_type_1_percentage'],
      SingleInsulinType.fromJson(json['insulin_type_2']),
      json['insulin_type_2_percentage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'categories': categories,
      'u_per_ml': uPerMl,
      'color': color,
      'insulin_type_1': insulinType1.toJson(),
      'insulin_type_1_percentage': insulinType1Percentage,
      'insulin_type_2': insulinType2.toJson(),
      'insulin_type_2_percentage': insulinType2Percentage,
    };
  }

  @override
  bool operator == (Object other) {
    Function eq = const ListEquality().equals;
    return identical(this, other) ||
        other is MixedInsulinType &&
            name == other.name &&
            slug == other.slug &&
            uPerMl == other.uPerMl &&
            color == other.color &&
            eq(categories, other.categories) &&
            insulinType1 == other.insulinType1 &&
            insulinType1Percentage == other.insulinType1Percentage &&
            insulinType2 == other.insulinType2 &&
            insulinType2Percentage == other.insulinType2Percentage;
  }
  @override
  int get hashCode => name.hashCode ^ slug.hashCode ^ uPerMl.hashCode ^ color.hashCode ^ categories.hashCode ^ insulinType1.hashCode ^ insulinType1Percentage.hashCode ^ insulinType2.hashCode ^ insulinType2Percentage.hashCode;
}



class InsulinInjection extends UserDataEntity {
  InsulinType insulinType;
  int units;

  Map<String, dynamic> _original;

  InsulinInjection({int id, DateTime eventDate, String entityType, this.insulinType, this.units}) : super(id, eventDate, entityType) {
    _original = toJson();
  }

  static InsulinInjection fromJson(Map<String, dynamic> json) {
    return InsulinInjection(
      id: json['id'],
      eventDate: json['event_date'] == null ? null : DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round(), isUtc: true).toUtc(),
      entityType: json['entity_type'] != null ? json['entity_type'] : 'InsulinInjection',
      insulinType: json['insulin_type'] != null ? InsulinType.fromJson(json['insulin_type']) : null,
      units: json['units'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_date': eventDate != null ? eventDate.toUtc().microsecondsSinceEpoch.toDouble() / 1000000.0 : null,
      'entity_type': entityType,
      'insulin_type': insulinType != null ? insulinType.toJson() : null,
      'units': units,
    };
  }

  Map<String, dynamic> changesToJson() {
    return mapDifferences(_original, toJson());
  }

  bool get hasChanged {
    print('hasChanged ${changesToJson().toString()}');
    return changesToJson().keys.length > 0;
  }

  InsulinInjection clone() {
    return InsulinInjection.fromJson(toJson());
  }

  void reset() {
    InsulinInjection original = InsulinInjection.fromJson(_original);
    this.eventDate = original.eventDate;
    this.insulinType = original.insulinType;
    this.units = original.units;
  }

  /*
  Validations
   */

  @override
  Map<String, dynamic> toMapForValidation() {
    return {
      'insulinType': insulinType,
      'units': units,
    };
  }

  static Map<String, List<Validator>> validators = {
    'insulinType': [NotNullValidator()],
    'units': [NotNullValidator(), OneOrGreaterPositiveNumberValidator()],
  };

  @override
  Map<String, List<Validator>> getValidators() {
    return InsulinInjection.validators;
  }

  bool operator == (o) => o is InsulinInjection && o.id == id && o.insulinType == insulinType && o.units == units && o.eventDate == eventDate;
  int get hashCode => id.hashCode ^ insulinType.hashCode ^ units.hashCode ^ eventDate.hashCode;
}
