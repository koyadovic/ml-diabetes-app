import 'package:Dia/feedings/model/foods.dart';
import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/shared/view/widgets/dia_fa_icons.dart';
import 'package:Dia/shared/view/widgets/search_and_select.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

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

  @override
  Widget build(BuildContext context) {
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
}
