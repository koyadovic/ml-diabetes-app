import 'package:Dia/feedings/controller/services.dart';
import 'package:Dia/feedings/model/foods.dart';
import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/shared/view/theme.dart';
import 'package:Dia/shared/view/utils/font_sizes.dart';
import 'package:Dia/shared/view/utils/messages.dart';
import 'package:Dia/shared/view/widgets/dia_fa_icons.dart';
import 'package:Dia/shared/view/widgets/search_and_select.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';
import 'package:app_settings/app_settings.dart';

import 'food_editor.dart';


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
      // TODO en Pixel XL jamás retorna pos... se queda ahí.
      Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
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
                  source: APIRestSource<Food>(
                    endpoint: '/api/v1/foods/',
                    queryParameterName: 'q',
                    deserializer: Food.fromJson,
                    additionalQueryParameters: {
                      'lat': lat.toString(),
                      'lng': lng.toString(),
                    }
                  ),
                  onSelected: (Food value) {
                    setState(() {
                      _foodFocused = value;
                    });
                  },
                  renderItem: (Food value) => ListTile(
                    leading: FeedingIconSmall(),
                    title: Text(value.name),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  widget.showWidget(
                    FoodEditorWidget(
                      onClose: widget.hideWidget,
                      onSaveFood: (Food food) async {
                        await _feedingsServices.saveFood(food, lat, lng);
                        widget.hideWidget();
                        DiaMessages.getInstance().showInformation('Food added successfully. Now you can search for it'.tr());
                      },
                    )
                  );
                },
              )
            ],
          ),
          SizedBox(height: 10),

          // the table
          ...buildFoodSelectionTable(),

          FlatButton(
            child: Text('Finalize'),
            onPressed: () {
              print('Finished!');
            },
          ),
        ],
      ),
    );
  }

  List<Widget> buildFoodSelectionTable(){
    TextStyle primaryColorTextStyle = TextStyle(color: DiaTheme.primaryColor, fontSize: smallSize(context));
    TextStyle normalTextStyle = TextStyle(fontSize: smallSize(context), fontWeight: FontWeight.w300);

    double totalCarbs = 0.0;
    double totalKcal = 0.0;

    List<FourColumnsEntry> columnsForSelections = [];
    for(FoodSelection selection in _foodSelections) {
      totalCarbs += selection.carbGrams - selection.carbFiberGrams;
      totalKcal += selection.kcal;

      columnsForSelections.add(FourColumnsEntry(
        mainColumn: selection.food.name, mainTextStyle: normalTextStyle,
        secondColumn: selection.hasGramsPerUnit ? selection.units.toString() + 'u' : selection.grams.round().toString() + 'g',
        thirdColumn: (selection.carbGrams - selection.carbFiberGrams).round().toString() + 'g',
        fourthColumn: selection.kcal.round().toString() + 'kcal',
      ));
    }

    return [
      FourColumnsEntry(
        mainColumn: 'Food'.tr(), mainTextStyle: primaryColorTextStyle,
        secondColumn: 'Quantity'.tr(), secondTextStyle: primaryColorTextStyle,
        thirdColumn: 'Carb'.tr(), thirdTextStyle: primaryColorTextStyle,
        fourthColumn: 'KCal', fourthTextStyle: primaryColorTextStyle,
      ),

      Expanded(
        child: ListView(
          children: [
            ...columnsForSelections,
            FourColumnsEntry(
              mainColumn: 'Arroz', mainTextStyle: normalTextStyle,
              secondColumn: '200g', secondTextStyle: normalTextStyle,
              thirdColumn: '40g', thirdTextStyle: normalTextStyle,
              fourthColumn: '160', fourthTextStyle: normalTextStyle,
              onTap: () {
                print('Tapped!');
              },

            )
          ],
        ),
      ),
      //Totales
      Container(width: double.maxFinite, height: 2, color: DiaTheme.primaryColor),
      FourColumnsEntry(
        mainColumn: 'Total'.tr(), mainTextStyle: primaryColorTextStyle,
        secondColumn: '', secondTextStyle: normalTextStyle,
        thirdColumn: totalCarbs.round().toString() + 'g', thirdTextStyle: normalTextStyle,
        fourthColumn: totalKcal.round().toString(), fourthTextStyle: normalTextStyle,
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
              width: 80 * screenSizeScalingFactor(context),
              alignment: Alignment.centerRight,
              child: Text(secondColumn, style: secondTextStyle),
            ),
            Container(
              width: 80 * screenSizeScalingFactor(context),
              alignment: Alignment.centerRight,
              child: Text(thirdColumn, style: thirdTextStyle),
            ),
            Container(
              width: 80 * screenSizeScalingFactor(context),
              alignment: Alignment.centerRight,
              child: Text(fourthColumn, style: fourthTextStyle),
            ),
          ],
        ),
      ),
    );
  }

}