import 'package:Dia/shared/view/utils/editable_status.dart';
import 'package:Dia/shared/view/utils/enabled_status.dart';
import 'package:Dia/shared/view/utils/theme.dart';
import 'package:Dia/shared/view/widgets/dates_time.dart';
import 'package:Dia/shared/view/widgets/unit_text_field.dart';
import 'package:Dia/user_data/controller/services.dart';
import 'package:Dia/user_data/model/entities.dart';
import 'package:flutter/material.dart';


class TraitMeasureEditorWidget extends StatefulWidget {
  final TraitMeasure traitMeasureForEdition;
  final Function() selfCloseCallback;
  final List<TraitType> traitTypes;

  TraitMeasureEditorWidget({this.selfCloseCallback, this.traitMeasureForEdition, this.traitTypes});

  @override
  State<StatefulWidget> createState() {
    return TraitMeasureEditorWidgetState();
  }
}


class TraitMeasureEditorWidgetState extends State<TraitMeasureEditorWidget> {
  UserDataServices _userDataServices = UserDataServices();
  List<TraitType> _traitTypes = [];
  TraitMeasure _traitMeasure;
  TextEditingController _externalController;

  @override
  void initState() {
    if(widget.traitTypes == null) {
      _userDataServices.getTraitTypes().then((traitTypes) {
        setState(() {
          _traitTypes = traitTypes;
        });
        if(_traitTypes.length > 0)
          _selectTraitType(_traitTypes[0]);
        });
    } else {
      setState(() {
        _traitTypes = widget.traitTypes;
      });
    }
    _externalController = TextEditingController(text: _traitMeasure.value.toString());
    super.initState();
  }

  _selectTraitType(TraitType type) {
    setState(() {
      _traitMeasure.value = null;
      _traitMeasure.traitType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool enabled = EnabledStatus.of(context);
    bool editable = EditableStatus.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
            child: Column(
              children: [
                DropdownButton<TraitType>(
                  isExpanded: true,
                  value: _traitMeasure.traitType,
                  onChanged: (TraitType newValue) {
                    if(editable)
                      _selectTraitType(newValue);
                  },
                  items: _traitTypes.map<DropdownMenuItem<TraitType>>((TraitType type) {
                    return DropdownMenuItem<TraitType>(
                      value: type,
                      child: Text(type.name),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          if(_traitMeasure.traitType != null && _traitMeasure.traitType.slug == 'gender')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _traitMeasure.value,
                    onChanged: (String newValue) {
                      setState(() {
                        _traitMeasure.value = newValue;
                      });
                    },
                    items: [
                      DropdownMenuItem<String>(
                        value: 'male',
                        child: Text('Male'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'female',
                        child: Text('Female'),
                      )
                    ],
                  ),
                ),
              ],
            ),
          if(_traitMeasure.traitType != null && _traitMeasure.traitType.slug == 'birth-seconds-epoch')
            DiaDateField(
              externalController: _externalController,
              initialValue: DateTime.fromMillisecondsSinceEpoch(
                  _traitMeasure.value != null ? _traitMeasure.value * 1000 : DateTime.now().millisecondsSinceEpoch
              ),
              onChanged: (birthDate) {
                if(birthDate != null) {
                  setState(() {
                    _traitMeasure.value = (birthDate.toUtc().millisecondsSinceEpoch / 1000.0).round();
                  });
                }
              },
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if(_traitMeasure.traitType != null && _traitMeasure.traitType.slug != 'gender' && _traitMeasure.traitType.slug != 'birth-seconds-epoch')
              UnitTextField(
                externalController: _externalController,
                unit: _traitMeasure.traitType == null ? '' : _traitMeasure.traitType.unit,
                processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > 600 ? 600.0 : value,
                ],
                onChange: (value) {
                  setState(() {
                    _traitMeasure.value = value;
                  });
                }
              ),
              if(editable)
              ...[
                Spacer(),
                IconButton(
                    icon: Icon(Icons.close, color: enabled ? DiaTheme.secondaryColor : Colors.grey),
                    onPressed: () {
                      _traitMeasure.reset();
                      widget.selfCloseCallback();
                    }
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}