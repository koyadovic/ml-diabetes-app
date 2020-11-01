import 'package:Dia/shared/view/utils/messages.dart';
import 'package:Dia/shared/view/view_model.dart';
import 'package:Dia/user_data/controller/services.dart';
import 'package:Dia/user_data/model/entities.dart';
import 'package:flutter/material.dart';


class TimelineViewModel extends DiaViewModel {
  List<UserDataViewModelEntity> _entries = [];
  DateTime _oldestRetrieved;
  bool _noMoreData = false;

  final UserDataServices userDataServices = UserDataServices();

  TimelineViewModel(State state) : super(state);

  List<UserDataViewModelEntity> get entries {
    if(_oldestRetrieved == null) moreData();
    return _entries;
  }

  Future<void> refreshAll() async {
    _entries = [];
    _oldestRetrieved = null;
    _noMoreData = false;
    await moreData();
  }

  Future<void> moreData() async {
    print('moreData');
    if(_noMoreData || isLoading()) return;

    try {
      setLoading(true);
      await withGeneralErrorHandlers(() async {
        int limit = 10;
        List<UserDataEntity> moreEntries = await userDataServices.getUserData(
            olderThan: this._oldestRetrieved, limit: limit);
        _noMoreData = moreEntries.length < limit;
        _oldestRetrieved = moreEntries[moreEntries.length - 1].eventDate;
        _entries.addAll(moreEntries.map((entity) => UserDataViewModelEntity.fromEntity(entity)));
        notifyChanges();
      });
    } on UserDataServicesError catch (e) {
      DiaMessages.getInstance().showInformation(e.toString());
    } finally {
      _noMoreData = true;
      setLoading(false);
    }
  }

}


class UserDataViewModelEntity {
  DateTime eventDate;
  String type;
  dynamic value;
  String unit;
  UserDataEntity entity;

  UserDataViewModelEntity({this.eventDate, this.type, this.value, this.unit, this.entity});

  factory UserDataViewModelEntity.fromEntity(UserDataEntity entity) {
    switch(entity.entityType) {
      case 'GlucoseLevel':
        GlucoseLevel glucoseLevel = entity as GlucoseLevel;
        return UserDataViewModelEntity(
          eventDate: entity.eventDate,
          type: entity.entityType,
          value: glucoseLevel.level,
          unit: 'mg/dL',
          entity: glucoseLevel
        );

      case 'Feeding':
        Feeding feeding = entity as Feeding;
        return UserDataViewModelEntity(
          eventDate: entity.eventDate,
          type: entity.entityType,
          value: feeding.kCal.round(),
          unit: 'Kcal',
          entity: feeding
        );

      case 'Activity':
        Activity activity = entity as Activity;
        return UserDataViewModelEntity(
            eventDate: entity.eventDate,
            type: entity.entityType,
            value: activity.minutes,
            unit: 'm',
            entity: activity
        );

      case 'InsulinInjection':
        InsulinInjection insulinInjection = entity as InsulinInjection;
        return UserDataViewModelEntity(
            eventDate: entity.eventDate,
            type: entity.entityType,
            value: insulinInjection.units,
            unit: 'u',
            entity: insulinInjection
        );

      case 'TraitMeasure':
        TraitMeasure traitMeasure = entity as TraitMeasure;
        return UserDataViewModelEntity(
            eventDate: entity.eventDate,
            type: entity.entityType,
            value: traitMeasure.value,
            unit: traitMeasure.traitType.unit,
            entity: traitMeasure
        );

      case 'Flag':
        Flag flag = entity as Flag;
        return UserDataViewModelEntity(
            eventDate: entity.eventDate,
            type: entity.entityType,
            value: flag.type,
            unit: '',
            entity: flag
        );
    }
    return null;
  }

  factory UserDataViewModelEntity.fromMessage(UserDataEntity entity) {

  }

}
