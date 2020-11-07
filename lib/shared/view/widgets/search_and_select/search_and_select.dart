import 'package:Dia/shared/view/widgets/search_and_select/sources.dart';
import 'package:flutter/material.dart';
import 'dart:async';


class SearchAndSelect<T> extends StatefulWidget {
  final T currentEntity;
  final Source<T> source;
  final Function(T) onSelected;

  SearchAndSelect({
    this.currentEntity,
    @required this.source,
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

  void _searchChanged(String term) {
    if(_delayedSearch != null)
      _delayedSearch.cancel();
    _delayedSearch = Timer(Duration(milliseconds: 500), () => performSearch(term));
  }

  void performSearch(String terms) async {
    List<T> items = await widget.source.performSearch(terms);
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
