import 'package:flutter/material.dart';

class FlexibleContainer extends StatelessWidget {
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;
  final MainAxisSize mainAxisSize;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final List<Widget> children;
  final double maxScreenSize;

  const FlexibleContainer({
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.textBaseline,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.children = const <Widget>[],
    this.maxScreenSize = 728.00,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing = 0,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > maxScreenSize) {
      return Row(
        textDirection: textDirection,
        mainAxisSize: mainAxisSize,
        verticalDirection: verticalDirection,
        spacing: spacing,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      );
    } else {
      return Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        verticalDirection: verticalDirection,
        textDirection: textDirection,
        textBaseline: textBaseline,
        mainAxisSize: mainAxisSize,
        spacing: spacing,
        children: children,
      );
    }
  }
}
