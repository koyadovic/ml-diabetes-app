import 'package:Dia/settings/model/entities.dart';
import 'package:Dia/settings/view/view_model.dart';
import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/shared/view/theme.dart';
import 'package:Dia/shared/view/utils/font_sizes.dart';
import 'package:Dia/shared/view/widgets/search_and_select.dart';
import 'package:Dia/user_data/model/entities/insulin.dart';
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
  List<InsulinType> insulinTypes = [];

  @override
  void initState() {
    _viewModel = SettingsViewModel(this);
    _viewModel.getInsulinTypes().then((types) => setState((){insulinTypes = types;}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> categoryWidgets = _viewModel != null ?
      _viewModel.categories.map((category) => CategoryWidget(category, _viewModel, insulinTypes)).toList()
      : [];

    return ListView(
      children: categoryWidgets
    );
  }
}


class CategoryWidget extends StatefulWidget {
  final Category category;
  final SettingsViewModel viewModel;
  List<InsulinType> insulinTypes = [];

  CategoryWidget(this.category, this.viewModel, this.insulinTypes);

  @override
  State<StatefulWidget> createState() {
    return CategoryWidgetState();
  }
}

class CategoryWidgetState extends State<CategoryWidget> {
  @override
  void initState() {
    super.initState();
  }

  InsulinType getFromSlug(String slug) {
    for(InsulinType type in widget.insulinTypes) {
      if(type.slug == slug) return type;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.viewModel.getCategoryLabel(widget.category),
            style: TextStyle(
              fontSize: smallSize(context),
              color: DiaTheme.primaryColor,
            )
          ),
          SizedBox(height: 1, child: Container(color: DiaTheme.primaryColor)),
          ...widget.category.settings.map(
            (setting) => Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.viewModel.getSettingLabel(setting),
                    style: TextStyle(
                      fontSize: verySmallSize(context),
                      color: Colors.black87,
                      decoration: TextDecoration.underline
                    )
                  ),
                  getSettingWidget(setting, context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*
  TODO hay que pillar todos los tipos de insulina para traducir el setting de insulina al slug y al guardar que se guarde el slug
   */



  Widget getSettingWidget(Setting setting, BuildContext context) {
    switch(setting.key) {
      case 'timezone':
        return SearchAndSelect<String>(
          currentValue: setting.value,
          delayMilliseconds: 200,
          source: LocalSource<String>(
            data: List<String>.from(setting.specification.options.map((option) => option['value']).toList()),
            matcher: (String item, String searchTerm) => item.toLowerCase().contains(searchTerm.toLowerCase()),
          ),
          onSelected: (String value) {
            if(value != null) {
              widget.viewModel.saveSetting(widget.category, setting, value).then((_) {
                setState(() {
                });
              });
            }
          },
          renderItem: (String value) => Text(value ?? 'Pulse para seleccionar', style: TextStyle(color: Colors.indigo)),
        );
      case 'insulin-type-1':
      case 'insulin-type-2':
      case 'insulin-type-3':
        return SearchAndSelect<InsulinType>(
          currentValue: getFromSlug(setting.value),
          delayMilliseconds: 300,
          source: APIRestSource<InsulinType>(
            endpoint: '/api/v1/insulin-types/',
            queryParameterName: 'search',
            deserializer: InsulinType.fromJson,
          ),
          onSelected: (InsulinType type) {
            widget.viewModel.saveSetting(widget.category, setting, type != null ? type.slug : '').then((_) {
              setState(() {
              });
            });
          },
          renderItem: (InsulinType value) => Text(value.toString() ?? 'Pulse para seleccionar', style: TextStyle(color: Colors.indigo)),
        );
      default:
        return DropdownButton<String>(
          isExpanded: true,
          itemHeight: 80,
          value: setting.value,
          onChanged: (String newValue) {
            if(newValue != null) {
              widget.viewModel.saveSetting(widget.category, setting, newValue).then((_) {
                setState(() {
                });
              });
            }
          },
          items: List<DropdownMenuItem<String>>.from(setting.specification.options.map((Map<String, dynamic> option) {
            return DropdownMenuItem<String>(
              value: option['value'],
              child: ListTile(
                title: Text(option['display'], style: TextStyle(fontSize: smallSize(context))),
                subtitle: Text('Blah'),
              ),
            );
          }).toList()),
        );
    }
  }
}

