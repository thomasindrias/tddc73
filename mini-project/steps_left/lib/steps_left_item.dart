import 'package:flutter/material.dart';

class StepsLeftItem extends StatefulWidget {
  StepsLeftItem({
    Key key,
    @required this.label,
    this.icon,
    this.stepNr,
    this.isDone = false,
    this.isActive = false,
    this.labelColor = const Color(0xff1B2334),
    this.activeColor = const Color(0xff1B2334),
    this.inactiveColor = const Color(0xffF3F3FB),
    this.activeBorderColor = const Color(0xff1B2334),
    this.inactiveBorderColor = const Color(0xffF3F3FB),
  }) : super(key: key);

  final Icon icon;
  final int stepNr;
  final bool isDone;
  final String label;
  final bool isActive;
  final Color labelColor;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeBorderColor;
  final Color inactiveBorderColor;

  _StepsLeftItemState createState() => _StepsLeftItemState();
}

class _StepsLeftItemState extends State<StepsLeftItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 40,
        height: 40,
        child: Center(
            child: widget.icon ??
                Text(
                  widget.stepNr.toString(),
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: widget.isDone
                          ? widget.inactiveColor
                          : widget.activeColor),
                )),
        decoration: BoxDecoration(
          color: !widget.isDone ? Colors.transparent : widget.activeColor,
          shape: BoxShape.circle,
          border: Border.all(
            width: 3,
            color: !widget.isActive && !widget.isDone
                ? widget.inactiveBorderColor
                : widget.activeBorderColor,
          ),
        ),
      ),
    );
  }
}
