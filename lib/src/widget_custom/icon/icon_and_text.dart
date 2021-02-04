import 'package:flutter/material.dart';

class IconAndText extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final double textSize;
  final MainAxisAlignment mainAxisAlignment;

  const IconAndText({
    Key key,
    this.icon,
    this.title,
    this.color,
    this.textSize = 12,
    this.mainAxisAlignment = MainAxisAlignment.center,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          Container(
            child: Icon(
              icon,
              size: 10,
              color: color == null ? Colors.white : Colors.black,
            ),
          ),
          Text(
            '$title',
            style: TextStyle(
                color: color == null ? Colors.white : Colors.black,
                fontSize: textSize),
          ),
        ],
      ),
    );
  }
}
