import 'package:Dia/shared/view/utils/messages.dart';
import 'package:Dia/shared/view/utils/navigation.dart';
import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/shared/view/utils/theme.dart';
import 'package:Dia/shared/view/widgets/dia_fa_icons.dart';
import 'package:Dia/user_data/view/timeline/view_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class Timeline extends DiaChildScreenStatefulWidget {

  Timeline(Navigation navigation, Messages messages) : super(navigation, messages);

  @override
  State<StatefulWidget> createState() {
    return TimelineState();
  }

}


class TimelineState extends State<Timeline> with AutomaticKeepAliveClientMixin<Timeline> {

  TimelineViewModel _viewModel;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    _viewModel = TimelineViewModel(this, widget.navigation, widget.messages);
    super.initState();
  }

  ListTile userDataViewModelEntityToListTile(UserDataViewModelEntity entity) {
    IconButton leading;
    switch(entity.type) {
      case 'GlucoseLevel':
        leading = IconButton(
          icon: DiaSmallFaIcon(FontAwesomeIcons.tint),
          onPressed: (){},
        );
        break;
      case 'Feeding':
        leading = IconButton(
          icon: DiaSmallFaIcon(FontAwesomeIcons.pizzaSlice),
          color: DiaTheme.primaryColor,
          onPressed: (){},
        );
        break;
      case 'Activity':
        leading = IconButton(
          icon: DiaSmallFaIcon(FontAwesomeIcons.dumbbell),
          onPressed: (){},
        );
        break;
      case 'Flag':
        leading = IconButton(
          icon: DiaSmallFaIcon(FontAwesomeIcons.flag),
          onPressed: (){},
        );
        break;
      case 'InsulinInjection':
        leading = IconButton(
          icon: DiaSmallFaIcon(FontAwesomeIcons.syringe),
          onPressed: (){},
        );
        break;
      case 'TraitMeasure':
        leading = IconButton(
          icon: DiaSmallFaIcon(FontAwesomeIcons.weight),
          onPressed: (){},
        );
        break;
    }


    return ListTile(
      leading: leading,
      title: Text(entity.text, style: TextStyle(color: Colors.black)),
      subtitle: Text(entity.eventDate.toIso8601String(), style: TextStyle(color: Colors.grey)),
      onTap: () {
        print(entity.entity.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
          if (_viewModel != null)
            ..._viewModel.entries.map((entry) => userDataViewModelEntityToListTile(entry)),
          // if(_viewModel.isLoading())
          //   Center(child: CircularProgressIndicator()),
        ],
      ),
    );

  }

  @override
  bool get wantKeepAlive => true;

}
