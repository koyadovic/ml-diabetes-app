import 'package:Dia/communications/model/entities.dart';
import 'package:Dia/communications/view/messages/suggestions/suggestion_glucose_level.dart';
import 'package:Dia/communications/view/messages/suggestions/suggestion_insulin.dart';
import 'package:Dia/communications/view/messages/suggestions/suggestion_trait_measure.dart';
import 'package:flutter/material.dart';

class SuggestionsGroupMessageWidget extends StatefulWidget {
  final Message message;
  final Function onFinished;

  SuggestionsGroupMessageWidget(this.message, this.onFinished);

  @override
  State<StatefulWidget> createState() {
    return SuggestionsGroupMessageWidgetState();
  }
}

class SuggestionsGroupMessageWidgetState extends State<SuggestionsGroupMessageWidget> {
  List<Suggestion> _suggestions = [];
  List<int> _ignoredIndexes = [];

  @override
  void initState() {
    _suggestions = List<Suggestion>.from(
        List<Map<String, dynamic>>.from(widget.message.payload['suggestions']).toList().map(
                (Map<String, dynamic> serializedSuggestion) => Suggestion.fromJson(serializedSuggestion)
        )
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> suggestionWidgets = [];
    int i = 0;
    for (Suggestion suggestion in _suggestions) {
      suggestionWidgets.add(
        SuggestionWidget(
          suggestion,
          isIgnored: _ignoredIndexes.contains(i),
          onToggleIgnore: () {
            if(_ignoredIndexes.contains(i)){
              _ignoredIndexes.remove(i);
            } else {
              _ignoredIndexes.add(i);
            }
          },
        )
      );
      i++;
    }
    return ListView(
      shrinkWrap: true,
      children: [
        ...suggestionWidgets,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text('Finish'),
              onPressed: () {
                int j = 0;
                for(Suggestion suggestion in _suggestions) {
                  if(_ignoredIndexes.contains(j)) continue;
                  // TODO save suggestion
                }
              },
            )
          ],
        )
      ],
    );
  }
}


class SuggestionWidget extends StatelessWidget {
  final Suggestion suggestion;
  final bool isIgnored;
  final Function onToggleIgnore;

  SuggestionWidget(this.suggestion, {this.isIgnored, this.onToggleIgnore});

  Widget getConcreteWidget(){
    switch(suggestion.userDataEntityType) {
      case 'InsulinInjection':
        return InsulinSuggestionWidget(suggestion, isIgnored);
      case 'TraitMeasure':
        return TraitMeasureSuggestionWidget(suggestion, isIgnored);
      case 'GlucoseLevel':
        return GlucoseLevelSuggestionWidget(suggestion, isIgnored);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          getConcreteWidget(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton(
                child: isIgnored ? Text('Attend') : Text('Ignore'),
                onPressed: () {
                  onToggleIgnore();
                },
              ),
            ],
          ),
        ],
    );
  }
}
