import 'package:Dia/feedings/controller/services.dart';
import 'package:Dia/feedings/model/foods.dart';
import 'package:Dia/shared/tools/numbers.dart';
import 'package:Dia/shared/view/theme.dart';
import 'package:Dia/shared/view/utils/font_sizes.dart';
import 'package:Dia/shared/view/utils/unfocus.dart';
import 'package:Dia/shared/view/widgets/unit_text_field.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'food_list_item.dart';


class FoodEditorWidget extends StatefulWidget {
  final Food food;

  final Function(Food) onSaveFood;
  final Function() onClose;
  final Function() onReportError;

  final double lat;
  final double lng;

  FoodEditorWidget({
    this.food,
    @required this.lat,
    @required this.lng,
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
  Food _editedFood;

  TextEditingController _nameController;
  TextEditingController _servingOfController = TextEditingController(text: '100');
  TextEditingController _weightPerUnitController = TextEditingController(text: '0.0');

  final FeedingsServices _feedingsServices = FeedingsServices();

  List<Food> _similarFoods;

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

    TextStyle validationStyle = TextStyle(color: Colors.red, height: 2.0);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Name of food'.tr()
            ),
            onChanged: (String value) {
              _editedFood.name = value;
              if(!_editedFood.isValid)
                setState(() {
                  _editedFood.validate();
                });
            },
          ),
          if(!_editedFood.isPropertyValid('name'))
          Text(_editedFood.getPropertyValidationText('name'), style: validationStyle),

