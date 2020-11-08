import 'dart:ffi';

import 'package:Dia/shared/services/api_rest_backend.dart';
import 'package:Dia/shared/tools/uris.dart';
import 'package:flutter/material.dart';
import 'dart:async';


typedef Null OnSelected<S> (S s);
typedef Widget RenderItem<S> (S s);


class SearchAndSelect<T> extends StatefulWidget {
  /*
  Here two examples for simple String types and local source and other with complex types and remote restful api

  // local example
  SearchAndSelect<String>(
    currentValue: searchAndSelectSelection,
    delayMilliseconds: 0,
    source: LocalSource<String>(
      data: ['Yes', 'No', 'Maybe'],
      matcher: (String item, String searchTerm) => item.toLowerCase().contains(searchTerm.toLowerCase()),
    ),
    onSelected: (String value) {
      print('Selected $value');
      setState(() {
        searchAndSelectSelection = value;
      });
    },
    renderItem: (String value) => Text(value ?? 'Pulse para seleccionar', style: TextStyle(color: Colors.indigo)),
  ),

  // restful api example
  SearchAndSelect<ActivityType>(
    hintText: 'Search for activity',
    currentValue: null,
    source: APIRestSource<ActivityType>(
      endpoint: '/api/v1/activity-types/',
      queryParameterName: 'search',
      deserializer: ActivityType.fromJson,
    ),
    onSelected: (ActivityType value) {
      print('Selected $value');
    },
    renderItem: (ActivityType value) => ListTile(
      leading: Icon(Icons.directions_run),
      title: Text(value.name),
      subtitle: Text(value.mets.toString() + ' METs'),
    ),
  ),
   */
  final T currentValue;
  final Source<T> source;
  final OnSelected<T> onSelected;
  final RenderItem<T> renderItem;
  final Function(T) itemToString;
  final String hintText;
  final int delayMilliseconds;

  SearchAndSelect({
    this.currentValue,
    @required this.source,
    @required this.onSelected,
    @required this.renderItem,
    this.itemToString,
    this.hintText,
    this.delayMilliseconds
  });

  @override
  State<StatefulWidget> createState() {
    return _SearchAndSelectState<T>();
  }
}

class _SearchAndSelectState<T> extends State<SearchAndSelect<T>> {
  TextEditingController _controller;
  List<T> _results = [];
  Timer _delayedSearch;

  final GlobalKey key = GlobalKey();
  OverlayEntry _overlayEntry;

  @override
  void initState() {
    _controller = TextEditingController(
      text: widget.currentValue != null ?
        widget.itemToString != null ?
          widget.itemToString(widget.currentValue)
            :
          widget.currentValue.toString()
        :
        '');
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _searchChanged(String term) {
    if(_delayedSearch != null)
      _delayedSearch.cancel();
    _delayedSearch = Timer(Duration(milliseconds: widget.delayMilliseconds ?? 300), () => performSearch(term));
    setState(() {
    });
  }

  void performSearch(String terms) async {
    if(terms == '') {
      setState(() {
        _results = [];
      });
      closeResults();
    } else {
      List<T> items = await widget.source.performSearch(terms);
      setState(() {
        _results = items;
      });
      if(items.length > 0) openResults();
    }
    _delayedSearch = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      children: [
        TextField(
          controller: _controller,
          onChanged: _searchChanged,
          decoration: InputDecoration(
            hintText: widget.hintText,
            suffixIcon: _controller.text.isNotEmpty ? IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                closeResults();
                setState(() {
                  _controller.text = '';
                  _results = [];
                });
                widget.onSelected(null);
              },
            ) : null
          ),
        ),
      ],
    );
  }

  void openResults() {
    closeResults();
    this._overlayEntry = this._createOverlayEntry(
      ListView(
        shrinkWrap: true,
        children: _results.map(
          (item) => GestureDetector(
            onTap: () {
              widget.onSelected(item);
              setState(() {
                _controller.text = widget.itemToString != null ? widget.itemToString(item) : item.toString();
                _results = [];
              });
              closeResults();
            },
            child: widget.renderItem(item),
          )
        ).toList(),
      ),
    );
    Overlay.of(context).insert(this._overlayEntry);
  }

  void closeResults() {
    try {
      this._overlayEntry?.remove();
    } catch (e) {}
    this._overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry(Widget w) {
    RenderBox renderBox = key.currentContext.findRenderObject();
    var size = renderBox.size;
    Offset position = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy + size.height,
        width: size.width,
        child: Material(
          elevation: 2,
          child: w
        ),
      )
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
  final T Function(Map<String, dynamic>) deserializer;

  final ApiRestBackend _backend = ApiRestBackend();

  APIRestSource({
    this.endpoint,
    this.queryParameterName,
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