import 'package:flutter/material.dart';

class Line extends StatelessWidget {
  final Color lineColor;
  final double width;
  final double height;

  const Line({
    Key key,
    this.lineColor,
    this.width,
    this.height = 2,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: lineColor == null ? Color(0xffE0E0E0) : lineColor,
    );
  }
}
