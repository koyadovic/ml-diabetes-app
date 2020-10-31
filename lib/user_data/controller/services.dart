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

  Future<void> saveGlucoseLevel(double level) async {
    await _backend.initialize();
    String url = '/api/v1/glucose-levels/';
    await _backend.post(url, {'level': level});
  }

}
