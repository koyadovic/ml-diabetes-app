import 'package:Dia/shared/view/messages.dart';
import 'package:Dia/shared/view/navigation.dart';
import 'package:Dia/shared/view/view_model.dart';
import 'package:Dia/user_data/controller/services.dart';
import 'package:Dia/user_data/model/entities.dart';
import 'package:flutter/material.dart';


class UserDataViewModelEntity {
  DateTime eventDate;
  String type;
  String text;
  UserDataEntity entity;

  UserDataViewModelEntity(this.eventDate, this.type, this.text, this.entity);

  factory UserDataViewModelEntity.fromEntity(UserDataEntity entity) {
    switch(entity.entityType) {
      case 'GlucoseLevel':
        return UserDataViewModelEntity(entity.eventDate, entity.entityType, '${(entity as GlucoseLevel).level}mg/dL', entity);
      case 'Feeding':
        return UserDataViewModelEntity(entity.eventDate, entity.entityType, 'Feeding', entity);
      case 'Activity':
        return UserDataViewModelEntity(entity.eventDate, entity.entityType, 'Activity', entity);
      case 'InsulinInjection':
        return UserDataViewModelEntity(entity.eventDate, entity.entityType, 'Insulin', entity);
      case 'TraitMeasure':
        return UserDataViewModelEntity(entity.eventDate, entity.entityType, 'Trait Measure', entity);
      case 'Flag':
        return UserDataViewModelEntity(entity.eventDate, entity.entityType, '${(entity as Flag).type}', entity);
    }
    return null;
  }

}


class UserDataViewModel extends DiaViewModel {
  List<UserDataViewModelEntity> _entries = [];
  DateTime _oldestRetrieved;
  bool _noMoreData = false;

  final UserDataServices userDataServices = UserDataServices();

  UserDataViewModel(State state, Navigation navigation, Messages messages) : super(state, navigation, messages);

  List<UserDataViewModelEntity> get entries {
    if(_oldestRetrieved == null) moreData();
    return _entries;
  }

  Future<void> moreData() async {
    if(_noMoreData) return;

    try {
      setLoading(true);
      List<UserDataEntity> moreEntries = await userDataServices.getUserData(olderThan: this._oldestRetrieved);
      _noMoreData = moreEntries.length == 0;
      bool moreData = !_noMoreData;

      if(moreData) {
        _oldestRetrieved = moreEntries[-1].eventDate;
        _entries.addAll(moreEntries.map((entity) => UserDataViewModelEntity.fromEntity(entity)));
        notifyChanges();
      }

    } on UserDataServicesError catch (e) {
      messages.showInformation(e.toString());
    } finally {
      setLoading(false);
    }
  }

}
