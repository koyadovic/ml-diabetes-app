import 'package:Dia/shared/services/api_rest_backend.dart';
import 'package:Dia/shared/tools/uris.dart';


abstract class Source<T> {
  Future<List<T>> performSearch(String terms);
}


typedef LocalSourceMatcher<T> = bool Function(T, String);

class LocalSource<T> extends Source<T> {
  final List<T> data;
  final LocalSourceMatcher<T> matcher;

  LocalSource({
    this.data,
    this.matcher
  });

  @override
  Future<List<T>> performSearch(String terms) async {
    List<T> results = data.where((element) => matcher(element, terms));
    return results;
  }

}

class APIRestSource<T> extends Source<T> {
  final String endpoint;
  final String queryParameterName;
  final String Function(T) toUniqueValue;
  final T Function(Map<String, dynamic>) deserializer;
  ApiRestBackend _backend = ApiRestBackend();

  APIRestSource({
    this.endpoint,
    this.queryParameterName,
    this.toUniqueValue,
    this.deserializer,
  });

  @override
  Future<List<T>> performSearch(String terms) async {
    String url = fixURI('${endpoint}/?${queryParameterName}=$terms');
    dynamic contents = await _backend.get(url);
    List<T> items = [];
    for(var content in contents) {
      items.add(deserializer(content));
    }
    return items;
  }

}