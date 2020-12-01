import 'package:badges/badges.dart';
import 'package:iDietFit/shared/view/theme.dart';
import 'package:iDietFit/shared/view/utils/font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:iDietFit/user_data/model/entities/base.dart';
import 'package:iDietFit/user_data/model/entities/not_ephemeral_messages.dart';
import 'package:iDietFit/user_data/view/timeline/view_model.dart';

class TitledCardContainer extends StatelessWidget {
  final List<Widget> children;
  final String title;

  TitledCardContainer({this.children, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Text(title, style: TextStyle(color: Colors.grey))
            ),
            ...children,
            // Text('Sumario'),  // TODO
          ],
        ),
      ),
    );
  }
}

class InnerIconHourTextCardItem extends StatelessWidget {
  final bool lineToTop;
  final bool lineToBottom;
  final Widget icon;
  final String hourMinute;
  final String text;
  final ViewModelEntry entry;

  InnerIconHourTextCardItem({this.icon, this.text, this.hourMinute, this.lineToTop, this.lineToBottom, this.entry});
  
  Widget getLinesAndIconWidget(BuildContext context) {
    Color lineColor = DiaTheme.primaryColor;

    Widget line = FractionallySizedBox(
      heightFactor: 0.5,
      child: Container(decoration: BoxDecoration(color: lineColor), width: 2),
    );

    return Container(
      width: 60 * screenSizeScalingFactor(context),
      child: Stack(
        children: [
          if(lineToBottom)
            Align(alignment: Alignment.bottomCenter, child: line),
          if(lineToTop)
            Align(alignment: Alignment.topCenter, child: line),
          Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: lineColor,
              ),
              width: 50 * screenSizeScalingFactor(context),
              height: 50 * screenSizeScalingFactor(context),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  color: Color(0xFFFCFCFC),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]
              ),
              width: 45 * screenSizeScalingFactor(context),
              height: 45 * screenSizeScalingFactor(context),
              child: Center(child: icon),
            ),
          ),
        ],
      ),
    );
  }

  Widget getMinuteHourWidget(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 70 * screenSizeScalingFactor(context),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 8 * screenSizeScalingFactor(context), 0),
        child: Text(
            hourMinute,
            style: TextStyle(
              fontSize: smallSize(context),
              fontWeight: FontWeight.w300,
            )
        ),
      ),
    );
  }

  Widget getContentsRow(BuildContext context) {
    switch(entry.entity.entityType){
      case 'GlucoseLevel':
        return Row(
          children: [
            // Text(entry.text),
            Chip(
              padding: EdgeInsets.all(0),
              backgroundColor: Colors.red,
              label: Text(entry.glucoseLevel.level.toString() + 'mg/dL', style: TextStyle(color: Colors.white)),
            )
          ],
        );

      case 'Feeding':
        return Wrap(
          children: [
            Text(entry.text)
          ],
        );

      case 'Activity':
        return Wrap(
          children: [
            Text(entry.text)
          ],
        );

      case 'InsulinInjection':
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Chip(
            padding: EdgeInsets.all(0),
            backgroundColor: entry.insulinInjection.insulinType.getFlutterColor(),
            label: Text(entry.insulinInjection.units.toString() + 'u', style: TextStyle(color: Colors.white)),
          ),
          SizedBox(width: 10),
          Text(
            entry.insulinInjection.insulinType.name,
            style: TextStyle(fontSize: verySmallSize(context)),
          ),
        ],
      );

      case 'NotEphemeralMessage':
        return Wrap(
          children: [
            Text(entry.text)
          ],
        );

      case 'TraitMeasure':
        return Wrap(
          children: [
            Text(entry.text)
          ],
        );

      case 'Flag':
        return Wrap(
          children: [
            Text(entry.text)
          ],
        );

      default:
        return Row();
    }
  }

  Widget getContentsWidget(BuildContext context) {
    /*
      Text(
        text,
        style: TextStyle(
          fontSize: smallSize(context),
          letterSpacing: -0.5  // TODO pensar si lo dejamos.
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 5,
        softWrap: true,
      )
     */
    return Expanded(
      child: Container(
        child: getContentsRow(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70 * screenSizeScalingFactor(context),
      width: double.maxFinite,
      child: IntrinsicWidth(
        child: Row(
          children: [
            getLinesAndIconWidget(context),
            getMinuteHourWidget(context),
            getContentsWidget(context),
          ],
        ),
      ),
    );
  }
}

class InnerMessageCardItem extends StatelessWidget {
  final bool lineToTop;
  final bool lineToBottom;
  final NotEphemeralMessage message;

  InnerMessageCardItem({this.message, this.lineToTop, this.lineToBottom});

  Widget getLinesWidget(BuildContext context) {
    Icon leading;
    switch(message.type) {
      case NotEphemeralMessage.TYPE_INFORMATION:
        leading = Icon(Icons.info, color: Colors.grey, size: mediumSize(context));
        break;
      case NotEphemeralMessage.TYPE_WARNING:
        leading = Icon(Icons.warning, color: Colors.orange, size: mediumSize(context));
        break;
      case NotEphemeralMessage.TYPE_ERROR:
        leading = Icon(Icons.error, color: Colors.red, size: mediumSize(context));
        break;
    }

    Color lineColor = DiaTheme.primaryColor;

    Widget line = FractionallySizedBox(
      heightFactor: 0.5,
      child: Container(decoration: BoxDecoration(color: lineColor), width: 2),
    );

    return Container(
      width: 60 * screenSizeScalingFactor(context),
      child: Stack(
        children: [
          if(lineToBottom)
            Align(alignment: Alignment.bottomCenter, child: line),
          if(lineToTop)
            Align(alignment: Alignment.topCenter, child: line),
          Align(alignment: Alignment.center, child: Container(
            decoration: BoxDecoration(color: Colors.white),
            height: mediumSize(context) * 0.8,
            width: 2,
          )),
          Align(alignment: Alignment.center, child: leading),
        ],
      ),
    );
  }

  Widget getMessageWidget(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message.title,
                style: TextStyle(fontSize: smallSize(context), letterSpacing: -0.5, fontWeight: FontWeight.w800),
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                softWrap: true,
              ),
              SizedBox(height: 4,),
              Text(
                message.text,
                style: TextStyle(fontSize: verySmallSize(context)),
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: double.maxFinite,
        child: IntrinsicWidth(
          child: Row(
            children: [
              getLinesWidget(context),
              getMessageWidget(context),
            ],
          ),
        ),
      ),
    );
  }
}

