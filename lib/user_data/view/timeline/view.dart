import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/shared/view/utils/font_sizes.dart';
import 'package:Dia/shared/view/utils/theme.dart';
import 'package:Dia/shared/view/widgets/dia_fa_icons.dart';
import 'package:Dia/shared/view/widgets/search_and_select.dart';
import 'package:Dia/shared/view/widgets/unit_text_field.dart';
import 'package:Dia/user_data/view/timeline/view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class Timeline extends DiaChildScreenStatefulWidget {
  TimelineState _state;

  Timeline(DiaRootScreenStatefulWidget root) : super(root);

  @override
  State<StatefulWidget> createState() {
    _state = TimelineState();
    return _state;
  }

  void refresh() {
    _state?.refreshAll();
  }

}


class TimelineState extends State<Timeline> with AutomaticKeepAliveClientMixin<Timeline> {

  TimelineViewModel _viewModel;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    _viewModel = TimelineViewModel(this);
    super.initState();
  }

  refreshAll() {
    _viewModel.refreshAll();
  }

  ListTile userDataViewModelEntityToListTile(UserDataViewModelEntity entity) {
    IconButton leading;
    switch(entity.type) {
      case 'GlucoseLevel':
        leading = IconButton(
          icon: GlucoseLevelIconMedium(),
          onPressed: (){},
        );
        break;
      case 'Feeding':
        leading = IconButton(
          icon: FeedingIconMedium(),
          color: DiaTheme.primaryColor,
          onPressed: (){},
        );
        break;
      case 'Activity':
        leading = IconButton(
          icon: ActivityIconMedium(),
          onPressed: (){},
        );
        break;
      case 'Flag':
        leading = IconButton(
          icon: FlagIconMedium(),
          onPressed: (){},
        );
        break;
      case 'InsulinInjection':
        leading = IconButton(
          icon: InsulinInjectionIconMedium(),
          onPressed: (){},
        );
        break;
      case 'TraitMeasure':
        leading = IconButton(
          icon: TraitMeasureIconMedium(),
          onPressed: (){},
        );
        break;
    }

    double scalingFactor = screenSizeScalingFactor(context);

    return ListTile(
      leading: leading,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 5, 8.0),
            child: Text(entity.text, style: TextStyle(fontSize: mediumSize(context), fontWeight: FontWeight.w400)),
          ),
          if(entity.value is int || entity.value is double)
            UnitTextField(
              unitWidth: 60 * scalingFactor,
              unit: entity.unit,
              initialValue: entity.value.toDouble(),
              //enabled: false,
              colorDisabled: Colors.black87,
              // colorEnabled: Colors.black87,
              onChange: null,
            ),
          if(!(entity.value is int) && !(entity.value is double))
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 60 * scalingFactor, 8.0),
              child: Text(entity.value, style: TextStyle(fontSize: mediumSize(context), fontWeight: FontWeight.w300)),
            ),
        ],
      ),
      subtitle: Row(
        children: [
          Icon(Icons.calendar_today, size: smallSize(context), color: Colors.grey),
          Text(DateFormat.yMMMMEEEEd().format(entity.eventDate), style: TextStyle(color: Colors.grey)),
        ],
      ),
      onTap: () {
        print(entity.entity.id);
      },
    );
  }

  String searchAndSelectSelection;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: true,
      onRefresh: () async {
        await _viewModel.refreshAll();
        _refreshController.refreshCompleted();
      },
      onLoading: () async {
        await _viewModel.moreData();
        _refreshController.loadComplete();
      },
      child: ListView(
        children: [
          SearchAndSelect<String>(
            currentValue: searchAndSelectSelection,
            source: LocalSource<String>(
              data: ['Yes', 'No', 'Maybe'],
              matcher: (String element, String term) {
                return element.toLowerCase().contains(term.toLowerCase());
              }
            ),
            onSelected: (String value) {
              print('Selected $value');
              setState(() {
                searchAndSelectSelection = value;
              });
            },
          ),
          if (_viewModel != null)
            ..._viewModel.entries.map((entry) => userDataViewModelEntityToListTile(entry)),
        ],
      ),
    );

  }

  @override
  bool get wantKeepAlive => true;

}
