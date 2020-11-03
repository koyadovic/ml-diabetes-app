import 'package:Dia/shared/view/utils/theme.dart';
import 'package:Dia/shared/view/widgets/unit_text_field.dart';
import 'package:Dia/user_data/controller/services.dart';
import 'package:Dia/user_data/model/entities.dart';
import 'package:flutter/material.dart';

class AddTraitMeasureWidget extends StatefulWidget {
  /*
  TODO que opcionalmente le puedan ser injectados desde fuera los tipos!
    En este caso que no consulte al backend por ellos. Ya los tiene!

   Esto Se puede aprovechar para pasarle solo [Altura].
   No consultará tipos porque ya los tiene, es 1.
   Además, en el selector no podrá cambiar Altura.
   */
  final Function(bool, [TraitMeasure traitMeasure]) selfCloseCallback;

  AddTraitMeasureWidget({this.selfCloseCallback});

  @override
  State<StatefulWidget> createState() {
    return AddTraitMeasureWidgetState();
  }
}


class AddTraitMeasureWidgetState extends State<AddTraitMeasureWidget> {
  UserDataServices _userDataServices = UserDataServices();
  List<TraitType> _traitTypes = [];
  TraitMeasure _traitMeasure;

  @override
  void initState() {
    super.initState();
    _traitMeasure = TraitMeasure(eventDate: DateTime.now());
    _userDataServices.getTraitTypes().then((traitTypes) {
      traitTypes = traitTypes.where((type) => type.slug != 'gender' && type.slug != 'birth-seconds-epoch').toList();
      setState(() {
        _traitTypes = traitTypes;
      });
      if(_traitTypes.length > 0)
        _selectTraitType(_traitTypes[0]);
    });
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
                onPressed: () async {
                  await _userDataServices.saveTraitMeasure(_traitMeasure);
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