import 'package:Dia/shared/view/utils/font_sizes.dart';
import 'package:flutter/material.dart';

class TitledCardContainer extends StatelessWidget {
  final List<Widget> children;
  final String title;

  TitledCardContainer({this.children, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey,
                  shadows: [
                    Shadow(color: Colors.black26, blurRadius: 3, offset: Offset(3, 3))
                  ]
                )
              ),
            ],
          ),
        ),
        Container(
          width: double.maxFinite,
          child: Card(
            child: Column(
              children: children,
            ),
          ),
        )
      ],
    );
  }
}

class InnerCardItem extends StatelessWidget {
  final Color color;
  final String title;
  final Widget child;

  InnerCardItem({this.title, this.color, this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: Colors.white,
      shape: Border(
        left: BorderSide(
          width: 6,
          color: color,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.maxFinite,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: mediumSize(context), color: color)),
                SizedBox(height: 10),
                child,
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      )
    );
  }
}

