import 'package:Dia/shared/model/validations.dart';
import 'package:Dia/shared/tools/map_tools.dart';
import 'package:collection/collection.dart';
import 'base.dart';


Function eq = const ListEquality().equals;


class InsulinType extends UserDataValueObject {
  final List<String> categories;
  final int uPerMl;
  final String color;

  InsulinType(name, slug, this.categories, this.uPerMl, this.color) : super(name, slug);

  static InsulinType fromJson(Map<String, dynamic> json) {
    return InsulinType(
      json['name'],
      json['slug'],
      List<String>.from(json['categories']),
      json['u_per_ml'],
      json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'categories': categories,
      'u_per_ml': uPerMl,
      'color': color,
    };
  }

  @override
  bool operator == (Object other) {
    Function eq = const ListEquality().equals;
    return identical(this, other) ||
        other is InsulinType &&
            runtimeType == other.runtimeType &&
            name == other.name &&
            slug == other.slug &&
            uPerMl == other.uPerMl &&
            color == other.color &&
            eq(categories, other.categories);
  }

  @override
  int get hashCode => name.hashCode ^ slug.hashCode ^ uPerMl.hashCode ^ color.hashCode ^ categories.hashCode;

  String toString() => name;
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
      eventDate: json['event_date'] == null ? null : DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round(), isUtc: true).toLocal(),
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
