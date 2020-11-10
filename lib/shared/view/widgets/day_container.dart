import 'package:Dia/shared/view/theme.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.maxFinite,
      child: IntrinsicWidth(
        child: Row(
          children: [
            // lines and icon
            Container(
              width: 60,
              child: Stack(
                children: [
                  if(lineToBottom)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          color: DiaTheme.primaryColor,
                        ),
                        height: 35,
                        width: 2,
                      ),
                    ),
                  if(lineToTop)
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          color: DiaTheme.primaryColor,
                        ),
                        height: 35,
                        width: 2,
                      ),
                    ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                          //border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          //color: Color(0xFFFAFAFA),
                          color: DiaTheme.primaryColor,
                      ),
                      width: 50,
                      height: 50,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                          //border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          //color: Color(0xFFFAFAFA),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 5), // changes position of shadow
                            ),
                          ]
                      ),
                      width: 45,
                      height: 45,
                      child: Center(child: icon),
                    ),
                  ),
                ],
              ),
            ),
            // hour of the event
            Container(
              alignment: Alignment.center,
              width: 70,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Text(
                    hourMinute,
                    style: TextStyle(
                      fontSize: smallSize(context),
                      fontWeight: FontWeight.w300,
                    )
                ),
              ),
            ),
            // text
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: verySmallSize(context),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

