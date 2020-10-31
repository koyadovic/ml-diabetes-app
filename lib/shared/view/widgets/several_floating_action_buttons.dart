import 'package:flutter/material.dart';


// ignore: must_be_immutable
class SeveralFloatingActionButton extends StatefulWidget{
  final List<FloatingActionButton> floatingActionButtons;
  final Color color;
  final Color backgroundColor;

  _SeveralFloatingActionButtonState state;

  SeveralFloatingActionButton({this.floatingActionButtons, this.color, this.backgroundColor});

  @override
  _SeveralFloatingActionButtonState createState() {
    state = _SeveralFloatingActionButtonState();
    return state;
  }
}

class _SeveralFloatingActionButtonState extends State<SeveralFloatingActionButton> with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.ease;
  double _fabHeight = 56.0;
  int animationMillis = 200;

  double _floatingActionButtonsLength = 0.0;

  @override
  initState() {
    widget.state = this;
    _floatingActionButtonsLength = widget.floatingActionButtons.length.toDouble();

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: animationMillis))
      ..addListener(() {
          setState(() {});
      });

    _animateIcon = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: widget.backgroundColor,
      end: widget.backgroundColor,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 1.0, curve: _curve),
    ));

    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 1.0, curve: _curve),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  toggle() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget getToggleIconButton() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: toggle,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
          color: widget.color,
        ),
      ),
    );
  }

  double n = 0.0;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = widget.floatingActionButtons.map((FloatingActionButton b) {
      Widget w = Transform(
        transform: Matrix4.translationValues(0.0, _translateButton.value * (_floatingActionButtonsLength - n), 0.0),
        child: AnimatedOpacity(
          opacity: isOpened ? 1.0 : 0.0,
          duration: Duration(milliseconds: animationMillis),
          child: b,
        ),
      );
      n += 1;
      return w;
    }).toList();
    widgets.add(getToggleIconButton());
    n = 0.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: widgets,
    );
  }
}