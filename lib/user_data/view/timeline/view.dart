import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/shared/view/utils/enabled_status.dart';
import 'package:Dia/shared/view/utils/font_sizes.dart';
import 'package:Dia/shared/view/theme.dart';
import 'package:Dia/shared/view/widgets/day_container.dart';
import 'package:Dia/shared/view/widgets/dia_fa_icons.dart';
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

  ListTile userDataViewModelEntityToListTile(ViewModelEntry entity) {
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

    return ListTile(
      leading: Text(DateFormat.Hm().format(entity.eventDate), style: TextStyle(color: Colors.grey, fontSize: mediumSize(context))),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leading,
          if(entity.value is int || entity.value is double)
            EnabledStatus(
              isEnabled: false,
              child: UnitTextField(
                unit: entity.unit,
                initialValue: entity.value.toDouble(),
                onChange: null,
                valueSize: bigSize(context),
                unitSize: verySmallSize(context),
              ),
            ),
          if(!(entity.value is int) && !(entity.value is double))
            Text(entity.value, style: TextStyle(fontSize: mediumSize(context))),
        ],
      ),
      onTap: () {
        print(entity.entity.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scrollbar(
      child: SmartRefresher(
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
            // TODO fix this shit
            if (_viewModel != null)
              ..._viewModel.days.map((day) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: TitledCardContainer(
                  title: DateFormat.MMMMd().format(day.date.toLocal()).toString(),
                  children: [
                    ...day.entries.map((entry) => InnerCardItem(
                      title: entry.text,
                      color: entry.color,
                      child: userDataViewModelEntityToListTile(entry),
                    )),
                  ],
                ),
              ),
            ),

            // TODO uncomment this to get the old list
            // if (_viewModel != null)
            //   ..._viewModel.entries.map((entry) => userDataViewModelEntityToListTile(entry)),

          ],
        ),
      ),
    );

  }

  @override
  bool get wantKeepAlive => true;

}
