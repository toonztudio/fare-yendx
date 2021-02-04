import 'package:flutter/material.dart';

class MainTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final bool enabled;
  final int maxLength;
  final TextInputType keyboardType;
  final OutlineInputBorder disabledBorder;
  final Function onTap;

  const MainTextField({
    Key key,
    @required this.labelText,
    this.controller,
    this.obscureText = false,
    this.enabled = true,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.disabledBorder,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 160,
      height: 40,
      child: Center(
        child: TextField(
          textCapitalization: TextCapitalization.words,
          enabled: enabled,
          maxLength: maxLength,
          obscureText: obscureText,
          controller: controller,
          keyboardType: keyboardType,
          buildCounter: (BuildContext context,
                  {int currentLength, int maxLength, bool isFocused}) =>
              null,
          onTap: onTap,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: new BorderSide(
                color: Color(0xff6E8EC6),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: new BorderSide(
                color: Color(0xff6E8EC6),
              ),
            ),
            disabledBorder: disabledBorder,
            labelText: '$labelText',
            labelStyle:
                TextStyle(fontStyle: FontStyle.italic, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
