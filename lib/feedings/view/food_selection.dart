import 'package:Dia/feedings/model/foods.dart';
import 'package:Dia/shared/view/utils/font_sizes.dart';
import 'package:Dia/shared/view/widgets/unit_text_field.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';


class FoodSelectionWidget extends StatefulWidget {
  final Food food;
  final Function(FoodSelection) onSaveFoodSelection;
  final Function() onClose;

  FoodSelectionWidget({this.food, this.onSaveFoodSelection, this.onClose});

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Quantity'.tr(), style: TextStyle(fontSize: smallSize(context))),

              if(_foodSelection.hasGramsPerUnit)
              UnitTextField(
                isDouble: false,
                valueSize: smallSize(context),
                unitSize: verySmallSize(context),
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
                valueSize: smallSize(context),
                unitSize: verySmallSize(context),
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

            ],
          ),
        ],
      ),
    );
  }
}
