import 'package:Dia/feedings/model/foods.dart';
import 'package:Dia/shared/view/utils/font_sizes.dart';
import 'package:Dia/shared/view/utils/unfocus.dart';
import 'package:Dia/shared/view/widgets/unit_text_field.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';


class FoodEditorWidget extends StatefulWidget {
  final Food food;

  final Function(Food) onSaveFood;
  final Function() onClose;
  final Function() onReportError;

  FoodEditorWidget({
    this.food,
    @required this.onSaveFood,
    @required this.onClose,
    this.onReportError
  });

  @override
  State<StatefulWidget> createState() {
    return FoodEditorWidgetState();
  }
}


class FoodEditorWidgetState extends State<FoodEditorWidget> {
  // TODO convert here the data of the backend
  // TODO use food.isFiberIncludedInCarbs and food.isFiberSpecifiedSeparately
  // TODO to present to the user appropriately

  Food _editedFood;

  TextEditingController _nameController;
  TextEditingController _quantityController = TextEditingController(text: '100');

  @override
  void initState() {
    if(widget.food != null){
      _editedFood = widget.food.clone();
    }
    else {
      _editedFood = Food.newFood();
      _editedFood.fiberIsSpecifiedSeparately();
    }

    _nameController = TextEditingController(text: _editedFood.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          TextField(
            controller: _nameController,
          ),
          SizedBox(height: 10),
          Text('To choose the next option, take a good look at the nutritional information. Does the carbohydrates section include fiber or does fiber appear separately?'.tr()),
          SizedBox(height: 10),
          DropdownButton<bool>(
            itemHeight: 70,
            isExpanded: true,
            // isDense: false,
            value: _editedFood.isFiberSpecifiedSeparately,
            onChanged: (bool fiberIsSeparate) {
              unFocus(context);
              if(fiberIsSeparate){
                setState(() {
                  _editedFood.fiberIsSpecifiedSeparately();
                });
              } else {
                setState(() {
                  _editedFood.fiberIsIncludedInCarbs();
                });
              }
            },
            items: [
              DropdownMenuItem<bool>(
                value: true,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Fiber is specified separately'.tr()),
                ),
              ),
              DropdownMenuItem<bool>(
                value: false,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Fiber is included in carbs section'.tr()),
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('En la cantidad de', style: TextStyle(fontSize: smallSize(context))),
              UnitTextField(
                valueSize: smallSize(context),
                unitSize: verySmallSize(context),
                externalController: _quantityController,
                unit: 'g',
                processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > 600 ? 600.0 : value,
                ],
                autoFocus: false,
                onChange: (value) {
                  setState(() {
                    _editedFood.setQuantityGrams(value);
                  });
                }
              ),
            ],
          ),
          if(_editedFood.isFiberIncludedInCarbs)
            FoodEditorFiberInCarbsWidget(food: _editedFood),
          if(_editedFood.isFiberSpecifiedSeparately)
            FoodEditorFiberSeparatelyWidget(food: _editedFood),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton(
                child: Text('Close'.tr()),
                onPressed: () {
                  print('Close editor');
                  widget.onClose();
                },
              ),
              FlatButton(
                child: Text('Save'.tr()),
                onPressed: () {
                  if(_editedFood.isFiberSpecifiedSeparately) {
                    _editedFood.carbFactor += _editedFood.carbFiberFactor;
                  }
                  widget.onSaveFood(_editedFood);
                },
              ),
              if(_editedFood.id != null && widget.onReportError != null)
              FlatButton(
                child: Text('Report error'.tr()),
                onPressed: () {
                  print('Report error');
                  widget.onReportError();
                },
              ),

            ],
          ),
        ],
      ),
    );
  }
}


class FoodEditorFiberInCarbsWidget extends StatelessWidget {

  // TODO aquí no hay cambio, cada field a su campo.

  final Food food;

  TextEditingController _carbsTotalController;
  TextEditingController _carbsSugarController;
  TextEditingController _carbsFiberController;
  TextEditingController _proteinsController;
  TextEditingController _fatsController;
  TextEditingController _saltController;
  TextEditingController _alcoholController;

