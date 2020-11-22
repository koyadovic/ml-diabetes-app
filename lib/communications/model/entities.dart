
import 'package:iDietFit/user_data/model/entities/activities.dart';
import 'package:iDietFit/user_data/model/entities/base.dart';
import 'package:iDietFit/user_data/model/entities/feeding.dart';
import 'package:iDietFit/user_data/model/entities/glucose.dart';
import 'package:iDietFit/user_data/model/entities/insulin.dart';
import 'package:iDietFit/user_data/model/entities/traits.dart';

class Suggestion {
  final String details;
  final bool cancelable;
  final bool editable;
  final String userDataEntityType;
  final UserDataEntity userDataEntity;

  Suggestion({this.details, this.cancelable, this.editable, this.userDataEntityType, this.userDataEntity});

  static Suggestion fromJson(Map<String, dynamic> json) {
    String entityType = json['user_data_entity_type'];
    Map<String, dynamic> serializedEntity = Map<String, dynamic>.from(json['user_data_entity']);

    UserDataEntity entity = deserializeUserDataEntity(entityType, serializedEntity);

    return Suggestion(
      details: json['details'],
      cancelable: json['cancelable'],
      editable: json['editable'],
      userDataEntityType: entityType,
      userDataEntity: entity,
    );
  }

  static UserDataEntity deserializeUserDataEntity(String entityType, Map<String, dynamic> serializedEntity) {
    UserDataEntity entity;
    switch(entityType) {
      case 'GlucoseLevel':
        entity = GlucoseLevel.fromJson(serializedEntity);
        break;
      case 'Feeding':
        entity = Feeding.fromJson(serializedEntity);
        break;
      case 'Activity':
        entity = Activity.fromJson(serializedEntity);
        break;
      case 'InsulinInjection':
        entity = InsulinInjection.fromJson(serializedEntity);
        break;
      case 'TraitMeasure':
        entity = TraitMeasure.fromJson(serializedEntity);
        break;
    }
    return entity;
  }
}


class Message {
  static const String TYPE_INFORMATION = 'information';
  static const String TYPE_WARNING = 'warning';
  static const String TYPE_ERROR = 'error';
  static const String TYPE_SUGGESTIONS = 'suggestions';

  final int id;
  final DateTime createdDate;
  final String type;
  final String title;
  final String text;
  final Map<String, dynamic> payload;
  final bool attendImmediately;
  final bool ephemeral;

  Message({this.id, this.createdDate, this.type, this.title, this.text, this.payload, this.attendImmediately, this.ephemeral});

  static Message fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      createdDate: DateTime.fromMicrosecondsSinceEpoch((json['created_date'] * 1000000).toInt()).toUtc(),
      type: json['type'],
      title: json['title'],
      text: json['text'],
      payload: json['payload'],
      attendImmediately: json['attend_immediately'],
      ephemeral: json['ephemeral'],
    );
  }

  String toString() {
    return this.title + ': ' + this.text + ', ' + this.payload.toString();
  }
}


enum AnswerTypeHint {
  NUMERICAL,
  TEXT
}

class FeedbackRequest {
  final int id;
  final DateTime createdDate;
  final DateTime deliveryDate;
  final String title;
  final String text;
  final List<String> options;  // can be null!
  final AnswerTypeHint answerTypeHint;

  FeedbackRequest({this.id, this.createdDate, this.deliveryDate, this.title, this.text, this.options, this.answerTypeHint});

  static FeedbackRequest fromJson(Map<String, dynamic> json) {
    return FeedbackRequest(
      id: json['id'],
      createdDate: DateTime.fromMicrosecondsSinceEpoch((json['created_date'] * 1000000).toInt()).toUtc(),
      deliveryDate: DateTime.fromMicrosecondsSinceEpoch((json['delivery_date'] * 1000000).toInt()).toUtc(),
      title: json['title'],
      text: json['text'],
      options: json['options'] == null ? null : List<String>.from(json['options']),
      answerTypeHint: json['answer_type_hint'] == 'txt' ? AnswerTypeHint.TEXT : AnswerTypeHint.NUMERICAL,
    );
  }

  String toString() {
    return this.title + ': ' + this.text + ', ' + this.options.toString();
  }
}
