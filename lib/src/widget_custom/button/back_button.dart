import 'package:flutter/material.dart';

class BackButtonArrow extends StatelessWidget {
  final Function callback;

  const BackButtonArrow({Key key, @required this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 10),
        width: MediaQuery.of(context).size.height,
        alignment: Alignment.centerLeft,
        height: 50,
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
      ),
    );
  }
}
