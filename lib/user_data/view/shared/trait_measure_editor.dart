import 'package:Dia/shared/view/utils/theme.dart';
import 'package:Dia/shared/view/widgets/unit_text_field.dart';
import 'package:Dia/user_data/controller/services.dart';
import 'package:Dia/user_data/model/entities.dart';
import 'package:flutter/material.dart';


// TODO añadir fecha de nacimiento y género

class TraitMeasureEditorWidget extends StatefulWidget {
  final TraitMeasure traitMeasureForEdition;
  final Function(bool, [TraitMeasure traitMeasure]) selfCloseCallback;

  TraitMeasureEditorWidget({this.selfCloseCallback, this.traitMeasureForEdition});

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

        traitTypes = traitTypes.where((type) => type.slug != 'gender' && type.slug != 'birth-seconds-epoch').toList();
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
      _traitMeasure.traitType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  DropdownButton<TraitType>(
                    //isExpanded: true,
                    value: _traitMeasure.traitType,
                    onChanged: (TraitType newValue) {
                      _selectTraitType(newValue);
                    },
                    items: _traitTypes.map<DropdownMenuItem<TraitType>>((TraitType type) {
                      return DropdownMenuItem<TraitType>(
                        value: type,
                        child: Text(
                          type.name
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
                icon: Icon(Icons.close, color: DiaTheme.secondaryColor),
                onPressed: () => widget.selfCloseCallback(false),
              ),
              IconButton(
                icon: Icon(Icons.done, color: DiaTheme.primaryColor),
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