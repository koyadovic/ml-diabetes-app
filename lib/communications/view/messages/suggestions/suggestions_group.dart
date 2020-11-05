import 'package:Dia/communications/model/entities.dart';
import 'package:Dia/communications/view/messages/suggestions/suggestion_glucose_level.dart';
import 'package:Dia/communications/view/messages/suggestions/suggestion_insulin.dart';
import 'package:Dia/communications/view/messages/suggestions/suggestion_trait_measure.dart';
import 'package:Dia/shared/view/utils/editable_status.dart';
import 'package:Dia/shared/view/utils/enabled_status.dart';
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
    for(int i=0; i<_suggestions.length; i++) {
      suggestionWidgets.add(
          SuggestionWidget(
            _suggestions[i],
            isIgnored: _ignoredIndexes.contains(i),
            onToggleIgnore: () {
              if(_ignoredIndexes.contains(i)){
                setState(() {
                  _ignoredIndexes.remove(i);
                });
              } else {
                setState(() {
                  _ignoredIndexes.add(i);
                });
              }
            },
          )
      );
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
                for(int i=0; i<_suggestions.length; i++) {
                  if(_ignoredIndexes.contains(i)) continue;
                  Suggestion suggestion = _suggestions[i];
                  print('Attending suggestion $suggestion');
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
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return EditableStatus(
      isEditable: suggestion.editable,
      child: EnabledStatus(
        isEnabled: !isIgnored,
        child: Column(
            children: [
              getConcreteWidget(),
              if(suggestion.cancelable)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    child: isIgnored ? Text('Attend', style: TextStyle(color: Colors.grey)) : Text('Ignore'),
                    onPressed: onToggleIgnore,
                  ),
                ],
              ),
            ],
        ),
      ),
    );
  }
}

