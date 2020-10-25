import 'package:Dia/shared/view/messages.dart';
import 'package:Dia/shared/view/navigation.dart';
import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/shared/view/theme.dart';
import 'package:Dia/user_data/view/timeline/view_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Timeline extends DiaChildScreenStatefulWidget {

  Timeline(Navigation navigation, Messages messages) : super(navigation, messages);

  @override
  State<StatefulWidget> createState() {
    return TimelineState();
  }

}


class TimelineState extends State<Timeline> {

  TimelineViewModel _viewModel;

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
          icon: FaIcon(FontAwesomeIcons.tint),
          onPressed: (){},
        );
        break;
      case 'Feeding':
        leading = IconButton(
          icon: FaIcon(FontAwesomeIcons.pizzaSlice),
          color: DiaTheme.primaryColor,
          onPressed: (){},
        );
        break;
      case 'Activity':
        leading = IconButton(
          icon: FaIcon(FontAwesomeIcons.dumbbell),
          onPressed: (){},
        );
        break;
      case 'Flag':
        leading = IconButton(
          icon: FaIcon(FontAwesomeIcons.flag),
          onPressed: (){},
        );
        break;
      case 'InsulinInjection':
        leading = IconButton(
          icon: FaIcon(FontAwesomeIcons.syringe),
          onPressed: (){},
        );
        break;
      case 'TraitMeasure':
        leading = IconButton(
          icon: FaIcon(FontAwesomeIcons.weight),
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
    return NotificationListener<ScrollEndNotification>(
      child: ListView(
        children: [
          if (_viewModel != null)
            ..._viewModel.entries.map((entry) => userDataViewModelEntityToListTile(entry)),

          if(_viewModel.isLoading())
            Center(child: CircularProgressIndicator()),
        ],
      ),
      onNotification: (notification) {
        _viewModel.moreData();
        return false;  // false continues to bubble the notification to ancestors
      },
    );
  }
}
