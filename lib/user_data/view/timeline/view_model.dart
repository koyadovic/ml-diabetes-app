import 'package:Dia/shared/tools/numbers.dart';
import 'package:Dia/user_data/controller/services.dart';
import 'package:Dia/user_data/model/entities/activities.dart';
import 'package:Dia/user_data/model/entities/base.dart';
import 'package:Dia/user_data/model/entities/feeding.dart';
import 'package:Dia/user_data/model/entities/flags.dart';
import 'package:Dia/user_data/model/entities/glucose.dart';
import 'package:Dia/user_data/model/entities/insulin.dart';
import 'package:Dia/user_data/model/entities/traits.dart';
import 'package:Dia/shared/view/view_model.dart';
import 'package:Dia/shared/view/error_handlers.dart';
import 'package:Dia/shared/view/messages.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';


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
    _days = days;
  }

  Future<void> moreData() async {
    if(_noMoreData || isLoading()) return;

    try {
      setLoading(true);
      await withBackendErrorHandlersOnView(() async {
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
      DiaMessages.getInstance().showBriefMessage(e.toString());
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
  String text;
  UserDataEntity entity;

  ViewModelEntry({this.eventDate, this.type, this.text, this.entity});

  factory ViewModelEntry.fromEntity(UserDataEntity entity) {
    switch(entity.entityType) {
      case 'GlucoseLevel':
        GlucoseLevel glucoseLevel = entity as GlucoseLevel;
        return ViewModelEntry(
          eventDate: entity.eventDate,
          type: entity.entityType,
          text: 'Your glucose level was {} mg/dL'.tr(args: [glucoseLevel.level.toString()]),
          entity: glucoseLevel,
        );

      case 'Feeding':
        Feeding feeding = entity as Feeding;
        return ViewModelEntry(
          eventDate: entity.eventDate,
          type: entity.entityType,
          // round(feeding.kCal, 1).toString(), round(feeding.carbGrams - feeding.carbFiberGrams, 1).toString()
          text: 'Feeding view model text'.tr(namedArgs: {
            'kcal': round(feeding.kCal, 1).round().toString(),
            'carbs': round(feeding.carbGrams - feeding.carbFiberGrams, 1).round().toString(),
            'proteins': round(feeding.proteinGrams, 1).round().toString(),
            'fats': round(feeding.fatGrams, 1).round().toString(),
          }),
          entity: feeding,
        );

      case 'Activity':
        Activity activity = entity as Activity;
        return ViewModelEntry(
            eventDate: entity.eventDate,
            type: entity.entityType,
            text: '{} for {} minutes'.tr(args: [activity.activityType.name, activity.minutes.toString()], namedArgs: {
              'kcal_burned': (activity.activityType.mets * (activity.minutes / 60.0) * 90).toString()
            }),
            entity: activity,
        );

      case 'InsulinInjection':
        InsulinInjection insulinInjection = entity as InsulinInjection;
        return ViewModelEntry(
            eventDate: entity.eventDate,
            type: entity.entityType,
            text: 'You injected {} units of insulin {}'.tr(args: [insulinInjection.units.toString(), insulinInjection.insulinType.name]),
            entity: insulinInjection,
        );

      case 'TraitMeasure':
        TraitMeasure traitMeasure = entity as TraitMeasure;
        if(traitMeasure.traitType.slug != 'gender' && traitMeasure.traitType.slug != 'birth-seconds-epoch') {
          return ViewModelEntry(
            eventDate: entity.eventDate,
            type: entity.entityType,
            text: 'You changed your {}: {}{}'.tr(args: [
              traitMeasure.traitType.name.toLowerCase(),
              traitMeasure.value.toString(),
              traitMeasure.traitType.unit
            ]),
            entity: traitMeasure,
          );
        }
        else if(traitMeasure.traitType.slug == 'gender') {
          return ViewModelEntry(
              eventDate: entity.eventDate,
              type: entity.entityType,
              text: 'You changed your {}: {}{}'.tr(args: [
                traitMeasure.traitType.name.toLowerCase(),
                traitMeasure.value.toString(),
                traitMeasure.traitType.unit
              ]),
              entity: traitMeasure,
          );
        }
        else if(traitMeasure.traitType.slug == 'birth-seconds-epoch') {
          return ViewModelEntry(
              eventDate: entity.eventDate,
              type: entity.entityType,
              text: 'You changed your {}: {}{}'.tr(args: [
                traitMeasure.traitType.name.toLowerCase(),
                traitMeasure.value.toString(),
                traitMeasure.traitType.unit
              ]),
              entity: traitMeasure,
          );
        }
        break;

      case 'Flag':
        Flag flag = entity as Flag;
        return ViewModelEntry(
            eventDate: entity.eventDate,
            type: entity.entityType,
            text: flag.type,
            entity: flag,
        );
    }
    return null;
  }
}
