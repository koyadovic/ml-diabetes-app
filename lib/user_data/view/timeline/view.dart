import 'package:Dia/settings/controller/services.dart';
import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/user_data/view/timeline/day_container.dart';
import 'package:Dia/shared/view/widgets/dia_fa_icons.dart';
import 'package:Dia/user_data/view/timeline/view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:Dia/shared/tools/dates.dart';
import 'package:timezone/timezone.dart';


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
  final SettingsServices settingsServices = SettingsServices();
  Location localTimezone;

  @override
  void initState() {
    _viewModel = TimelineViewModel(this);
    settingsServices.getTimezone().then((tz) {
      setState(() {
        localTimezone = tz;
      });
    });
    super.initState();
  }

  refreshAll() {
    _viewModel.refreshAll();
  }

  Widget getIcon(ViewModelEntry entity) {
    switch(entity.type) {
      case 'GlucoseLevel':
        return GlucoseLevelIconSmall();
      case 'Feeding':
        return FeedingIconSmall();
      case 'Activity':
        return ActivityIconSmall();
      case 'Flag':
        return FlagIconSmall();
      case 'InsulinInjection':
        return InsulinInjectionIconSmall();
      case 'TraitMeasure':
        return TraitMeasureIconSmall();
    }

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    widget._state = this;
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
            if (_viewModel != null)
              ..._viewModel.days.map((day) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: TitledCardContainer(
                  title: DateFormat.MMMMd().format(day.date.toUtc().asTimezone(localTimezone)).toString(),
                  children: [
                    ...day.entries.asMap().entries.map((ent) {
                      int idx = ent.key;
                      ViewModelEntry entry = ent.value;
                      return InnerCardItem(
                        lineToTop: idx != 0,
                        lineToBottom: idx != day.entries.length - 1,
                        text: entry.text,
                        icon: getIcon(entry),
                        hourMinute: DateFormat.Hm().format(entry.eventDate.toUtc().asTimezone(localTimezone)),
                      );
                    })
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );

  }

  @override
  bool get wantKeepAlive => true;

}
