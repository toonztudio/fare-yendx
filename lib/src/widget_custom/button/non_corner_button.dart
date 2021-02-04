import 'package:flutter/material.dart';

class NonCornerButton extends StatelessWidget {
  final String textButton;
  final Color color;
  final Color textColor;
  final double textSize;
  final double padding;
  final double width;
  final double height;
  final double borderRadius;
  final Function onTap;

  const NonCornerButton({
    Key key,
    @required this.textButton,
    this.color,
    this.textColor,
    this.padding = 2,
    this.width,
    this.height = 40,
    this.borderRadius = 40,
    @required this.onTap,
    this.textSize = 14,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width == null ? MediaQuery.of(context).size.width / 1.5 : width,
        height: height,
        padding: EdgeInsets.all(padding),
        decoration: new BoxDecoration(
          color: Color(0xffCBCBCA),
          borderRadius: new BorderRadius.all(Radius.circular(borderRadius)),
        ),
        child: Container(
          decoration: new BoxDecoration(
            color: color == null ? Color(0xff2F72AC) : color,
            borderRadius: new BorderRadius.all(Radius.circular(borderRadius)),
          ),
          child: Center(
            child: Text(
              textButton,
              style: TextStyle(
                color: textColor == null ? Colors.white : textColor,
                fontWeight: FontWeight.bold,
                fontSize: textSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
