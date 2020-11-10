import 'package:Dia/shared/view/utils/font_sizes.dart';
import 'package:easy_localization/easy_localization.dart';
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
                    //Shadow(color: Colors.black26, blurRadius: 3, offset: Offset(3, 3))
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
      elevation: 2,
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


class InnerCardItem2 extends StatelessWidget {
  final bool lineToTop;
  final bool lineToBottom;
  final Icon icon;
  final DateTime eventDate;
  final String text;

  InnerCardItem2({this.icon, this.text, this.eventDate, this.lineToTop, this.lineToBottom});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        children: [
          // lines and icon
          Container(
            width: 80,
            child: Stack(
              children: [
                if(lineToBottom)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.grey,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ]
                    ),
                    height: 50,
                    width: 2,
                  ),
                ),
                if(lineToTop)
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.grey,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ]
                    ),
                    height: 50,
                    width: 2,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Color(0xFFFAFAFA),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]
                    ),
                    width: 50,
                    height: 50,
                    child: icon,
                  ),
                ),
              ],
            ),
          ),
          // hour of the event
          Container(
            width: 80,
            child: Column(
              children: [
                Text(DateFormat.Hm().format(eventDate)),
              ],
            ),
          ),
          // text
          Container(
            width: double.maxFinite,
            child: Column(
              children: [
                Text(text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

