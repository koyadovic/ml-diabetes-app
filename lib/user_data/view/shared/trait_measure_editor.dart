import 'package:Dia/shared/view/utils/theme.dart';
import 'package:Dia/shared/view/widgets/dates_time.dart';
import 'package:Dia/shared/view/widgets/unit_text_field.dart';
import 'package:Dia/user_data/controller/services.dart';
import 'package:Dia/user_data/model/entities.dart';
import 'package:flutter/material.dart';


class TraitMeasureEditorWidget extends StatefulWidget {
  final TraitMeasure traitMeasureForEdition;
  final Function(bool, [TraitMeasure traitMeasure]) selfCloseCallback;
  final TextEditingController externalController;
  final Color fixedColor;

  TraitMeasureEditorWidget({this.selfCloseCallback, this.traitMeasureForEdition, this.externalController, this.fixedColor});

  @override
  State<StatefulWidget> createState() {
    return TraitMeasureEditorWidgetState();
  }
}


class TraitMeasureEditorWidgetState extends State<TraitMeasureEditorWidget> {
  UserDataServices _userDataServices = UserDataServices();
  List<TraitType> _traitTypes = [];
  TraitMeasure _traitMeasure;

  @override
  void initState() {
    if(widget.traitMeasureForEdition != null) {
      _traitMeasure = TraitMeasure.fromJson(widget.traitMeasureForEdition.toJson());
      _traitTypes = [_traitMeasure.traitType];
    } else {
      _traitMeasure = TraitMeasure(eventDate: DateTime.now());
      _userDataServices.getTraitTypes().then((traitTypes) {
        // TODO quita este filtro. Tiene que tener todos!
        // TODO al menos para testear que funciona
        // traitTypes = traitTypes.where((type) => type.slug != 'gender' && type.slug != 'birth-seconds-epoch').toList();

        setState(() {
          _traitTypes = traitTypes;
        });
        if(_traitTypes.length > 0)
          _selectTraitType(_traitTypes[0]);
      });
    }
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
                    _selectTraitType(newValue);
                  },
                  items: _traitTypes.map<DropdownMenuItem<TraitType>>((TraitType type) {
                    return DropdownMenuItem<TraitType>(
                      value: type,
                      child: Text(
                        type.name,
                        style: widget.fixedColor == null ? null : TextStyle(color: widget.fixedColor),
                      ),
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
                        child: Text(
                          'Male',
                          style: widget.fixedColor == null ? null : TextStyle(color: widget.fixedColor),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'female',
                        child: Text(
                          'Female',
                          style: widget.fixedColor == null ? null : TextStyle(color: widget.fixedColor),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          if(_traitMeasure.traitType != null && _traitMeasure.traitType.slug == 'birth-seconds-epoch')
            DiaDateField(
              fixedColor: widget.fixedColor,
              externalController: widget.externalController,
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if(_traitMeasure.traitType != null && _traitMeasure.traitType.slug != 'gender' && _traitMeasure.traitType.slug != 'birth-seconds-epoch')
              UnitTextField(
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
              Spacer(),
              IconButton(
                icon: Icon(Icons.close, color: widget.fixedColor == null ? DiaTheme.secondaryColor : widget.fixedColor),
                onPressed: () => widget.selfCloseCallback(false),
              ),
              IconButton(
                icon: Icon(Icons.done, color: widget.fixedColor == null ? (!_traitMeasure.hasChanged ? Colors.grey : DiaTheme.primaryColor) : widget.fixedColor),
                onPressed: !_traitMeasure.hasChanged ? null : () async {
                  widget.selfCloseCallback(true, _traitMeasure);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}