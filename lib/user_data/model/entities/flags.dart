import 'package:Dia/shared/model/validations.dart';

import 'base.dart';


class Flag extends UserDataEntity {
  static const String TYPE_INSULIN_REGIMEN_CHANGED = 'insulin-regimen-change-time';
  static const String TYPE_HYPOGLYCEMIA = 'hypoglycemia';
  final String type;

  Flag({int id, DateTime eventDate, String entityType, this.type}) : super(id, eventDate, entityType);

  static Flag fromJson(Map<String, dynamic> json) {
    return Flag(
      id: json['id'],
      eventDate: json['event_date'] == null ? null : DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round(), isUtc: true).toLocal(),
      entityType: json['entity_type'] != null ? json['entity_type'] : 'Flag',
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_date': eventDate != null ? eventDate.toUtc().microsecondsSinceEpoch.toDouble() / 1000000.0 : null,
      'entity_type': entityType,
      'type': type,
    };
  }

  /*
  Validations
   */

  @override
  Map<String, dynamic> toMapForValidation() {
    return {
      'type': type,
    };
  }

  static Map<String, List<Validator>> validators = {
    'type': [InValidator<String>([Flag.TYPE_INSULIN_REGIMEN_CHANGED, Flag.TYPE_HYPOGLYCEMIA])],
  };

  @override
  Map<String, List<Validator>> getValidators() {
    return Flag.validators;
  }

  bool operator == (o) => o is Flag && o.id == id && o.eventDate == eventDate && o.type == type;
  int get hashCode => id.hashCode ^ eventDate.hashCode ^ type.hashCode;

}
