import 'package:Dia/feedings/model/foods.dart';
import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/shared/view/utils/navigation.dart';
import 'package:Dia/shared/view/widgets/dia_fa_icons.dart';
import 'package:Dia/shared/view/widgets/search_and_select.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';
import 'package:app_settings/app_settings.dart';


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


class FeedingsScreenWidgetState extends State<FeedingsScreenWidget> {
  Food foodFocushed;
  double lat;
  double lng;

  String locationServicesCheck;

  @override
  void initState() {
    _checkAndUpdateLocation();
    super.initState();
  }

  Future<void> _checkAndUpdateLocation() async {
    print('_checkAndUpdateLocation()');
    Position pos;
    LocationPermission permission;
    String locationCheck;
    try{
      print('Checking permissions');
      permission = await Geolocator.checkPermission();
      print(permission);
      print('Getting current position');
      if(permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      }
    } on PermissionDeniedException catch(err) {
      locationCheck = 'You cannot use Dia without access to your location'.tr();
    }
    print(permission);
    switch (permission) {
      case LocationPermission.denied:
      case LocationPermission.deniedForever:
        locationCheck = 'You cannot use Dia without access to your location'.tr();
        break;
      default:
        locationCheck = null;
    }
    print('Setting state');
    setState(() {
      locationServicesCheck = locationCheck;
      lat = pos != null ? pos.latitude : null;
      lng = pos != null ? pos.longitude : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(locationServicesCheck != null) return _disabledWidget();
    if(lat == null || lng == null)
      return Center(
        child: CircularProgressIndicator(),
      );

    return Column(
      children: [
        SearchAndSelect<Food>(
          hintText: 'Search for food'.tr(),
          currentValue: foodFocushed,
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
            foodFocushed = value;
          },
          renderItem: (Food value) => ListTile(
            leading: FeedingIconSmall(),
            title: Text(value.name),
            //subtitle: Text(value.mets.toString() + ' METs'),
          ),
        ),

      ],
    );
  }

  Widget _disabledWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(locationServicesCheck),
          FlatButton(
            onPressed: () async {
              await AppSettings.openAppSettings();
              DiaNavigation.getInstance().requestScreenChange(DiaScreen.USER_DATA);
            },
            child: Text('Open App Settings'.tr()),
          ),
        ],
      ),
    );
  }
}
