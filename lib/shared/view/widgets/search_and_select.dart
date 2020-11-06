import 'dart:async';

import 'package:Dia/shared/services/api_rest_backend.dart';
import 'package:Dia/shared/tools/uris.dart';
import 'package:flutter/material.dart';

class SearchAndSelect<T> extends StatefulWidget {
  final T currentEntity;
  final String endpoint;
  final String queryParameterName;
  final String Function(T) toUniqueValue;
  final T Function(Map<String, dynamic>) deserializer;
  final Function(T) onSelected;

  SearchAndSelect({
    this.currentEntity,
    @required this.endpoint,
    @required this.queryParameterName,
    @required this.toUniqueValue,
    @required this.deserializer,
    @required this.onSelected,
  });

  @override
  State<StatefulWidget> createState() {
    return _SearchAndSelectState<T>();
  }
}


class _SearchAndSelectState<T> extends State<SearchAndSelect> {
  List<T> entities;
  TextEditingController _controller = TextEditingController();
  Timer _delayedSearch;
  ApiRestBackend _backend;

  @override
  void initState() {
    _backend = ApiRestBackend();
    super.initState();
  }

  void _searchChanged(String term) {
    if(_delayedSearch != null)
      _delayedSearch.cancel();
    _delayedSearch = Timer(Duration(milliseconds: 500), () => performSearch(term));
  }

  void performSearch(String term) async {
    String url = fixURI('${widget.endpoint}/?${widget.queryParameterName}=$term');
    dynamic contents = await _backend.get(url);
    List<T> items = [];
    for(var content in contents) {
      items.add(widget.deserializer(content));
    }
    setState(() {
      entities = items;
    });
    _delayedSearch = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          onChanged: _searchChanged,
        ),
        ListView(
          shrinkWrap: true,
          children: entities.map(
            (entity) => Text(entity.toString())
          ).toList(),
        )
      ],
    );
  }
}