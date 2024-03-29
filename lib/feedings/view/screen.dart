import 'package:iDietFit/feedings/controller/services.dart';
import 'package:iDietFit/feedings/model/foods.dart';
import 'package:iDietFit/shared/services/api_rest_backend.dart';
import 'package:iDietFit/shared/tools/numbers.dart';
import 'package:iDietFit/shared/view/error_handlers.dart';
import 'package:iDietFit/shared/view/screen_widget.dart';
import 'package:iDietFit/shared/view/theme.dart';
import 'package:iDietFit/shared/view/utils/font_sizes.dart';
import 'package:iDietFit/shared/view/messages.dart';
import 'package:iDietFit/shared/view/utils/navigation.dart';
import 'package:iDietFit/shared/view/widgets/dia_fa_icons.dart';
import 'package:iDietFit/shared/view/widgets/search_and_select.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';
import 'package:app_settings/app_settings.dart';

import 'food_editor.dart';
import 'food_list_item.dart';
import 'food_selection.dart';


// ignore: must_be_immutable
class FeedingsScreenWidget extends DiaRootScreenStatefulWidget {
  FeedingsScreenWidgetState _state;

  FeedingsScreenWidget(ShowWidget showWidget, HideWidget hideWidget) : super(showWidget: showWidget, hideWidget: hideWidget);

  @override
  bool hasAppBar() {
    return true;
  }

  @override
  bool hasDrawer() {
    return true;
  }

  @override
  String getAppBarTitle() {
    return 'Feedings';
  }

  @override
  State<StatefulWidget> createState() {
    _state = FeedingsScreenWidgetState();
    return _state;
  }

}


class FeedingsScreenWidgetState extends State<FeedingsScreenWidget> with WidgetsBindingObserver {
  List<FoodSelection> _foodSelections = [];
  Food _foodFocused;
  double lat;
  double lng;

