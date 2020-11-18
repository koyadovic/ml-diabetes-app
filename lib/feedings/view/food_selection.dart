import 'package:iDietFit/feedings/model/foods.dart';
import 'package:iDietFit/shared/tools/numbers.dart';
import 'package:iDietFit/shared/view/theme.dart';
import 'package:iDietFit/shared/view/utils/font_sizes.dart';
import 'package:iDietFit/shared/view/widgets/unit_text_field.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';


class FoodSelectionWidget extends StatefulWidget {
  final Food food;
  final double previousGrams;
  final Function(FoodSelection) onSaveFoodSelection;
  final Function() onClose;
  final Function() onRemove;

  FoodSelectionWidget({this.food, this.onSaveFoodSelection, this.onClose, this.previousGrams : 0.0, this.onRemove});

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
          Container(
            child: Text(
              'Quantity'.tr() + ' ' + 'of'.tr() + ' ' + _foodSelection.food.name,
              style: TextStyle(
                fontSize: smallSize(context),
              ),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if(_foodSelection.hasGramsPerUnit)
              UnitTextField(
                isDouble: false,
                initialValue: getPreviousUnits().round(),
                valueSize: bigSize(context),
                unitSize: smallSize(context),
                unit: _foodSelection.units == 1.0 ? 'unit'.tr() : 'units'.tr(),
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
                unit: _foodSelection.grams == 1.0 ? 'gram'.tr() : 'grams'.tr(),
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

          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
            child: Container(height: 1, color: Colors.grey[300]),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Digestible carbs'.tr()),
              Text(getDigestibleCarbGrams())
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Not digestible carbs (fiber)'.tr()),
              Text(getNotDigestibleCarbGrams()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Proteins'.tr()),
              Text(getProteinGrams()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Fats'.tr()),
              Text(getFatGrams()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Energy'.tr()),
              Text(getKcal()),
            ],
          ),
          SizedBox(height: 10),
          Container(
            //mainAxisAlignment: MainAxisAlignment.center,
            child: Text(
              'Nutrition facts for serving of'.tr() + ' ' + getServingOf(),
              style: TextStyle(color: Colors.grey),
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
            ),
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
                onPressed: _foodSelection.grams == 0.0 ? null : () {
                  widget.onSaveFoodSelection(_foodSelection);
                },
              ),
              if(widget.onRemove != null)
              FlatButton(
                child: Text('Remove'.tr()),
                onPressed: () {
                  widget.onRemove();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String getServingOf() {
    if(_foodSelection.grams == 0) return '100g';
    if(_foodSelection.hasGramsPerUnit)
      return _foodSelection.units.toString() + ' ' + (_foodSelection.units == 1.0 ? 'unit'.tr() : 'units'.tr());
    return round(_foodSelection.grams, 1).toString() + ' ' + (_foodSelection.grams == 1.0 ? 'gram'.tr() : 'grams'.tr());
  }

  double _getGramsForNutritionFacts() {
    if(_foodSelection.grams == 0) return 100.0;
    return _foodSelection.grams;
  }

  String getDigestibleCarbGrams() {
    double value = (_foodSelection.food.carbFactor - _foodSelection.food.carbFiberFactor) * _getGramsForNutritionFacts();
    return round(value, 1).toString() + 'g';
  }

  String getNotDigestibleCarbGrams() {
    double value = _foodSelection.food.carbFiberFactor * _getGramsForNutritionFacts();
    return round(value, 1).toString() + 'g';
  }

  String getProteinGrams() {
    double value = _foodSelection.food.proteinFactor * _getGramsForNutritionFacts();
    return round(value, 1).toString() + 'g';

  }
  String getFatGrams() {
    double value = _foodSelection.food.fatFactor * _getGramsForNutritionFacts();
    return round(value, 1).toString() + 'g';
  }

  String getKcal() {
    double value = _foodSelection.food.carbFiberFactor * _getGramsForNutritionFacts();
    double currentGrams = _foodSelection.grams;
    _foodSelection.setGrams(_getGramsForNutritionFacts());
    double kcal = _foodSelection.kcal;
    _foodSelection.setGrams(currentGrams);
    return round(kcal, 1).toString() + 'kcal';
  }


}
