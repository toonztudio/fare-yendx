import 'package:flutter/material.dart';

class BackButtonArrow2 extends StatelessWidget {
  final Function callback;

  const BackButtonArrow2({Key key, @required this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 10),
        width: 50,
        alignment: Alignment.centerLeft,
        height: 80,
        child: Icon(
          Icons.arrow_back_ios,
          color: Color(0xff007EC4),
        ),
      ),
    );
  }
}
