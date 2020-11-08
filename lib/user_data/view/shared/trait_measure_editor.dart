import 'package:Dia/shared/view/utils/editable_status.dart';
import 'package:Dia/shared/view/utils/enabled_status.dart';
import 'package:Dia/shared/view/utils/font_sizes.dart';
import 'package:Dia/shared/view/widgets/dates_time.dart';
import 'package:Dia/shared/view/widgets/unit_text_field.dart';
import 'package:Dia/user_data/controller/services.dart';
import 'package:Dia/user_data/model/entities/traits.dart';
import 'package:flutter/material.dart';


class TraitMeasureEditorWidget extends StatefulWidget {
  final TraitMeasure traitMeasureForEdition;
  final Function() onFinish;
  final List<TraitType> traitTypes;

  TraitMeasureEditorWidget({this.onFinish, this.traitMeasureForEdition, this.traitTypes});

  @override
  State<StatefulWidget> createState() {
    return TraitMeasureEditorWidgetState();
  }
}


class TraitMeasureEditorWidgetState extends State<TraitMeasureEditorWidget> {
  UserDataServices _userDataServices = UserDataServices();
  List<TraitType> _traitTypes = [];
  TextEditingController _externalController;

  TraitMeasure get traitMeasure {
    return widget.traitMeasureForEdition;
  }

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
    _externalController = TextEditingController(text: traitMeasure.value.toString());
    traitMeasure.addValidationListener(() {
      setState(() {
      });
    });
    super.initState();
  }

  _selectTraitType(TraitType type) {
    traitMeasure.traitType = type;
    traitMeasure.value = type.getDefaultValue();
    if(type.slug == 'birth-seconds-epoch') {
      _externalController = null;
    } else {
      _externalController = TextEditingController(text: traitMeasure.value.toString());
    }
    setState(() {
      if(!traitMeasure.isValid) traitMeasure.validate();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool enabled = EnabledStatus.of(context);
    bool editable = EditableStatus.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 16.0, 10.0),
            child: Column(
              children: [
                DropdownButton<TraitType>(
                  isExpanded: true,
                  isDense: true,
                  value: traitMeasure.traitType,
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
          if(traitMeasure.traitType != null && traitMeasure.traitType.slug == 'gender')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    isDense: true,
                    value: traitMeasure.value,
                    onChanged: (String newValue) {
                      setState(() {
                        traitMeasure.value = newValue;
                        if(!traitMeasure.isValid) traitMeasure.validate();
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
          if(traitMeasure.traitType != null && traitMeasure.traitType.slug == 'birth-seconds-epoch')
            DiaDateField(
              initialValue: DateTime.fromMillisecondsSinceEpoch(
                  traitMeasure.value != null ? traitMeasure.value * 1000 : DateTime.now().millisecondsSinceEpoch
              ),
              onChanged: (birthDate) {
                if(birthDate != null) {
                  setState(() {
                    traitMeasure.value = (birthDate.toUtc().millisecondsSinceEpoch / 1000.0).round();
                    if(!traitMeasure.isValid) traitMeasure.validate();

                  });
                }
              },
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if(traitMeasure.traitType != null && traitMeasure.traitType.slug != 'gender' && traitMeasure.traitType.slug != 'birth-seconds-epoch')
              UnitTextField(
                valueSize: bigSize(context),
                unitSize: verySmallSize(context),
                externalController: _externalController,
                unit: traitMeasure.traitType == null ? '' : traitMeasure.traitType.unit,
                processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > 600 ? 600.0 : value,
                ],
                onChange: (value) {
                  setState(() {
                    traitMeasure.value = value;
                    if(!traitMeasure.isValid) traitMeasure.validate();
                  });
                }
              ),

              if(editable && traitMeasure.traitType.slug != 'birth-seconds-epoch' && traitMeasure.traitType.slug != 'gender')
              ...[
                Spacer(),
                if(traitMeasure.value != traitMeasure.traitType.getDefaultValue())
                IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        traitMeasure.value = traitMeasure.traitType.getDefaultValue();
                        _externalController = TextEditingController(text: traitMeasure.value.toString());
                        _externalController.selection = TextSelection.fromPosition(TextPosition(offset: _externalController.text.length));
                        if(!traitMeasure.isValid) traitMeasure.validate();
                      });
                    }
                ),
              ]
            ],
          ),
          if(!traitMeasure.isValid)
          Column(
            children: [
              Text(traitMeasure.getFullValidationText(includePropertyNames: false), style: TextStyle(color: enabled ? Colors.red : Colors.grey)),
            ],
          )
        ],
      ),
    );
  }
}