          SizedBox(height: 10),
          Text(
            'To choose the next option, take a good look at the nutritional information. Does the carbohydrates section include fiber or does fiber appear separately?'.tr(),
            style: TextStyle(color: DiaTheme.primaryColor),
          ),
          DropdownButton<bool>(
            itemHeight: 70,
            isExpanded: true,
            value: _editedFood.isFiberSpecifiedSeparately,
            onChanged: (bool fiberIsSeparate) {
              unFocus(context);
              if(fiberIsSeparate){
                setState(() {
                  _editedFood.fiberIsSpecifiedSeparately();
                  if(!_editedFood.isValid)
                    _editedFood.validate();
                });
              } else {
                setState(() {
                  _editedFood.fiberIsIncludedInCarbs();
                  if(!_editedFood.isValid)
                    _editedFood.validate();
                });
              }
            },
            items: [
              DropdownMenuItem<bool>(
                value: true,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Fiber is specified separately'.tr(), style: TextStyle(fontSize: smallSize(context))),
                ),
              ),
              DropdownMenuItem<bool>(
                value: false,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Fiber is included in carbs section'.tr(), style: TextStyle(fontSize: smallSize(context))),
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Serving of'.tr(), style: TextStyle(fontSize: smallSize(context))),
              UnitTextField(
                valueSize: smallSize(context),
                unitSize: verySmallSize(context),
                externalController: _servingOfController,
                unit: 'g',
                processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > 600 ? 600.0 : value,
                ],
                autoFocus: false,
                onChange: (value) {
                  setState(() {
                    _editedFood.setServingOfGrams(value);
                  });
                }
              ),
            ],
          ),
          Container(height: 1, color: Colors.grey[300]),
          if(_editedFood.isFiberIncludedInCarbs)
            FoodEditorFiberInCarbsWidget(
              food: _editedFood,
              onFoodChange: () {
                setState(() {
                  _similarFoods = null;
                });
              },
            ),
          if(_editedFood.isFiberSpecifiedSeparately)
            FoodEditorFiberSeparatelyWidget(
              food: _editedFood,
              onFoodChange: () {
                setState(() {
                  _similarFoods = null;
                });
              },
            ),

          Container(height: 1, color: Colors.grey[300]),
          SizedBox(height: 10),
          Text(
            'When weight per food is specified'.tr(),
            style: TextStyle(color: DiaTheme.primaryColor),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Weight per unit'.tr(), style: TextStyle(fontSize: smallSize(context))),
              UnitTextField(
                valueSize: smallSize(context),
                unitSize: verySmallSize(context),
                externalController: _weightPerUnitController,
                unit: 'g',
                processors: [
                      (value) => value < 0.0 ? 0.0 : value,
                      (value) => value > 600 ? 600.0 : value,
                ],
                autoFocus: false,
                onChange: (value) {
                  setState(() {
                    _editedFood.gramsPerUnit = value;
                  });
                }
              ),
            ],
          ),

          if(!_editedFood.isValid)
            Text(_editedFood.getPropertyValidationText('global'), style: validationStyle),

          if(_similarFoods != null && _similarFoods.length > 0)
            ...[
              // It was found very similar food entries. Are you sure that the current food is brand new
              Text('It was found very similar food entries. Are you sure that the current food is brand new? If so, press save again.'.tr(), style: TextStyle(color: DiaTheme.primaryColor),),
              SizedBox(height: 10,),
              ..._similarFoods.map((food) => FoodListTile(
                food: food,
                //appendInTitle: (food.similarity * 100).round().toString() + '%',
              )),
            ],

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
                onPressed: () async {
                  _editedFood.validate();
                  setState(() {
                  });

                  if(_editedFood.isValid) {
                    if(_editedFood.isFiberSpecifiedSeparately) {
                      _editedFood.carbFactor += _editedFood.carbFiberFactor;
                    }

                    // food is valid so before save it, if _similarFoods is null, search for similar foods!
                    if(_similarFoods == null) {
                      List<Food> similarFood = await _feedingsServices.getSimilarFood(_editedFood, widget.lat, widget.lng);
                      if(similarFood.length > 0) {
                        if(_editedFood.isFiberSpecifiedSeparately) {
                          _editedFood.carbFactor -= _editedFood.carbFiberFactor;
                        }
                        setState(() {
                          // TODO suggest enhance to existing foods
                          _similarFoods = similarFood;
                        });
                      } else {
                        // there is no similar food. Save it!
                        widget.onSaveFood(_editedFood);
                      }
                    } else {
                      // search for similar foods was done yet!

                      // disabled! because this validations will come from the backend
                      // if(_similarFoods.length > 0) {
                      //   Food mostSimilarFood = _similarFoods[0];
                      //   if (mostSimilarFood.similarity == 1.0) {
                      //     // TODO Error!
                      //   }
                      //   else if(mostSimilarFood.name.toLowerCase() == _editedFood.name.toLowerCase()) {
                      //     // TODO error!
                      //   }
                      // }
                      // so save it!
                      widget.onSaveFood(_editedFood);
                    }
                  }
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
  final Food food;

  TextEditingController _carbsTotalController;
  TextEditingController _carbsSugarController;
  TextEditingController _carbsFiberController;
  TextEditingController _proteinsController;
  TextEditingController _fatsController;
  TextEditingController _saltController;
  TextEditingController _alcoholController;

  final Function onFoodChange;

  FoodEditorFiberInCarbsWidget({this.food, @required this.onFoodChange}) {
    _carbsTotalController = TextEditingController(text: (round(food.carbFactor * food.getServingOfGrams(), 2)).toString());
    _carbsSugarController = TextEditingController(text: (round(food.carbSugarFactor * food.getServingOfGrams(), 2)).toString());
    _carbsFiberController = TextEditingController(text: (round(food.carbFiberFactor * food.getServingOfGrams(), 2)).toString());
    _proteinsController = TextEditingController(text: (round(food.proteinFactor * food.getServingOfGrams(), 2)).toString());
    _fatsController = TextEditingController(text: (round(food.fatFactor * food.getServingOfGrams(), 2)).toString());
    _saltController = TextEditingController(text: (round(food.saltFactor * food.getServingOfGrams(), 2)).toString());
    _alcoholController = TextEditingController(text: (round(food.alcoholFactor * food.getServingOfGrams(), 2)).toString());
  }

  @override
  Widget build(BuildContext context) {
    _carbsTotalController.text = (round(food.carbFactor * food.getServingOfGrams(), 2)).toString();
    _carbsSugarController.text = (round(food.carbSugarFactor * food.getServingOfGrams(), 2)).toString();
    _carbsFiberController.text = (round(food.carbFiberFactor * food.getServingOfGrams(), 2)).toString();
    _proteinsController.text = (round(food.proteinFactor * food.getServingOfGrams(), 2)).toString();
    _fatsController.text = (round(food.fatFactor * food.getServingOfGrams(), 2)).toString();
    _saltController.text = (round(food.saltFactor * food.getServingOfGrams(), 2)).toString();
    _alcoholController.text = (round(food.alcoholFactor * food.getServingOfGrams(), 2)).toString();

    TextStyle validationStyle = TextStyle(color: Colors.red);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        NutritionSection(
          name: 'CARBOHYDRATES'.tr(),
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _carbsTotalController,
            unit: 'g',
            processors: [
              (value) => value < 0.0 ? 0.0 : value,
              (value) => value > food.getServingOfGrams() ? food.getServingOfGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.carbFactor = food.getServingOfGrams() != 0.0 ? value / food.getServingOfGrams() : 0.0;
              if(!food.isValid)
                food.validate();
              onFoodChange();
            }
          )
        ),
        if(!food.isPropertyValid('carb_factor'))
        Text(food.getPropertyValidationText('carb_factor'), style: validationStyle),

        NutritionChildSection(
          name: '○  ' + 'Sugar'.tr(),
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _carbsSugarController,
            unit: 'g',
            processors: [
              (value) => value < 0.0 ? 0.0 : value,
              (value) => value > food.getServingOfGrams() ? food.getServingOfGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.carbSugarFactor = food.getServingOfGrams() != 0.0 ? value / food.getServingOfGrams() : 0.0;
              if(!food.isValid)
                food.validate();
              onFoodChange();
            }
          )
        ),
        if(!food.isPropertyValid('carb_sugar_factor'))
          Text(food.getPropertyValidationText('carb_sugar_factor'), style: validationStyle),
        NutritionChildSection(
          name: '○  ' + 'Fiber'.tr(),
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _carbsFiberController,
            unit: 'g',
            processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > food.getServingOfGrams() ? food.getServingOfGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.carbFiberFactor = food.getServingOfGrams() != 0.0 ? value / food.getServingOfGrams() : 0.0;
              if(!food.isValid)
                food.validate();
              onFoodChange();
            }
          )
        ),
        if(!food.isPropertyValid('carb_fiber_factor'))
          Text(food.getPropertyValidationText('carb_fiber_factor'), style: validationStyle),
        NutritionSection(
          name: 'PROTEINS'.tr(),
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _proteinsController,
            unit: 'g',
            processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > food.getServingOfGrams() ? food.getServingOfGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.proteinFactor = food.getServingOfGrams() != 0.0 ? value / food.getServingOfGrams() : 0.0;
              if(!food.isValid)
                food.validate();
              onFoodChange();
            }
          )
        ),
        if(!food.isPropertyValid('protein_factor'))
          Text(food.getPropertyValidationText('protein_factor'), style: validationStyle),
        NutritionSection(
          name: 'FATS'.tr(),
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _fatsController,
            unit: 'g',
            processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > food.getServingOfGrams() ? food.getServingOfGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.fatFactor = food.getServingOfGrams() != 0.0 ? value / food.getServingOfGrams() : 0.0;
              if(!food.isValid)
                food.validate();
              onFoodChange();
            }
          )
        ),
        if(!food.isPropertyValid('fat_factor'))
          Text(food.getPropertyValidationText('fat_factor'), style: validationStyle),
        NutritionSection(
          name: 'SALT'.tr(),
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _saltController,
            unit: 'g',
            processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > food.getServingOfGrams() ? food.getServingOfGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.saltFactor = food.getServingOfGrams() != 0.0 ? value / food.getServingOfGrams() : 0.0;
              if(!food.isValid)
                food.validate();
              onFoodChange();
            }
          )
        ),
        if(!food.isPropertyValid('salt_factor'))
          Text(food.getPropertyValidationText('salt_factor'), style: validationStyle),
        NutritionSection(
          name: 'ALCOHOL'.tr(),
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _alcoholController,
            unit: 'g',
            processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > food.getServingOfGrams() ? food.getServingOfGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.alcoholFactor = food.getServingOfGrams() != 0.0 ? value / food.getServingOfGrams() : 0.0;
              if(!food.isValid)
                food.validate();
              onFoodChange();
            }
          )
        ),
        if(!food.isPropertyValid('alcohol_factor'))
          Text(food.getPropertyValidationText('alcohol_factor'), style: validationStyle),
      ],
    );
  }
}


