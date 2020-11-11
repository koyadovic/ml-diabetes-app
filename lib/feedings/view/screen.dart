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


class FeedingsScreenWidgetState extends State<FeedingsScreenWidget> with WidgetsBindingObserver {
  Food foodFocused;
  double lat;
  double lng;

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
    if(_checkedLocation && (lat == null || lng == null)) return _disabledWidget();

    return Column(
      children: [
        SearchAndSelect<Food>(
          hintText: 'Search for food'.tr(),
          currentValue: foodFocused,
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
              foodFocused = value;
            });
          },
          renderItem: (Food value) => ListTile(
            leading: FeedingIconSmall(),
            title: Text(value.name),
          ),
        ),

      ],
    );
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