  final FeedingsServices _feedingsServices = FeedingsServices();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _checkAndUpdateLocation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAndUpdateLocation();
    }
  }

  bool _checkedLocation = false;

  Future<void> _checkAndUpdateLocation() async {
    if(_checkedLocation) return;
    try{
      Position pos = await Geolocator.getCurrentPosition();
      setState(() {
        lat = pos != null ? pos.latitude : null;
        lng = pos != null ? pos.longitude : null;
      });
    }
    on PermissionDeniedException catch(e) {
      print('User denied permission');
    }
    finally {
      _checkedLocation = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    widget._state = this;

    if(!_checkedLocation) {
      return Center(
        child: CircularProgressIndicator()
      );
    }

    if(_checkedLocation && (lat == null || lng == null)) return _disabledWidget();

    return Padding(
      padding: EdgeInsets.all(15.0 * screenSizeScalingFactor(context)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SearchAndSelect<Food>(
                  hintText: 'Search for food'.tr(),
                  currentValue: _foodFocused,
                  clearWhenSelected: true,
                  source: APIRestSource<Food>(
                    endpoint: '/api/v1/foods/',
                    queryParameterName: 'q',
                    deserializer: Food.fromJson,
                    additionalQueryParameters: {
                      'lat': lat.toString(),
                      'lng': lng.toString(),
                    },
                    errorHandler: (err) {
                      withBackendErrorHandlersOnView(() {
                        throw err;
                      });
                    }
                  ),
                  onSelected: (Food food) {
                    if(food == null) return;
                    openFoodSelectionDialog(FoodSelection(food: food, grams: 0));
                  },
                  renderItem: (SearchAndSelectState state, Food value) => FoodListTile(
                    food: value,
                    onEditRequest: () {
                      state.clear();
                      openFoodEditor(foodForEdition: value);
                    },
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  openFoodEditor();
                },
              )
            ],
          ),
          SizedBox(height: 10),

          // the table
          ...buildFoodSelectionTable(),

          FlatButton(
            child: Text('Finalize'.tr()),
            onPressed: _foodSelections.length == 0 ? null : () async {
              await _feedingsServices.saveFoodSelections(_foodSelections);
              DiaMessages.getInstance().showBriefMessage('New feeding added to Dia!'.tr());
              DiaNavigation.getInstance().requestScreenChange(DiaScreen.USER_DATA, andReplaceNavigationHistory: true);
            },
          ),
        ],
      ),
    );
  }

  void openFoodEditor({Food foodForEdition}) {
    widget.showWidget(
        FoodEditorWidget(
          food: foodForEdition,
          lat: lat,
          lng: lng,
          onClose: widget.hideWidget,
          onEditOtherFood: (Food otherFood) {
            widget.hideWidget();
            openFoodEditor(foodForEdition: otherFood);
          },
          onSaveFood: (Food food) {
            withBackendErrorHandlersOnView(() async {
              try {
                await _feedingsServices.saveFood(food, lat, lng);
                widget.hideWidget();
                DiaMessages.getInstance().showBriefMessage('Food saved successfully'.tr());
              } on BackendBadRequest catch(err) {
                DiaMessages.getInstance().showDialogMessage(err.toString());
              }
            });
          },
        )
    );
  }

  void openFoodSelectionDialog(FoodSelection selection, {int idx}) {
    widget.showWidget(
        FoodSelectionWidget(
          food: selection.food,
          previousGrams: selection.grams,
          onClose: widget.hideWidget,
          onRemove: idx == null ? null : () {
            setState(() {
              _foodSelections.removeAt(idx);
            });
            widget.hideWidget();
          },
          onSaveFoodSelection: (FoodSelection newSelection) {
            if (idx != null) {
              setState(() {
                _foodSelections.replaceRange(idx, idx + 1, [newSelection]);
              });
            } else {
              setState(() {
                _foodSelections.add(newSelection);
              });
            }
            widget.hideWidget();
          },
        )
    );
  }

  List<Widget> buildFoodSelectionTable(){
    TextStyle primaryColorTextStyle = TextStyle(color: DiaTheme.primaryColor, fontSize: smallSize(context));
    TextStyle normalTextStyle = TextStyle(fontSize: smallSize(context), fontWeight: FontWeight.w300);

    double totalCarbs = 0.0;
    double totalKcal = 0.0;

    List<FourColumnsEntry> columnsForSelections = [];
    for(int i=0; i<_foodSelections.length; i++) {
      FoodSelection selection = _foodSelections[i];
      totalCarbs += selection.carbGrams - selection.carbFiberGrams;
      totalKcal += selection.kcal;
      columnsForSelections.add(
        FourColumnsEntry(
          onTap: () {
            openFoodSelectionDialog(selection, idx: i);
          },
          mainColumn: selection.food.name, mainTextStyle: normalTextStyle,
          secondColumn: selection.hasGramsPerUnit ? selection.units.toString() + 'u' : round(selection.grams, 1).toString() + 'g', secondTextStyle: normalTextStyle,
          thirdColumn: round(selection.carbGrams - selection.carbFiberGrams, 1).toString() + 'g', thirdTextStyle: normalTextStyle,
          fourthColumn: round(selection.kcal, 1).toString() + 'kcal', fourthTextStyle: normalTextStyle,
        )
      );
    }

    return [
      FourColumnsEntry(
        mainColumn: 'Food'.tr(), mainTextStyle: primaryColorTextStyle,
        secondColumn: 'Quantity'.tr(), secondTextStyle: primaryColorTextStyle,
        thirdColumn: 'Carb'.tr(), thirdTextStyle: primaryColorTextStyle,
        fourthColumn: 'Energy'.tr(), fourthTextStyle: primaryColorTextStyle,
      ),

      Expanded(
        child: ListView(
          children: [
            ...columnsForSelections,
          ],
        ),
      ),
      //Totales
      Container(width: double.maxFinite, height: 2, color: DiaTheme.primaryColor),
      FourColumnsEntry(
        mainColumn: 'Total'.tr(), mainTextStyle: primaryColorTextStyle,
        secondColumn: '', secondTextStyle: normalTextStyle,
        thirdColumn: round(totalCarbs, 1).toString() + 'g', thirdTextStyle: normalTextStyle,
        fourthColumn: round(totalKcal, 1).toString() + 'kcal', fourthTextStyle: normalTextStyle,
      ),
    ];
  }

  Widget _disabledWidget() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You cannot use Dia without access to your location'.tr()),
            FlatButton(
              onPressed: () async {
                _checkedLocation = false;
                await AppSettings.openAppSettings();
              },
              child: Text('Open App Settings'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}


class FourColumnsEntry extends StatelessWidget {
  String mainColumn;
  String secondColumn;
  String thirdColumn;
  String fourthColumn;

  TextStyle mainTextStyle;
  TextStyle secondTextStyle;
  TextStyle thirdTextStyle;
  TextStyle fourthTextStyle;

  final Function onTap;

  FourColumnsEntry({this.mainColumn, this.secondColumn, this.thirdColumn, this.fourthColumn,
    this.mainTextStyle, this.secondTextStyle, this.thirdTextStyle, this.fourthTextStyle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(mainColumn, style: mainTextStyle),
              ),
            ),
            Container(
              width: 90 * screenSizeScalingFactor(context),
              alignment: Alignment.centerRight,
              child: Text(secondColumn, style: secondTextStyle),
            ),
            Container(
              width: 90 * screenSizeScalingFactor(context),
              alignment: Alignment.centerRight,
              child: Text(thirdColumn, style: thirdTextStyle),
            ),
            Container(
              width: 90 * screenSizeScalingFactor(context),
              alignment: Alignment.centerRight,
              child: Text(fourthColumn, style: fourthTextStyle),
            ),
          ],
        ),
      ),
    );
  }

}