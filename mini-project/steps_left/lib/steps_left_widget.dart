import 'package:flutter/material.dart';
import 'package:steps_left/steps_left.dart';

class StepsLeftBar extends StatefulWidget {
  StepsLeftBar({
    Key key,
    @required this.children,
    this.onTap,
    this.orientation,
    this.activeStep,
    this.labelColor = const Color(0xff1B2334),
    this.activeCircleColor = const Color(0xff1B2334),
    this.inactiveCircleColor = const Color(0xffF3F3FB),
    this.activeLineColor = const Color(0xff1B2334),
    this.inactiveLineColor = const Color(0xffA4ACC8),
  })  : assert(children.isNotEmpty || children != null,
            "List of items is either empty or undefined"),
        assert(activeStep <= children.length && activeStep >= 0,
            "Active step must be between 0-${children.length}"),
        super(key: key);

  final List<StepsLeftItem> children;
  final VoidCallback onTap;
  final String orientation;
  final int activeStep;
  final Color labelColor;
  final Color activeCircleColor;
  final Color inactiveCircleColor;
  final Color activeLineColor;
  final Color inactiveLineColor;

  @override
  _StepsLeftBarState createState() => _StepsLeftBarState();
}

class _StepsLeftBarState extends State<StepsLeftBar> {
  int activeStep;

  @override
  void initState() {
    super.initState();

    activeStep = widget.activeStep;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
            children: List.generate(widget.children.length * 2 - 1, (index) {
          int itemIndex = index ~/ 2; //Indices only for items
          bool isActive = activeStep == itemIndex;
          bool isDone = activeStep > itemIndex;
          // Workaround: Create a new copy with the index numbers. Maybe not so efficient..
          StepsLeftItem item = StepsLeftItem(
            stepNr: itemIndex,
            isActive: isActive,
            isDone: isDone,
            labelColor: widget.labelColor,
            icon: widget.children[itemIndex].icon,
            label: widget.children[itemIndex].label,
            activeColor: widget.activeCircleColor,
            inactiveColor: widget.inactiveCircleColor,
            activeBorderColor: widget.activeCircleColor,
            inactiveBorderColor: widget.inactiveLineColor,
          );

          if (index % 2 == 1)
            return Flexible(
              child: Container(
                color:
                    isDone ? widget.activeLineColor : widget.inactiveLineColor,
                height: 4.0,
              ),
            );
          return item;
        })),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
            widget.children.length,
            (index) => Container(
                  width: 80,
                  child: Text(
                    widget.children[index].label ?? '',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: widget.labelColor),
                  ),
                )),
      )
    ]);
  }
}