  FoodEditorFiberInCarbsWidget({this.food}) {
    _carbsTotalController = TextEditingController(text: (food.carbFactor * food.getQuantityGrams()).toString());
    _carbsSugarController = TextEditingController(text: (food.carbSugarFactor * food.getQuantityGrams()).toString());
    _carbsFiberController = TextEditingController(text: (food.carbFiberFactor * food.getQuantityGrams()).toString());
    _proteinsController = TextEditingController(text: (food.proteinFactor * food.getQuantityGrams()).toString());
    _fatsController = TextEditingController(text: (food.fatFactor * food.getQuantityGrams()).toString());
    _saltController = TextEditingController(text: (food.saltFactor * food.getQuantityGrams()).toString());
    _alcoholController = TextEditingController(text: (food.alcoholFactor * food.getQuantityGrams()).toString());
  }

  @override
  Widget build(BuildContext context) {
    _carbsTotalController.text = (food.carbFactor * food.getQuantityGrams()).toString();
    _carbsSugarController.text = (food.carbSugarFactor * food.getQuantityGrams()).toString();
    _carbsFiberController.text = (food.carbFiberFactor * food.getQuantityGrams()).toString();
    _proteinsController.text = (food.proteinFactor * food.getQuantityGrams()).toString();
    _fatsController.text = (food.fatFactor * food.getQuantityGrams()).toString();
    _saltController.text = (food.saltFactor * food.getQuantityGrams()).toString();
    _alcoholController.text = (food.alcoholFactor * food.getQuantityGrams()).toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        NutritionSection(
          name: 'CARBS',
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _carbsTotalController,
            unit: 'g',
            processors: [
              (value) => value < 0.0 ? 0.0 : value,
              (value) => value > food.getQuantityGrams() ? food.getQuantityGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.carbFactor = food.getQuantityGrams() != 0.0 ? value / food.getQuantityGrams() : 0.0;
            }
          )
        ),
        NutritionChildSection(
          name: '○  Sugar',
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _carbsSugarController,
            unit: 'g',
            processors: [
              (value) => value < 0.0 ? 0.0 : value,
              (value) => value > food.getQuantityGrams() ? food.getQuantityGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.carbSugarFactor = food.getQuantityGrams() != 0.0 ? value / food.getQuantityGrams() : 0.0;

            }
          )
        ),
        NutritionChildSection(
          name: '○  Fiber',
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _carbsFiberController,
            unit: 'g',
            processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > food.getQuantityGrams() ? food.getQuantityGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.carbFiberFactor = food.getQuantityGrams() != 0.0 ? value / food.getQuantityGrams() : 0.0;

            }
          )
        ),
        NutritionSection(
          name: 'PROTEINS',
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _proteinsController,
            unit: 'g',
            processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > food.getQuantityGrams() ? food.getQuantityGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.proteinFactor = food.getQuantityGrams() != 0.0 ? value / food.getQuantityGrams() : 0.0;

            }
          )
        ),
        NutritionSection(
          name: 'FATS',
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _fatsController,
            unit: 'g',
            processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > food.getQuantityGrams() ? food.getQuantityGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.fatFactor = food.getQuantityGrams() != 0.0 ? value / food.getQuantityGrams() : 0.0;
            }
          )
        ),
        NutritionSection(
          name: 'SALT',
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _saltController,
            unit: 'g',
            processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > food.getQuantityGrams() ? food.getQuantityGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.saltFactor = food.getQuantityGrams() != 0.0 ? value / food.getQuantityGrams() : 0.0;
            }
          )
        ),
        NutritionSection(
          name: 'ALCOHOL',
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _alcoholController,
            unit: 'g',
            processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > food.getQuantityGrams() ? food.getQuantityGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.alcoholFactor = food.getQuantityGrams() != 0.0 ? value / food.getQuantityGrams() : 0.0;
            }
          )
        ),
      ],
    );
  }
}


class FoodEditorFiberSeparatelyWidget extends StatelessWidget {

  // TODO Cuando cambie fiber cambia fiber y carbs totales. Al representar carbs totales restar fiber. Apañao

  final Food food;

  TextEditingController _carbsTotalController;
  TextEditingController _carbsSugarController;
  TextEditingController _carbsFiberController;
  TextEditingController _proteinsController;
  TextEditingController _fatsController;
  TextEditingController _saltController;
  TextEditingController _alcoholController;

