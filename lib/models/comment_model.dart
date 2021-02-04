import 'package:flutter/material.dart';

class CommentModel {
  String avaterUrl;
  String name;
  String text;
  String image;
  String timecomment;

  CommentModel({
    @required this.avaterUrl,
    @required this.name,
    @required this.text,
    @required this.image,
    @required this.timecomment,
  });

  // CommentModel.fromJson(Map<String, dynamic> json)
  // : avaterUrl = json['avaterUrl'],
  //   name = json['name'],
  //   text = json['text'],
  //   image = json['image'],
  //   timecomment = json['timecomment'];

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      avaterUrl: json['avaterUrl'],
      name: json['name'],
      text: json['text'],
      image: json['image'],
      timecomment: json['timecomment'],
    );
  }

  toJson() {
    return {
      "avaterUrl": avaterUrl,
      "name": name,
      "text": text,
      "image": image,
      "timecomment": timecomment,
    };
  }
}
