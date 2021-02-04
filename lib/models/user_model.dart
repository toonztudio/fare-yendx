import 'package:flutter/cupertino.dart';

class UserModel {
  String avatarUrl;
  String firstname;
  String lastname;
  String country;
  String yenDSections;
  String phone;
  String email;
  String business;
  String displayname;
  String uid;
  String notitoken;
  String address;
  String position;
  String website;
  List<dynamic> chatList;

  UserModel({
    @required this.avatarUrl,
    @required this.firstname,
    @required this.lastname,
    @required this.country,
    @required this.phone,
    @required this.yenDSections,
    @required this.email,
    @required this.business,
    @required this.displayname,
    @required this.uid,
    @required this.notitoken,
    @required this.address,
    @required this.position,
    @required this.website,
    this.chatList,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : avatarUrl = json['avatarUrl'],
        firstname = json['firstname'],
        lastname = json['lastname'],
        country = json['country'],
        yenDSections = json['yenDSections'],
        phone = json['phone'],
        email = json['email'],
        business = json['business'],
        displayname = json['displayname'],
        uid = json['uid'],
        notitoken = json['notitoken'],
        address = json['address'],
        position = json['position'],
        website = json['website'],
        chatList = json['chatList'];

  toJson() {
    return {
      "avatarUrl": avatarUrl,
      "firstname": firstname,
      "lastname": lastname,
      "country": country,
      "yenDSections": yenDSections,
      "phone": phone,
      "email": email,
      "business": business,
      "displayname": displayname,
      "uid": uid,
      "notitoken": notitoken,
      "address": address,
      "position": position,
      "website": website,
      "chatList": chatList,
    };
  }
}