  FoodEditorFiberSeparatelyWidget({this.food}){
    _carbsTotalController = TextEditingController(text: ((food.carbFactor - food.carbFiberFactor) * food.getQuantityGrams()).toString());
    _carbsSugarController = TextEditingController(text: (food.carbSugarFactor * food.getQuantityGrams()).toString());
    _carbsFiberController = TextEditingController(text: (food.carbFiberFactor * food.getQuantityGrams()).toString());
    _proteinsController = TextEditingController(text: (food.proteinFactor * food.getQuantityGrams()).toString());
    _fatsController = TextEditingController(text: (food.fatFactor * food.getQuantityGrams()).toString());
    _saltController = TextEditingController(text: (food.saltFactor * food.getQuantityGrams()).toString());
    _alcoholController = TextEditingController(text: (food.alcoholFactor * food.getQuantityGrams()).toString());
  }

  @override
  Widget build(BuildContext context) {
    // TODO restale la fibra
    _carbsTotalController.text = ((food.carbFactor - food.carbFiberFactor) * food.getQuantityGrams()).toString();

    _carbsSugarController.text = (food.carbSugarFactor * food.getQuantityGrams()).toString();
    _carbsFiberController.text = (food.carbFiberFactor * food.getQuantityGrams()).toString();
    _proteinsController.text = (food.proteinFactor * food.getQuantityGrams()).toString();
    _fatsController.text = (food.fatFactor * food.getQuantityGrams()).toString();
    _saltController.text = (food.saltFactor * food.getQuantityGrams()).toString();
    _alcoholController.text = (food.alcoholFactor * food.getQuantityGrams()).toString();

    return Column(
      children: [
        NutritionSection(
          name: 'CARBS',
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _carbsTotalController,
            unit: 'g',
            processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > food.getQuantityGrams() ? food.getQuantityGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.carbFactor = food.getQuantityGrams() != 0.0 ? value / food.getQuantityGrams() : 0.0;
            }
          )
        ),
        NutritionChildSection(
          name: '○  Sugar',
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _carbsSugarController,
            unit: 'g',
            processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > food.getQuantityGrams() ? food.getQuantityGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.carbSugarFactor = food.getQuantityGrams() != 0.0 ? value / food.getQuantityGrams() : 0.0;

            }
          )
        ),
        NutritionSection(
          name: 'FIBER',
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _carbsFiberController,
            unit: 'g',
            processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > food.getQuantityGrams() ? food.getQuantityGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.carbFiberFactor = food.getQuantityGrams() != 0.0 ? value / food.getQuantityGrams() : 0.0;
            }
          )
        ),
        NutritionSection(
          name: 'PROTEINS',
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _proteinsController,
            unit: 'g',
            processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > food.getQuantityGrams() ? food.getQuantityGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.proteinFactor = food.getQuantityGrams() != 0.0 ? value / food.getQuantityGrams() : 0.0;

            }
          )
        ),
        NutritionSection(
          name: 'FATS',
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _fatsController,
            unit: 'g',
            processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > food.getQuantityGrams() ? food.getQuantityGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.fatFactor = food.getQuantityGrams() != 0.0 ? value / food.getQuantityGrams() : 0.0;
            }
          )
        ),
        NutritionSection(
          name: 'SALT',
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _saltController,
            unit: 'g',
            processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > food.getQuantityGrams() ? food.getQuantityGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.saltFactor = food.getQuantityGrams() != 0.0 ? value / food.getQuantityGrams() : 0.0;
            }
          )
        ),
        NutritionSection(
          name: 'ALCOHOL',
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _alcoholController,
            unit: 'g',
            processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > food.getQuantityGrams() ? food.getQuantityGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.alcoholFactor = food.getQuantityGrams() != 0.0 ? value / food.getQuantityGrams() : 0.0;
            }
          )
        ),
      ],
    );
  }
}



class NutritionSection extends StatelessWidget {
  final String name;
  final Widget child;

  NutritionSection({this.name, this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(name, style: TextStyle(fontSize: smallSize(context))),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: child,
        )
      ],
    );
  }
}

class NutritionChildSection extends StatelessWidget {
  final String name;
  final Widget child;

  NutritionChildSection({this.name, this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
              child: Text(name, style: TextStyle(fontSize: smallSize(context))),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: child,
        )
      ],
    );
  }
}

