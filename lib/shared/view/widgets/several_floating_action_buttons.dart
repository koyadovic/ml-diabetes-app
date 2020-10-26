import 'package:flutter/material.dart';

class SeveralFloatingActionButton extends StatefulWidget {
  final List<FloatingActionButton> floatingActionButtons;
  final Color color;

  SeveralFloatingActionButton({this.floatingActionButtons, this.color});

  @override
  _SeveralFloatingActionButtonState createState() => _SeveralFloatingActionButtonState();
}

class _SeveralFloatingActionButtonState extends State<SeveralFloatingActionButton> with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.ease;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300))
      ..addListener(() {
        setState(() {});
      });

    _animateIcon = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: widget.color,
      end: widget.color,  // TODO before was Colors.grey
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.ease,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
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
          //size: themeService.isPhone ? null : 35,
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    double lengthOfButtons = widget.floatingActionButtons.length.toDouble();
    for(int n=0; n<lengthOfButtons; n++) {
      FloatingActionButton button = widget.floatingActionButtons[n];
      widgets.add(
        Transform(
          transform: Matrix4.translationValues(
              0.0,
              _translateButton.value * (lengthOfButtons - n.toDouble()),
              0.0
          ),
          child: AnimatedOpacity(
            opacity: isOpened ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: Container(
              child: button,
            ),
          ),
        ),
      );
    }
    widgets.add(getToggleIconButton());

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: widgets,
    );
  }
}