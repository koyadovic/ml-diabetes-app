import 'package:Dia/shared/model/validations.dart';
import 'package:Dia/shared/tools/map_tools.dart';

import 'base.dart';

class ActivityType extends UserDataValueObject {
  final double mets;

  ActivityType(name, slug, this.mets) : super(name, slug);

  static ActivityType fromJson(Map<String, dynamic> json) {
    return ActivityType(
      json['name'],
      json['slug'],
      json['METs'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'METs': mets,
    };
  }

  @override
  bool operator == (Object other) {
    return identical(this, other) ||
        other is ActivityType &&
            runtimeType == other.runtimeType &&
            name == other.name &&
            slug == other.slug &&
            mets == other.mets;
  }

  @override
  int get hashCode => name.hashCode ^ slug.hashCode ^ mets.hashCode;
}



class Activity extends UserDataEntity {
  ActivityType activityType;
  int minutes;
  Map<String, dynamic> _original;

  Activity({int id, DateTime eventDate, String entityType, this.activityType, this.minutes}) : super(id, eventDate, entityType) {
    _original = toJson();
  }

  static Activity fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      eventDate: json['event_date'] == null ? null : DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round(), isUtc: true).toLocal(),
      entityType: json['entity_type'] != null ? json['entity_type'] : 'Activity',
      activityType: json['activity_type'] != null ? ActivityType.fromJson(json['activity_type']) : null,
      minutes: json['minutes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_date': eventDate != null ? eventDate.toUtc().microsecondsSinceEpoch.toDouble() / 1000000.0 : null,
      'entity_type': entityType,
      'activity_type': activityType != null ? activityType.toJson() : activityType,
      'minutes': minutes,
    };
  }

  double getKCalBurned (double kg) {
    double mets = activityType.mets * (minutes / 60.0);
    return mets * kg;
  }

  Map<String, dynamic> changesToJson() {
    return mapDifferences(_original, toJson());
  }

  bool get hasChanged {
    return changesToJson().keys.length > 0;
  }

  Activity clone() {
    return Activity.fromJson(toJson());
  }

  void reset() {
    Activity original = Activity.fromJson(_original);
    this.eventDate = original.eventDate;
    this.activityType = original.activityType;
    this.minutes = original.minutes;
  }

  /*
  Validations
   */

  @override
  Map<String, dynamic> toMapForValidation() {
    return {
      'activityType': activityType,
      'minutes': minutes,
    };
  }

  static Map<String, List<Validator>> validators = {
    'minutes': [NotNullValidator(), OneOrGreaterPositiveNumberValidator()],
    'activityType': [NotNullValidator(),],
  };

  @override
  Map<String, List<Validator>> getValidators() {
    return Activity.validators;
  }

  bool operator == (o) => o is Activity && o.id == id && o.activityType == activityType && o.minutes == minutes && o.eventDate == eventDate;
  int get hashCode => id.hashCode ^ activityType.hashCode ^ minutes.hashCode ^ eventDate.hashCode;
}
