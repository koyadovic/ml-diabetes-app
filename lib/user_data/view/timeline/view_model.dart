import 'package:iDietFit/shared/tools/numbers.dart';
import 'package:iDietFit/user_data/controller/services.dart';
import 'package:iDietFit/user_data/model/entities/activities.dart';
import 'package:iDietFit/user_data/model/entities/base.dart';
import 'package:iDietFit/user_data/model/entities/feeding.dart';
import 'package:iDietFit/user_data/model/entities/flags.dart';
import 'package:iDietFit/user_data/model/entities/glucose.dart';
import 'package:iDietFit/user_data/model/entities/insulin.dart';
import 'package:iDietFit/user_data/model/entities/not_ephemeral_messages.dart';
import 'package:iDietFit/user_data/model/entities/traits.dart';
import 'package:iDietFit/shared/view/view_model.dart';
import 'package:iDietFit/shared/view/error_handlers.dart';
import 'package:iDietFit/shared/view/messages.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:iDietFit/shared/tools/dates.dart';
import 'package:timezone/timezone.dart';


class TimelineViewModel extends DiaViewModel {
  List<ViewModelDay> _days = [];
  List<ViewModelEntry> _entries = [];
  
  DateTime _oldestRetrieved;
  bool _noMoreData = false;

  Location _localTimezone;

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
      DateTime entryDate = entry.eventDate.toUtc().asTimezone(_localTimezone);
      int entryDay = entryDate.day;
      if(lastDay != null && entryDay != lastDay) {
        days.add(currentDay);
        currentDay = ViewModelDay();
      }
      if(currentDay.date == null)
        currentDay.date = entryDate;
      currentDay.entries.add(entry);
      lastDay = entryDay;
    }
    if (currentDay.entries.length > 0) {
      days.add(currentDay);
    }
    _days = days;
  }

  Future<void> moreData() async {
    if (_localTimezone == null) {
      _localTimezone = await settingsServices.getTimezone();
    }

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

  GlucoseLevel get glucoseLevel {
    return entity as GlucoseLevel;
  }

  Feeding get feeding {
    return entity as Feeding;
  }

  TraitMeasure get traitMeasure {
    return entity as TraitMeasure;
  }

  InsulinInjection get insulinInjection {
    return entity as InsulinInjection;
  }

  Activity get activity {
    return entity as Activity;
  }

  Flag get flag {
    return entity as Flag;
  }

  NotEphemeralMessage get notEphemeralMessage {
    return entity as NotEphemeralMessage;
  }

  static int getAge(int secondsSinceEpochBirth) {
    DateTime birth = DateTime.fromMicrosecondsSinceEpoch(secondsSinceEpochBirth * 1000000);
    DateTime now = DateTime.now();

    int age = now.year - birth.year;
    if(now.month < birth.month) {
      age --;
    }
    else if(now.month == birth.month) {
      if(now.day < birth.day) {
        age --;
      }
    }
    return age;
  }

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
              'kcal_burned': ((activity.activityType.mets * (activity.minutes / 60.0) * 90).round()).toString()
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

      case 'NotEphemeralMessage':
        NotEphemeralMessage message = entity as NotEphemeralMessage;
        return ViewModelEntry(
          eventDate: entity.eventDate,
          type: entity.entityType,
          text: message.text,
          entity: message,
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
                traitMeasure.value.toString().tr(),
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
                getAge(traitMeasure.value).toString(),
                ' ' + 'years'.tr()
              ]),
              entity: traitMeasure,
          );
        }
        break;

      case 'Flag':
        Flag flag = entity as Flag;
        String text = flag.type;
        switch(flag.type) {
          case Flag.TYPE_HYPOGLYCEMIA:
            text = 'Hypoglycemia registered'.tr();
            break;
          case Flag.TYPE_INSULIN_TIME_CHANGE:
            text = 'Registered a change in insulin administration times'.tr();
            break;
          case Flag.TYPE_INSULIN_TYPES_CHANGE:
            text = 'Registered a change in your insulin types used'.tr();
            break;
        }
        return ViewModelEntry(
            eventDate: entity.eventDate,
            type: entity.entityType,
            text: text,
            entity: flag,
        );
    }
    return null;
  }
}
