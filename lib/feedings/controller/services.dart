import 'package:iDietFit/feedings/model/foods.dart';
import 'package:iDietFit/shared/services/api_rest_backend.dart';
import 'package:iDietFit/user_data/model/entities/feeding.dart';

class FeedingsServices {
  ApiRestBackend _backend;

  FeedingsServices() {
    _backend = ApiRestBackend();
  }

  Future<List<Food>> searchFood(String queryString, double lat, double lng) async {
    String url = '/api/v1/foods/?lat=$lat&lng=$lng&q=$queryString';
    dynamic contents = await _backend.get(url);
    List<Food> foods = [];
    for(var content in contents) {
      foods.add(Food.fromJson(content));
    }
    return foods;
  }

  Future<Food> saveFood(Food food, double lat, double lng) async {
    String url;
    Map<String, dynamic> data = food.toJson();
    data['lat'] = lat;
    data['lng'] = lng;
    dynamic contents;
    if(food.id == null) {
      url = '/api/v1/foods/';
      contents = await _backend.post(url, data);
    } else {
      url = '/api/v1/foods/${food.id}/';
      contents = await _backend.patch(url, data);
    }
    return Food.fromJson(contents);
  }

  Future<Feeding> saveFoodSelections(List<FoodSelection> selections) async {
    Map<String, dynamic> serializedSelections = {'selections': []};
    for(var selection in selections) {
      serializedSelections['selections'].add([selection.food.id, selection.grams]);
    }

    String url = '/api/v1/feedings/food-selections/';
    dynamic contents = await _backend.post(url, serializedSelections);
    return Feeding.fromJson(contents);
  }

  Future<List<Food>> getSimilarFood(Food food, double lat, double lng) async {
    String url = '/api/v1/foods/similar/';
    Map<String, dynamic> data = food.toJson();
    data['lat'] = lat;
    data['lng'] = lng;
    dynamic contents = await _backend.post(url, data);
    List<Food> foods = [];
    for(var content in contents) {
      Food similarFood = Food.fromJson(content);
      if(food.id != null && food.id == similarFood.id) continue;
      foods.add(similarFood);
    }
    return foods;
  }

}
