import 'base.dart';


class Flag extends UserDataEntity {
  final String type;

  Flag({int id, DateTime eventDate, String entityType, this.type}) : super(id, eventDate, entityType);

  static Flag fromJson(Map<String, dynamic> json) {
    return Flag(
      id: json['id'],
      eventDate: json['event_date'] == null ? null : DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round()).toLocal(),
      entityType: json['entity_type'] != null ? json['entity_type'] : 'Flag',
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_date': eventDate != null ? eventDate.microsecondsSinceEpoch.toDouble() / 1000000.0 : null,
      'entity_type': entityType,
      'type': type,
    };
  }
}
