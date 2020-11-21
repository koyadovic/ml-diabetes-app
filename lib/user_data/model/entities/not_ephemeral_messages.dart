import 'package:iDietFit/shared/model/validations.dart';
import 'package:iDietFit/user_data/model/entities/base.dart';

class NotEphemeralMessage extends UserDataEntity {
  static const String TYPE_INFORMATION = 'information';
  static const String TYPE_WARNING = 'warning';
  static const String TYPE_ERROR = 'error';

  final String type;
  final String title;
  final String text;
  final Map<String, dynamic> payload;
  final bool attendImmediately;

  NotEphemeralMessage({
    int id,
    DateTime eventDate,
    String entityType,
    this.type,
    this.title,
    this.text,
    this.payload,
    this.attendImmediately
  }) : super(id, eventDate, entityType);

  static NotEphemeralMessage fromJson(Map<String, dynamic> json) {
    return NotEphemeralMessage(
      id: json['id'],
      eventDate: DateTime.fromMicrosecondsSinceEpoch((json['delivery_date'] * 1000000).toInt()).toUtc(),
      entityType: 'NotEphemeralMessage',
      type: json['type'],
      title: json['title'],
      text: json['text'],
      payload: json['payload'],
      attendImmediately: json['attend_immediately'],
    );
  }

  String toString() {
    return this.title + ': ' + this.text + ', ' + this.payload.toString();
  }

  @override
  Map<String, List<Validator>> getValidators() {
    return {};
  }
}
