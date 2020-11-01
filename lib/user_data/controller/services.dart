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

  Future<void> saveGlucoseLevel(int level) async {
    await _backend.initialize();
    String url = '/api/v1/glucose-levels/';
    await _backend.post(url, {'level': level});
  }

  Future<void> saveTraitMeasure(TraitType type, dynamic value) async {
    await _backend.initialize();
    String url = '/api/v1/trait-measures/';
    await _backend.post(url, {'trait_type': type.slug, 'value': value});
  }

  Future<void> saveActivity(ActivityType type, int minutes) async {
    await _backend.initialize();
    String url = '/api/v1/activities/';
    await _backend.post(url, {'activity_type': type.slug, 'minutes': minutes});
  }

  Future<void> saveInsulinInjection(InsulinType type, int units) async {
    await _backend.initialize();
    String url = '/api/v1/insulin-injections/';
    await _backend.post(url, {'insulin_type': type.slug, 'units': units});
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
