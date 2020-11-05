import 'package:Dia/shared/model/map_tools.dart';
import 'package:collection/collection.dart';
import 'base.dart';


Function eq = const ListEquality().equals;


class InsulinType extends UserDataValueObject {
  final List<String> categories;
  final int uPerMl;
  final String color;

  InsulinType(name, slug, this.categories, this.uPerMl, this.color) : super(name, slug);

  factory InsulinType.fromJson(Map<String, dynamic> json) {
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
      eventDate: DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round()).toLocal(),
      entityType: json['entity_type'] != null ? json['entity_type'] : 'InsulinInjection',
      insulinType: json['insulin_type'] != null ? InsulinType.fromJson(json['insulin_type']) : null,
      units: json['units'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_date': eventDate != null ? eventDate.microsecondsSinceEpoch.toDouble() / 1000000.0 : null,
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
}
