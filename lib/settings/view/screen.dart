import 'package:iDietFit/settings/controller/services.dart';
import 'package:iDietFit/settings/model/entities.dart';
import 'package:iDietFit/settings/view/view_model.dart';
import 'package:iDietFit/shared/view/error_handlers.dart';
import 'package:iDietFit/shared/view/screen_widget.dart';
import 'package:iDietFit/shared/view/theme.dart';
import 'package:iDietFit/shared/view/utils/font_sizes.dart';
import 'package:iDietFit/shared/view/widgets/dia_fa_icons.dart';
import 'package:iDietFit/shared/view/widgets/search_and_select.dart';
import 'package:iDietFit/user_data/model/entities/insulin.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

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
    return 'Settings'.tr();
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
  final SettingsServices settingsServices = SettingsServices();

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

    bool loading = _viewModel == null || categoryWidgets.length == 0 || insulinTypes.length == 0;
    if(loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView(
      children: [
        ...categoryWidgets
      ]
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
  SettingsServices settingsServices = SettingsServices();
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
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.viewModel.getCategoryLabel(widget.category),
            style: TextStyle(
              fontSize: mediumSize(context),
              color: DiaTheme.primaryColor,
            )
          ),
          SizedBox(height: 2, child: Container(color: DiaTheme.primaryColor)),
          ...widget.category.settings.map(
            (setting) => Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.viewModel.getSettingLabel(setting),
                    style: TextStyle(
                      fontSize: smallSize(context),
                      color: DiaTheme.primaryColor,
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

  void unFocus(BuildContext c) {
    FocusScope.of(c).requestFocus(new FocusNode());
  }

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
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                setState(() {
                });
              });
            }
          },
          renderItem: (SearchAndSelectState state, String value) => ListTile(
            leading: Icon(Icons.location_on),
            title: Text(value, style: TextStyle(fontSize: smallSize(context))),
          ),
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
            errorHandler: (err) {
              withBackendErrorHandlersOnView(() {
                throw err;
              });
            }
          ),
          onSelected: (InsulinType type) {
            widget.viewModel.saveSetting(widget.category, setting, type != null ? type.slug : '').then((_) {
              unFocus(context);
              setState(() {
              });
            });
          },
          renderItem: (SearchAndSelectState state, InsulinType value) => ListTile(
            leading: InsulinInjectionIconSmall(),
            title: Text(value.name, style: TextStyle(fontSize: smallSize(context))),
            subtitle: Text(value.categories.join(', ').toString(), style: TextStyle(fontSize: verySmallSize(context))),
          ),
        );
      default:
        return DropdownButton<String>(
          isExpanded: true,
          itemHeight: 80,
          value: setting.value ?? '',
          onChanged: (String newValue) {
            if(newValue != null) {
              widget.viewModel.saveSetting(widget.category, setting, newValue).then((_) {
                unFocus(context);
                setState(() {
                });
              });
            }
          },
          items: List<DropdownMenuItem<String>>.from(setting.specification.options.map((Map<String, dynamic> option) {
            return DropdownMenuItem<String>(
              value: option['value'],
              child: ListTile(
                title: Text('setting_title_${option["display"]}'.tr(), style: TextStyle(fontSize: smallSize(context))),
                subtitle: Text('setting_subtitle_${option["display"]}'.tr(), style: TextStyle(fontSize: verySmallSize(context))),
              ),
            );
          }).toList()),
        );
    }
  }
}

