import 'package:Dia/settings/model/entities.dart';
import 'package:Dia/settings/view/view_model.dart';
import 'package:Dia/shared/view/screen_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SettingsScreenWidget extends DiaRootScreenStatefulWidget {
  SettingsScreenWidgetState _state;

  SettingsScreenWidget(ShowWidget showWidget, HideWidget hideWidget) : super(showWidget: showWidget, hideWidget: hideWidget);

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
    return 'Settings';
  }

  @override
  List<Widget> getAppBarActions() {
    return [];
  }

  @override
  State<StatefulWidget> createState() {
    _state = SettingsScreenWidgetState();
    return _state;
  }

}


class SettingsScreenWidgetState extends State<SettingsScreenWidget> {
  SettingsViewModel _viewModel;

  @override
  void initState() {
    _viewModel = SettingsViewModel(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> categoryWidgets = _viewModel != null ?
      _viewModel.categories.map((category) => CategoryWidget(category, _viewModel)).toList()
      : [];

    return ListView(
      children: categoryWidgets
    );
  }
}


class CategoryWidget extends StatelessWidget {
  final Category category;
  final SettingsViewModel viewModel;

  CategoryWidget(this.category, this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(viewModel.getCategoryLabel(category)),
        ...category.settings.map((setting) => getSettingWidget(setting)),
      ],
    );
  }

  Widget getSettingWidget(Setting setting) {
    switch(setting.key) {
      case 'timezone':
        return Text(setting.key);
    }
    return Text(setting.key);
  }
}

