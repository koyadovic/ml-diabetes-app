import 'package:Dia/feedings/model/foods.dart';
import 'package:flutter/material.dart';

class FoodEditorWidget extends StatefulWidget {
  final Food food;

  FoodEditorWidget({this.food});

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

  @override
  void initState() {
    _editedFood = widget.food.clone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_editedFood.isFiberIncludedInCarbs)
      return FoodEditorFiberInCarbsWidget();
    return FoodEditorFiberSeparatelyWidget();
  }
}


class FoodEditorFiberInCarbsWidget extends StatelessWidget {
  final Food food;

  FoodEditorFiberInCarbsWidget({this.food});

  @override
  Widget build(BuildContext context) {
    return Column(

    );
  }
}


class FoodEditorFiberSeparatelyWidget extends StatelessWidget {
  final Food food;

  FoodEditorFiberSeparatelyWidget({this.food});

  @override
  Widget build(BuildContext context) {
    return Column(

    );
  }
}
