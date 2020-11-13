import 'package:Dia/feedings/model/foods.dart';
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
    return ListView(
      shrinkWrap: true,
      children: [
        // input for quantity
        Row(

        ),

        // nutricional facts

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
    );
  }
}
