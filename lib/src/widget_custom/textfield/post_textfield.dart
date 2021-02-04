import 'package:flutter/material.dart';

class PostTextField extends StatelessWidget {
  final String hint;
  final int maxLength;
  final int maxLines;
  final TextEditingController controller;

  const PostTextField({
    Key key,
    this.hint,
    this.maxLength,
    this.maxLines,
    this.controller,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        maxLength: maxLength,
        maxLines: maxLines,
        controller: controller,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: new BorderSide(color: Color(0xff6E8EC6), width: 0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: new BorderSide(color: Color(0xff6E8EC6), width: 0),
            ),
            hintText: '$hint',
            hintStyle: TextStyle(fontStyle: FontStyle.italic)),
      ),
    );
  }
}
