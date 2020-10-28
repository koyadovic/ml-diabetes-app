import 'package:Dia/shared/model/api_rest_backend.dart';
import 'package:Dia/shared/view/utils/messages.dart';
import 'package:Dia/shared/view/utils/navigation.dart';
import 'package:Dia/shared/view/view_model.dart';
import 'package:Dia/user_data/controller/services.dart';
import 'package:Dia/user_data/model/entities.dart';
import 'package:flutter/material.dart';


class TimelineViewModel extends DiaViewModel {
  List<UserDataViewModelEntity> _entries = [];
  DateTime _oldestRetrieved;
  bool _noMoreData = false;

  final UserDataServices userDataServices = UserDataServices();

  TimelineViewModel(State state, Navigation navigation, Messages messages) : super(state, navigation, messages);

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
      await withGeneralErrorHandlers(() async {
        setLoading(true);
        int limit = 10;
        List<UserDataEntity> moreEntries = await userDataServices.getUserData(
            olderThan: this._oldestRetrieved, limit: limit);
        _noMoreData = moreEntries.length < limit;
        _oldestRetrieved = moreEntries[moreEntries.length - 1].eventDate;
        _entries.addAll(moreEntries.map((entity) => UserDataViewModelEntity.fromEntity(entity)));
        notifyChanges();
      });
    } on UserDataServicesError catch (e) {
      messages.showInformation(e.toString());
    } finally {
      _noMoreData = true;
      setLoading(false);
    }
  }

}


class UserDataViewModelEntity {
  DateTime eventDate;
  String type;
  String text;
  UserDataEntity entity;

  UserDataViewModelEntity(this.eventDate, this.type, this.text, this.entity);

  factory UserDataViewModelEntity.fromEntity(UserDataEntity entity) {
    switch(entity.entityType) {
      case 'GlucoseLevel':
        GlucoseLevel glucoseLevel = entity as GlucoseLevel;
        String text = '${glucoseLevel.level} mg/dL';
        return UserDataViewModelEntity(entity.eventDate, entity.entityType, text, entity);

      case 'Feeding':
        Feeding feeding = entity as Feeding;
        String text = '${feeding.kCal.round()} Kcal';
        return UserDataViewModelEntity(entity.eventDate, entity.entityType, text, entity);

      case 'Activity':
        Activity activity = entity as Activity;
        String text = '${activity.activityType.name} ${activity.minutes}m';
        return UserDataViewModelEntity(entity.eventDate, entity.entityType, text, entity);

      case 'InsulinInjection':
        InsulinInjection insulinInjection = entity as InsulinInjection;
        String text = '${insulinInjection.insulinType.name} ${insulinInjection.units}u';
        return UserDataViewModelEntity(entity.eventDate, entity.entityType, text, entity);

      case 'TraitMeasure':
        TraitMeasure traitMeasure = entity as TraitMeasure;
        String text = '${traitMeasure.traitType.name} ${traitMeasure.value.round()}';
        return UserDataViewModelEntity(entity.eventDate, entity.entityType, text, entity);

      case 'Flag':
        Flag flag = entity as Flag;
        String text = '${flag.type}';
        return UserDataViewModelEntity(entity.eventDate, entity.entityType, text, entity);
    }
    return null;
  }

}
