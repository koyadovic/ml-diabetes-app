import 'package:Dia/shared/model/api_rest_backend.dart';
import 'package:Dia/user_data/model/entities.dart';

class UserDataServicesError implements Exception {
  final String _message;
  const UserDataServicesError(this._message);
  String toString() => "$_message";
}


class UserDataServices {
  ApiRestBackend _backend;

  UserDataServices() {
    _backend = ApiRestBackend();
  }

  Future<List<UserDataEntity>> getUserData({DateTime olderThan, int limit = 10}) async {
    await _backend.initialize();

    String url = '/api/v1/user-data/?limit=$limit';
    if(olderThan != null) {
      url += '&older_than=${olderThan.microsecondsSinceEpoch / 1000000.0}';
    }

    dynamic contents = await _backend.get(url);

    List<UserDataEntity> entities = [];

    for(var content in contents) {
      String entityType = content['entity_type'];
      switch(entityType) {
        case 'GlucoseLevel':
          entities.add(GlucoseLevel.fromJson(content));
          break;
        case 'Feeding':
          entities.add(Feeding.fromJson(content));
          break;
        case 'Activity':
          entities.add(Activity.fromJson(content));
          break;
        case 'InsulinInjection':
          entities.add(InsulinInjection.fromJson(content));
          break;
        case 'TraitMeasure':
          entities.add(TraitMeasure.fromJson(content));
          break;
        case 'Flag':
          entities.add(Flag.fromJson(content));
          break;
      }
    }
    return entities;
  }

  Future<void> saveGlucoseLevel(GlucoseLevel glucoseLevel) async {
    await _backend.initialize();
    String url;
    Map<String, dynamic> data;
    if(glucoseLevel.id == null) {
      url = '/api/v1/glucose-levels/';
      data = glucoseLevel.toJson();
    } else {
      url = '/api/v1/glucose-levels/${glucoseLevel.id}/';
      data = glucoseLevel.changesToJson();
      data['id'] = glucoseLevel.id;
    }
    await _backend.post(url, data);
  }

  Future<void> saveTraitMeasure(TraitMeasure traitMeasure) async {
    await _backend.initialize();
    String url;
    Map<String, dynamic> data;
    if(traitMeasure.id == null) {
      url = '/api/v1/trait-measures/';
      data = traitMeasure.toJson();
    } else {
      url = '/api/v1/trait-measures/${traitMeasure.id}/';
      data = traitMeasure.changesToJson();
      data['id'] = traitMeasure.id;
    }
    await _backend.post(url, data);
  }

  Future<void> saveActivity(Activity activity) async {
    await _backend.initialize();
    String url;
    Map<String, dynamic> data;
    if(activity.id == null) {
      url = '/api/v1/activities/';
      data = activity.toJson();
    } else {
      url = '/api/v1/activities/${activity.id}/';
      data = activity.changesToJson();
      data['id'] = activity.id;
    }
    await _backend.post(url, data);
  }

  Future<void> saveInsulinInjection(InsulinInjection insulinInjection) async {
    await _backend.initialize();
    String url;
    Map<String, dynamic> data;
    if(insulinInjection.id == null) {
      url = '/api/v1/insulin-injections/';
      data = insulinInjection.toJson();
    } else {
      url = '/api/v1/insulin-injections/${insulinInjection.id}/';
      data = insulinInjection.changesToJson();
      data['id'] = insulinInjection.id;
    }
    await _backend.post(url, data);
  }

  // TYPES!
  Future<List<ActivityType>> getActivityTypes() async {
    await _backend.initialize();
    String url = '/api/v1/activity-types/';
    dynamic contents = await _backend.get(url);
    return List<ActivityType>.from(contents.map((content) => ActivityType.fromJson(content)));
  }

  Future<List<InsulinType>> getInsulinTypes() async {
    await _backend.initialize();
    String url = '/api/v1/insulin-types/';
    dynamic contents = await _backend.get(url);
    return List<InsulinType>.from(contents.map((content) => InsulinType.fromJson(content)));
  }

  Future<List<TraitType>> getTraitTypes() async {
    await _backend.initialize();
    String url = '/api/v1/trait-types/';
    dynamic contents = await _backend.get(url);
    return List<TraitType>.from(contents.map((content) => TraitType.fromJson(content)));
  }

}
