import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/shared/view/utils/theme.dart';
import 'package:Dia/shared/view/widgets/dia_fa_icons.dart';
import 'package:Dia/shared/view/widgets/unit_input.dart';
import 'package:Dia/user_data/view/timeline/view_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class Timeline extends DiaChildScreenStatefulWidget {

  Timeline(DiaRootScreenStatefulWidget root) : super(root);

  @override
  State<StatefulWidget> createState() {
    return TimelineState();
  }

}

/*
TODO aquí tendremos que crear otro overlay para los añadidos
  Dependiendo de la acción solicitada, se tendrá que insertar en el overlay
  el widget de añadido que corresponda.

  Los widgets de añadidos tienen que poder ser mostrados en una lista sin que quede feo.
  Tienen que ser stateful y manejar internamente su estado. Si todos los elementos
  de la lista han sido manejados se ha de quitar el overlay.

  Los widgets de añadidos tienen que permitir ser editados o no. Si no son editables
  pueden seguir siendo descartados.

  Quien los engloba tiene que tener la cuenta de todos los que son y cuántos han sido manejados.
  Tendrá que pasar un callback a todos los hijos. Estos tendrán que llamar al callback
  siempre que el añadido es manejado (aceptado o descartado)

  Esto mismo se usará en el main_screen.dart
 */

class TimelineState extends State<Timeline> with AutomaticKeepAliveClientMixin<Timeline> {

  TimelineViewModel _viewModel;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    _viewModel = TimelineViewModel(this);
    super.initState();

    Widget widgetToShow = ListView(
      shrinkWrap: true,
      children: [
        ListTile(title: Text('This is a test')),
        ListTile(title: Text('This is a test')),
        ListTile(title: Text('This is a test')),
        FlatButton(
          onPressed: widget.diaRootScreen.hideWidget,
          child: Text('Close'),
        )
      ],
    );

    // Future.delayed(Duration(seconds: 1), () {
    //   widget.diaRootScreen.showWidget(widgetToShow, WidgetPosition.TOP);
    // });
    // Future.delayed(Duration(seconds: 2), () {
    //   widget.diaRootScreen.hideWidget();
    // });
    // Future.delayed(Duration(seconds: 3), () {
    //   widget.diaRootScreen.showWidget(widgetToShow, WidgetPosition.CENTER);
    // });
    // Future.delayed(Duration(seconds: 4), () {
    //   widget.diaRootScreen.hideWidget();
    // });
    // Future.delayed(Duration(seconds: 5), () {
    //   widget.diaRootScreen.showWidget(widgetToShow, WidgetPosition.BOTTOM);
    // });
    // Future.delayed(Duration(seconds: 6), () {
    //   widget.diaRootScreen.hideWidget();
    // });

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
          if (_viewModel != null)
            ..._viewModel.entries.map((entry) => userDataViewModelEntityToListTile(entry)),

          UnitInput('mg/dL', min: 0.0, max: 600.0, onChange: (value) {
            print('Glucosa!: $value');
          }),
          UnitInput('g', onChange: (value) {
            print('Gramos!: $value');
          }),
        ],
      ),
    );

  }

  @override
  bool get wantKeepAlive => true;

}
