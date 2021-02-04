import 'package:flutter/material.dart';

class PostModel {
  String avatarUrl;
  String displayname;
  String topic;
  String content;
  String timePost;
  List<dynamic> comment;
  List<dynamic> like;
  String imageUrl;
  String id;
  String uid;

  PostModel({
    @required this.avatarUrl,
    @required this.displayname,
    this.topic,
    this.content,
    @required this.timePost,
    @required this.comment,
    @required this.like,
    this.imageUrl,
    this.id,
    this.uid,
  });

  PostModel.fromJson(Map<String, dynamic> json)
      : avatarUrl = json['avatarUrl'],
        displayname = json['displayname'],
        topic = json['topic'],
        content = json['content'],
        timePost = json['timePost'],
        comment = json['comment'],
        like = json['like'],
        imageUrl = json['imageUrl'],
        id = json['id'],
        uid = json['uid'];

  toJson() {
    return {
      "avatarUrl": avatarUrl,
      "displayname": displayname,
      "topic": topic,
      "content": content,
      "timePost": timePost,
      "comment": comment,
      "like": like,
      "imageUrl": imageUrl,
      "id": id,
      "uid": uid,
    };
  }
}
