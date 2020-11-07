import 'dart:ffi';

import 'package:Dia/shared/services/api_rest_backend.dart';
import 'package:Dia/shared/tools/uris.dart';
import 'package:flutter/material.dart';
import 'dart:async';


typedef Null OnSelected<S> (S s);


class SearchAndSelect<T> extends StatefulWidget {
  final T currentValue;
  final Source<T> source;
  final OnSelected<T> onSelected;

  SearchAndSelect({
    this.currentValue,
    @required this.source,
    @required this.onSelected,
  });

  @override
  State<StatefulWidget> createState() {
    return _SearchAndSelectState<T>();
  }
}

class _SearchAndSelectState<T> extends State<SearchAndSelect<T>> {
  TextEditingController _controller = TextEditingController();
  List<T> _results = [];
  Timer _delayedSearch;

  bool _editing = false;

  void _searchChanged(String term) {
    if(_delayedSearch != null)
      _delayedSearch.cancel();
    _delayedSearch = Timer(Duration(milliseconds: 500), () => performSearch(term));
  }

  void performSearch(String terms) async {
    List<T> items = await widget.source.performSearch(terms);
    setState(() {
      _results = items;
    });
    _delayedSearch = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        if(!_editing)
        GestureDetector(
          onTap: () {
            setState(() {
              _controller.text = widget.currentValue ?? '';
              _editing = true;
            });
          },
          child: Text(
            widget.currentValue.toString()
          )
        ),

        if(_editing)
        TextField(
          controller: _controller,
          onChanged: _searchChanged,
        ),

        if(_controller.text != '' && _editing)
        ListView(
          shrinkWrap: true,
          children: _results.map(
            (entity) => GestureDetector(
              onTap: () {
                widget.onSelected(entity);
                setState(() {
                  _editing = false;
                  _results = [];
                });
              },
              child: Text(
                entity.toString()
              ),
            )
          ).toList(),
        )
      ],
    );
  }
}


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
    List<T> results = data.where((element) => matcher(element, terms)).toList();
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