class FoodEditorFiberSeparatelyWidget extends StatelessWidget {
  final Food food;

  TextEditingController _carbsTotalController;
  TextEditingController _carbsSugarController;
  TextEditingController _carbsFiberController;
  TextEditingController _proteinsController;
  TextEditingController _fatsController;
  TextEditingController _saltController;
  TextEditingController _alcoholController;

  final Function onFoodChange;

  FoodEditorFiberSeparatelyWidget({this.food, @required this.onFoodChange}){
    _carbsTotalController = TextEditingController(text: (round((food.carbFactor - food.carbFiberFactor) * food.getServingOfGrams(), 2)).toString());
    _carbsSugarController = TextEditingController(text: (round(food.carbSugarFactor * food.getServingOfGrams(), 2)).toString());
    _carbsFiberController = TextEditingController(text: (round(food.carbFiberFactor * food.getServingOfGrams(), 2)).toString());
    _proteinsController = TextEditingController(text: (round(food.proteinFactor * food.getServingOfGrams(), 2)).toString());
    _fatsController = TextEditingController(text: (round(food.fatFactor * food.getServingOfGrams(), 2)).toString());
    _saltController = TextEditingController(text: (round(food.saltFactor * food.getServingOfGrams(), 2)).toString());
    _alcoholController = TextEditingController(text: (round(food.alcoholFactor * food.getServingOfGrams(), 2)).toString());
  }

