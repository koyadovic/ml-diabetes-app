import 'package:Dia/shared/view/error_handlers.dart';
import 'package:Dia/shared/view/utils/messages.dart';
import 'package:Dia/user_data/controller/services.dart';
import 'package:Dia/user_data/model/entities/activities.dart';
import 'package:Dia/user_data/model/entities/base.dart';
import 'package:Dia/user_data/model/entities/feeding.dart';
import 'package:Dia/user_data/model/entities/flags.dart';
import 'package:Dia/user_data/model/entities/glucose.dart';
import 'package:Dia/user_data/model/entities/insulin.dart';
import 'package:Dia/user_data/model/entities/traits.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Dia/shared/view/view_model.dart';


class TimelineViewModel extends DiaViewModel {
  List<ViewModelDay> _days = [];
  List<ViewModelEntry> _entries = [];
  
  DateTime _oldestRetrieved;
  bool _noMoreData = false;

  final UserDataServices userDataServices = UserDataServices();

  TimelineViewModel(State state) : super(state);

  List<ViewModelEntry> get entries {
    if(_oldestRetrieved == null) moreData();
    return _entries;
  }

  List<ViewModelDay> get days {
    if(_oldestRetrieved == null) moreData();
    return _days;
  }

  Future<void> refreshAll() async {
    _entries = [];
    _oldestRetrieved = null;
    _noMoreData = false;
    await moreData();
  }
  
  void _rebuildDays() {
    int lastDay;
    List<ViewModelDay> days = [];

    ViewModelDay currentDay = ViewModelDay();
    for(ViewModelEntry entry in entries) {
      if(lastDay != null && entry.eventDate.day != lastDay) {
        days.add(currentDay);
        currentDay = ViewModelDay();
      }
      if(currentDay.date == null)
        currentDay.date = entry.eventDate;
      currentDay.entries.add(entry);
      lastDay = entry.eventDate.day;
    }
    if (currentDay.entries.length > 0) {
      days.add(currentDay);
    }
    print('N days: ' + days.length.toString());
    _days = days;
  }

  Future<void> moreData() async {
    if(_noMoreData || isLoading()) return;

    try {
      setLoading(true);
      await withBackendErrorHandlers(() async {
        int limit = 10;
        List<UserDataEntity> moreEntries = await userDataServices.getUserData(
            olderThan: this._oldestRetrieved, limit: limit);
        _noMoreData = moreEntries.length < limit;
        if(moreEntries.length > 0) {
          _oldestRetrieved = moreEntries[moreEntries.length - 1].eventDate;
        }
        _entries.addAll(moreEntries.map((entity) => ViewModelEntry.fromEntity(entity)));
        _rebuildDays();
        notifyChanges();
      });
    } on UserDataServicesError catch (e) {
      DiaMessages.getInstance().showInformation(e.toString());
    } finally {
      setLoading(false);
    }
  }

}


class ViewModelDay {
  DateTime date;
  List<ViewModelEntry> entries = [];
}


class ViewModelEntry {
  DateTime eventDate;
  String type;
  dynamic value;
  String unit;
  String text;
  UserDataEntity entity;
  Color color;

  ViewModelEntry({this.eventDate, this.type, this.value, this.unit, this.text, this.entity, this.color});

  factory ViewModelEntry.fromEntity(UserDataEntity entity) {
    switch(entity.entityType) {
      case 'GlucoseLevel':
        GlucoseLevel glucoseLevel = entity as GlucoseLevel;
        return ViewModelEntry(
          eventDate: entity.eventDate,
          type: entity.entityType,
          value: glucoseLevel.level,
          unit: 'mg/dL',
          text: 'Su nivel de glucosa quedó registrado como ${glucoseLevel.level} mg/dL',
          entity: glucoseLevel,
          color: Colors.redAccent,
        );

      case 'Feeding':
        Feeding feeding = entity as Feeding;
        return ViewModelEntry(
          eventDate: entity.eventDate,
          type: entity.entityType,
          value: feeding.kCal.round(),
          unit: 'Kcal',
          text: 'Feeding',
          entity: feeding,
          color: Colors.greenAccent,
        );

      case 'Activity':
        Activity activity = entity as Activity;
        return ViewModelEntry(
            eventDate: entity.eventDate,
            type: entity.entityType,
            value: activity.minutes,
            unit: 'mins',
            text: activity.activityType.name,
            entity: activity,
            color: Colors.blueAccent,
        );

      case 'InsulinInjection':
        InsulinInjection insulinInjection = entity as InsulinInjection;
        return ViewModelEntry(
            eventDate: entity.eventDate,
            type: entity.entityType,
            value: insulinInjection.units,
            unit: 'u',
            text: insulinInjection.insulinType.name, // + ' ' + insulinInjection.insulinType.categories.join(', '),
            entity: insulinInjection,
            color: Colors.yellow,
        );

      case 'TraitMeasure':
        TraitMeasure traitMeasure = entity as TraitMeasure;
        if(traitMeasure.traitType.slug != 'gender' && traitMeasure.traitType.slug != 'birth-seconds-epoch') {
          return ViewModelEntry(
            eventDate: entity.eventDate,
            type: entity.entityType,
            value: double.parse(traitMeasure.value.toString()),
            unit: traitMeasure.traitType.unit,
            text: traitMeasure.traitType.name,
            entity: traitMeasure,
            color: Colors.greenAccent
          );
        }
        else if(traitMeasure.traitType.slug == 'gender') {
          return ViewModelEntry(
              eventDate: entity.eventDate,
              type: entity.entityType,
              value: traitMeasure.value == 'male' ? 'Male' : 'Female',
              unit: '',
              text: traitMeasure.traitType.name,
              entity: traitMeasure,
              color: Colors.greenAccent
          );
        }
        else if(traitMeasure.traitType.slug == 'birth-seconds-epoch') {
          return ViewModelEntry(
              eventDate: entity.eventDate,
              type: entity.entityType,
              value: DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(traitMeasure.value * 1000).toLocal()),
              unit: '',
              text: traitMeasure.traitType.name,
              entity: traitMeasure,
              color: Colors.greenAccent
          );
        }
        break;

      case 'Flag':
        Flag flag = entity as Flag;
        return ViewModelEntry(
            eventDate: entity.eventDate,
            type: entity.entityType,
            value: flag.type,
            unit: '',
            text: flag.type,
            entity: flag,
            color: Colors.red,
        );
    }
    return null;
  }
}
