import 'package:Dia/feedings/model/foods.dart';
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

    // if(_editedFood.isFiberIncludedInCarbs)
    //   return FoodEditorFiberInCarbsWidget();
    // return FoodEditorFiberSeparatelyWidget();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          TextField(
            controller: _nameController,
          ),
          Text('To choose the next option, take a good look at the nutritional information. Does the carbohydrates section include fiber or does fiber appear separately?'.tr()),
          DropdownButton<bool>(
            isExpanded: true,
            isDense: false,
            value: _editedFood.isFiberSpecifiedSeparately,
            onChanged: (bool fiberIsSeparate) {
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
                child: Text('Fiber is specified separately'.tr()),
              ),
              DropdownMenuItem<bool>(
                value: false,
                child: Text('Fiber is included in carbs section'.tr()),
              )
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
                  print('Save food');
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

  FoodEditorFiberInCarbsWidget({this.food});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NutritionSection(name: 'CARBS', child: Text('85g')),
        NutritionChildSection(name: '- sugar', child: Text('85g')),
        NutritionChildSection(name: '- fiber', child: Text('85g')),
        NutritionSection(name: 'PROTEINS', child: Text('85g')),
        NutritionSection(name: 'FATS', child: Text('85g')),
        NutritionSection(name: 'SALT', child: Text('85g')),
        NutritionSection(name: 'ALCOHOL', child: Text('85g')),
      ],
    );
  }
}


class FoodEditorFiberSeparatelyWidget extends StatelessWidget {

  // TODO Cuando cambie fiber cambia fiber y carbs totales. Al representar carbs totales restar fiber. Apañao

  final Food food;

  FoodEditorFiberSeparatelyWidget({this.food});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NutritionSection(name: 'CARBS', child: Text('85g')),
        NutritionChildSection(name: '- sugar', child: Text('85g')),
        NutritionSection(name: 'FIBER', child: Text('85g')),
        NutritionSection(name: 'PROTEINS', child: Text('85g')),
        NutritionSection(name: 'FATS', child: Text('85g')),
        NutritionSection(name: 'SALT', child: Text('85g')),
        NutritionSection(name: 'ALCOHOL', child: Text('85g')),
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
            child: Text(name),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          width: 100,
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
              child: Text(name),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          width: 100,
          child: child,
        )
      ],
    );
  }
}

