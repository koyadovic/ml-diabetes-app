import 'package:iDietFit/communications/model/entities.dart';
import 'package:iDietFit/communications/view/messages/suggestions/suggestion_glucose_level.dart';
import 'package:iDietFit/communications/view/messages/suggestions/suggestion_insulin.dart';
import 'package:iDietFit/communications/view/messages/suggestions/suggestion_trait_measure.dart';
import 'package:iDietFit/shared/services/storage.dart';
import 'package:iDietFit/shared/view/utils/editable_status.dart';
import 'package:iDietFit/shared/view/utils/enabled_status.dart';
import 'package:iDietFit/user_data/controller/services.dart';
import 'package:iDietFit/user_data/model/entities/glucose.dart';
import 'package:iDietFit/user_data/model/entities/insulin.dart';
import 'package:iDietFit/user_data/model/entities/traits.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';


class SuggestionsGroupMessageWidget extends StatefulWidget {
  final Message message;
  final Function() onDismiss;
  final Function() onClose;

  SuggestionsGroupMessageWidget(this.message, this.onDismiss, this.onClose);

  @override
  State<StatefulWidget> createState() {
    return SuggestionsGroupMessageWidgetState();
  }
}

class SuggestionsGroupMessageWidgetState extends State<SuggestionsGroupMessageWidget> {
  List<Suggestion> _suggestions = [];
  UserDataServices _userDataServices = UserDataServices();
  Storage _storage = getLocalStorage();

  bool _saving = false;

  List<int> _ignoredIndexes = [];
  List<int> _handledIndexes = [];

  @override
  void initState() {
    _suggestions = List<Suggestion>.from(
        List<Map<String, dynamic>>.from(widget.message.payload['suggestions']).toList().map(
                (Map<String, dynamic> serializedSuggestion) => Suggestion.fromJson(serializedSuggestion)
        )
    );
    super.initState();
    _reloadHandledIndexes();
  }

  Future<void> _saveHandledIndexes() async {
    await _storage.set(_getStorageKey(), json.encode(_handledIndexes));
  }

  Future<void> _reloadHandledIndexes() async {
    await _storage.get(_getStorageKey()).then((value) {
      if (value == null) {
        setState(() {
          _handledIndexes = [];
        });
      } else {
        setState(() {
          _handledIndexes = List<int>.from(json.decode(value));
        });
      }
    });
  }

  Future<void> _removeHandledIndexes() async {
    await _storage.del(_getStorageKey());
  }

  String _getStorageKey() {
    return 'suggestions_handled_indexes_' + widget.message.id.toString();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> suggestionWidgets = [];
    for(int i=0; i<_suggestions.length; i++) {
      if(!_handledIndexes.contains(i))
        suggestionWidgets.add(
            SuggestionWidget(
              _suggestions[i],
              isSaving: _saving,
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

    return Container(
      color: Colors.black12,
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => widget.onClose(),
              )
            ],
          ),
          if(_saving)
            CircularProgressIndicator(),
          if(!_saving)
            ...suggestionWidgets,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(!widget.message.attendImmediately)
              FlatButton(
                child: Row(
                  children: [
                    Icon(Icons.close),
                    Text('Close'.tr()),
                  ],
                ),
                onPressed: () => widget.onClose(),
              ),

              FlatButton(
                child: Row(
                  children: [
                    Icon(Icons.done),
                    Text('Attend suggestion group'.tr()),
                  ],
                ),
                onPressed: () async {
                  setState(() {
                    _saving = true;
                  });
                  try {
                    bool anyInvalid = false;
                    for(int i=0; i<_suggestions.length; i++) {
                      if (_ignoredIndexes.contains(i) ||
                          _handledIndexes.contains(i)) continue;

                      Suggestion suggestion = _suggestions[i];
                      suggestion.userDataEntity.validate();
                      if(!suggestion.userDataEntity.isValid) anyInvalid = true;
                    }

                    if(anyInvalid) {
                      setState(() {
                      });
                      return;
                    }

                    for(int i=0; i<_suggestions.length; i++) {
                      // continue if handled or ignored by user
                      if(_ignoredIndexes.contains(i) || _handledIndexes.contains(i)) continue;

                      Suggestion suggestion = _suggestions[i];
                      switch(suggestion.userDataEntityType) {
                        case 'InsulinInjection':
                          InsulinInjection entity = suggestion.userDataEntity as InsulinInjection;
                          await _userDataServices.saveInsulinInjection(entity);
                          break;
                        case 'GlucoseLevel':
                          GlucoseLevel entity = suggestion.userDataEntity as GlucoseLevel;
                          await _userDataServices.saveGlucoseLevel(entity);
                          break;
                        case 'TraitMeasure':
                          TraitMeasure entity = suggestion.userDataEntity as TraitMeasure;
                          await _userDataServices.saveTraitMeasure(entity);
                          break;
                      }
                      _handledIndexes.add(i);
                      await _saveHandledIndexes();
                      setState(() {
                      });
                      print('Attending suggestion $suggestion');
                    }
                    await _removeHandledIndexes();
                    widget.onDismiss();
                  } catch (err) {
                    print(err);
                  } finally {
                    setState(() {
                      _saving = false;
                    });
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }
}


class SuggestionWidget extends StatelessWidget {
  final Suggestion suggestion;
  final bool isIgnored;
  final bool isSaving;
  final Function onToggleIgnore;

  SuggestionWidget(this.suggestion, {this.isIgnored, this.onToggleIgnore, this.isSaving});

  Widget getConcreteWidget(){
    if(isSaving) return SizedBox.shrink();

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
        child: Card(
          elevation: isIgnored ? 0 : 5,
          child: Column(
              children: [
                getConcreteWidget(),
                SizedBox(height: 10),
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
      ),
    );
  }
}