  @override
  Widget build(BuildContext context) {
    // restale la fibra
    _carbsTotalController.text = (round((food.carbFactor - food.carbFiberFactor) * food.getServingOfGrams(), 2)).toString();
    _carbsSugarController.text = (round(food.carbSugarFactor * food.getServingOfGrams(), 2)).toString();
    _carbsFiberController.text = (round(food.carbFiberFactor * food.getServingOfGrams(), 2)).toString();
    _proteinsController.text = (round(food.proteinFactor * food.getServingOfGrams(), 2)).toString();
    _fatsController.text = (round(food.fatFactor * food.getServingOfGrams(), 2)).toString();
    _saltController.text = (round(food.saltFactor * food.getServingOfGrams(), 2)).toString();
    _alcoholController.text = (round(food.alcoholFactor * food.getServingOfGrams(), 2)).toString();

    TextStyle validationStyle = TextStyle(color: Colors.red);

    return Column(
      children: [
        NutritionSection(
          name: 'CARBOHYDRATES'.tr(),
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _carbsTotalController,
            unit: 'g',
            processors: [
              (value) => value < 0.0 ? 0.0 : value,
              (value) => value > food.getServingOfGrams() ? food.getServingOfGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.carbFactor = food.getServingOfGrams() != 0.0 ? value / food.getServingOfGrams() : 0.0;
              if(!food.isValid)
                food.validate();
              onFoodChange();
            }
          )
        ),
        if(!food.isPropertyValid('carb_factor'))
          Text(food.getPropertyValidationText('carb_factor'), style: validationStyle),
        NutritionChildSection(
          name: '○  ' + 'Sugar'.tr(),
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _carbsSugarController,
            unit: 'g',
            processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > food.getServingOfGrams() ? food.getServingOfGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.carbSugarFactor = food.getServingOfGrams() != 0.0 ? value / food.getServingOfGrams() : 0.0;
              if(!food.isValid)
                food.validate();
              onFoodChange();
            }
          )
        ),
        if(!food.isPropertyValid('carb_sugar_factor'))
          Text(food.getPropertyValidationText('carb_sugar_factor'), style: validationStyle),
        NutritionSection(
          name: 'FIBER'.tr(),
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _carbsFiberController,
            unit: 'g',
            processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > food.getServingOfGrams() ? food.getServingOfGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.carbFiberFactor = food.getServingOfGrams() != 0.0 ? value / food.getServingOfGrams() : 0.0;
              if(!food.isValid)
                food.validate();
              onFoodChange();
            }
          )
        ),
        if(!food.isPropertyValid('carb_fiber_factor'))
          Text(food.getPropertyValidationText('carb_fiber_factor'), style: validationStyle),
        NutritionSection(
          name: 'PROTEINS'.tr(),
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _proteinsController,
            unit: 'g',
            processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > food.getServingOfGrams() ? food.getServingOfGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.proteinFactor = food.getServingOfGrams() != 0.0 ? value / food.getServingOfGrams() : 0.0;
              if(!food.isValid)
                food.validate();
              onFoodChange();
            }
          )
        ),
        if(!food.isPropertyValid('protein_factor'))
          Text(food.getPropertyValidationText('protein_factor'), style: validationStyle),
        NutritionSection(
          name: 'FATS'.tr(),
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _fatsController,
            unit: 'g',
            processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > food.getServingOfGrams() ? food.getServingOfGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.fatFactor = food.getServingOfGrams() != 0.0 ? value / food.getServingOfGrams() : 0.0;
              if(!food.isValid)
                food.validate();
              onFoodChange();
            }
          )
        ),
        if(!food.isPropertyValid('fat_factor'))
          Text(food.getPropertyValidationText('fat_factor'), style: validationStyle),
        NutritionSection(
          name: 'SALT'.tr(),
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _saltController,
            unit: 'g',
            processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > food.getServingOfGrams() ? food.getServingOfGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.saltFactor = food.getServingOfGrams() != 0.0 ? value / food.getServingOfGrams() : 0.0;
              if(!food.isValid)
                food.validate();
              onFoodChange();
            }
          )
        ),
        if(!food.isPropertyValid('salt_factor'))
          Text(food.getPropertyValidationText('salt_factor'), style: validationStyle),
        NutritionSection(
          name: 'ALCOHOL'.tr(),
          child: UnitTextField(
            valueSize: smallSize(context),
            unitSize: verySmallSize(context),
            externalController: _alcoholController,
            unit: 'g',
            processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > food.getServingOfGrams() ? food.getServingOfGrams() : value,
            ],
            autoFocus: false,
            onChange: (value) {
              food.alcoholFactor = food.getServingOfGrams() != 0.0 ? value / food.getServingOfGrams() : 0.0;
              if(!food.isValid)
                food.validate();
              onFoodChange();
            }
          )
        ),
        if(!food.isPropertyValid('alcohol_factor'))
          Text(food.getPropertyValidationText('alcohol_factor'), style: validationStyle),
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
