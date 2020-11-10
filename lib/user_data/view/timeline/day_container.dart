import 'package:Dia/shared/view/utils/font_sizes.dart';
import 'package:flutter/material.dart';

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

class InnerCardItem extends StatelessWidget {
  final bool lineToTop;
  final bool lineToBottom;
  final Widget icon;
  final String hourMinute;
  final String text;

  InnerCardItem({this.icon, this.text, this.hourMinute, this.lineToTop, this.lineToBottom});
  
  Widget getLinesAndIconWidget(BuildContext context) {
    Color lineColor = Colors.grey;

    Container line = Container(
      decoration: BoxDecoration(
        color: lineColor,
      ),
      height: 35 * screenSizeScalingFactor(context),
      width: 2,
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

  Widget getTextWidget(BuildContext context) {
    return Expanded(
      child: Container(
        child: Text(
          text,
          style: TextStyle(
            fontSize: verySmallSize(context, scale: false),
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.maxFinite,
      child: IntrinsicWidth(
        child: Row(
          children: [
            getLinesAndIconWidget(context),
            getMinuteHourWidget(context),
            getTextWidget(context),
          ],
        ),
      ),
    );
  }
}

