
import 'package:Dia/shared/model/map_tools.dart';

import 'base.dart';

class GlucoseLevel extends UserDataEntity {
  int level;
  Map<String, dynamic> _original;

  GlucoseLevel({int id, DateTime eventDate, String entityType, this.level}) : super(id, eventDate, entityType) {
    _original = toJson();
  }

  static GlucoseLevel fromJson(Map<String, dynamic> json) {
    return GlucoseLevel(
      id: json['id'],
      eventDate: DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round()).toLocal(),
      entityType: json['entity_type'] != null ? json['entity_type'] : 'GlucoseLevel',
      level: json['level'].toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_date': eventDate != null ? eventDate.microsecondsSinceEpoch.toDouble() / 1000000.0 : null,
      'entity_type': entityType,
      'level': level,
    };
  }

  Map<String, dynamic> changesToJson() {
    return mapDifferences(_original, toJson());
  }

  bool get hasChanged {
    return changesToJson().keys.length > 0;
  }

  GlucoseLevel clone() {
    return GlucoseLevel.fromJson(toJson());
  }

  void reset() {
    GlucoseLevel original = GlucoseLevel.fromJson(_original);
    this.eventDate = original.eventDate;
    this.level = original.level;
  }
}
