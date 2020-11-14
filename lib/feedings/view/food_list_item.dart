import 'package:Dia/feedings/model/foods.dart';
import 'package:flutter/material.dart';

class FoodListTile extends StatelessWidget {

  final Food food;
  final String appendInTitle;
  final Function onEditRequest;

  FoodListTile({@required this.food, this.appendInTitle, this.onEditRequest});

  @override
  Widget build(BuildContext context) {
    String title = food.name;
    if(appendInTitle != null) {
      title += ' ' + appendInTitle;
    }
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          if(onEditRequest != null)
            onEditRequest();
        },
      ),
      title: Text(title),
      subtitle: getSubtitleInformationWidget(),
      trailing: getReliabilityIndicatorWidget(),
    );
  }

  Widget getSubtitleInformationWidget() {
    String kcalInfo = food.getKcal(100.0).round().toString();
    String carbsInfo = food.getDigestibleCarbs(100.0).round().toString();

    return Text('${kcalInfo}kcal - ${carbsInfo}g carbs' + ' para 100g');
  }

  Widget getReliabilityIndicatorWidget() {
    if(food.reliability == null) return null;
    Color color;
    if (food.reliability > 0.7)
      color = Colors.greenAccent;
    else if (food.reliability > 0.4)
      color = Colors.yellowAccent;
    else if (food.reliability > 0.1)
      color = Colors.redAccent;
    else
      color = Colors.grey;

    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(10))
      )
    );
  }
}