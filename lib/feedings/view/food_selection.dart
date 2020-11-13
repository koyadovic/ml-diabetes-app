import 'package:Dia/feedings/model/foods.dart';
import 'package:Dia/shared/view/utils/font_sizes.dart';
import 'package:Dia/shared/view/widgets/unit_text_field.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';


class FoodSelectionWidget extends StatefulWidget {
  final Food food;
  final double previousGrams;
  final Function(FoodSelection) onSaveFoodSelection;
  final Function() onClose;

  FoodSelectionWidget({this.food, this.onSaveFoodSelection, this.onClose, this.previousGrams : 0.0});

  @override
  State<StatefulWidget> createState() {
    return FoodSelectionWidgetState();
  }
}


class FoodSelectionWidgetState extends State<FoodSelectionWidget> {

  FoodSelection _foodSelection;

  @override
  void initState() {
    _foodSelection = FoodSelection(food: widget.food);
    super.initState();
  }

  double getPreviousGrams() {
    if(widget.previousGrams == null) return null;
    return widget.previousGrams;
  }

  double getPreviousUnits() {
    if(widget.previousGrams == null) return null;
    return widget.previousGrams / _foodSelection.food.gramsPerUnit;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          // Food name and nutricional facts per 100g if quantity is empty
          // if quantity has value, show nutritional facts for the specified quantity

          // input for quantity
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Quantity'.tr(), style: TextStyle(fontSize: smallSize(context))),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(_foodSelection.hasGramsPerUnit)
              UnitTextField(
                isDouble: false,
                initialValue: getPreviousUnits().round(),
                valueSize: bigSize(context),
                unitSize: smallSize(context),
                unit: 'u',
                processors: [
                      (value) => value < 0.0 ? 0.0 : value,
                      (value) => value > 600 ? 600.0 : value,
                ],
                autoFocus: false,
                onChange: (value) {
                  setState(() {
                    _foodSelection.setUnits(value.round());
                  });
                }
              ),

              if(!_foodSelection.hasGramsPerUnit)
              UnitTextField(
                isDouble: true,
                initialValue: getPreviousGrams(),
                valueSize: bigSize(context),
                unitSize: smallSize(context),
                unit: 'g',
                processors: [
                      (value) => value < 0.0 ? 0.0 : value,
                      (value) => value > 600 ? 600.0 : value,
                ],
                autoFocus: false,
                onChange: (value) {
                  setState(() {
                    _foodSelection.setGrams(value);
                  });
                }
              ),
            ],
          ),


          // action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton(
                child: Text('Close'.tr()),
                onPressed: () {
                  widget.onClose();
                },
              ),
              FlatButton(
                child: Text('Save'.tr()),
                onPressed: () {
                  widget.onSaveFoodSelection(_foodSelection);
                },
              ),
              // TODO que se abra un diálogo en el que se explique que el reportar es para notificar un problema con el alimento.
              FlatButton(
                child: Text('Report'.tr()),
                onPressed: () {
                  widget.onClose();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
