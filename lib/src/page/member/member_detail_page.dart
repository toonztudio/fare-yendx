import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yen/models/user_model.dart';
import 'package:yen/src/page/chat/chat_room/chat_room_page.dart';
import 'package:yen/src/widget_custom/button/back_button.dart';
import 'package:yen/src/widget_custom/card/avater_profile.dart';
import 'package:yen/src/widget_custom/icon/icon_and_text.dart';
import 'package:yen/statics/model_satatic.dart';

class MemberDetailPage extends StatefulWidget {
  final UserModel user;

  const MemberDetailPage({Key key, this.user}) : super(key: key);

  @override
  _MemberDetailPageState createState() => _MemberDetailPageState();
}

class _MemberDetailPageState extends State<MemberDetailPage> {
  // List<dynamic> _list = List<dynamic>();
  @override
  void initState() {
    _update();
    super.initState();
  }

  _test(String uid) async {
    var keyRoom = [
      ModelStatic.user.uid,
      uid,
    ];
    keyRoom.sort((a, b) => a.compareTo(b));
    String key = "${keyRoom[0]}_${keyRoom[1]}";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (contaxt) => ChatRoomPage(
          keyRoom: key,
          user: widget.user,
        ),
      ),
    );

    // await database
    //     .collection("Chat")
    //     .doc("${ModelStatic.user.uid}+$uid")
    //     .set({"test": "123456"});
  }

  void _update() async {
    Stream collectionStream =
        FirebaseFirestore.instance.collection('Chat').snapshots();
    collectionStream.forEach((element) {
      log(element);
    });

    FirebaseFirestore database = FirebaseFirestore.instance;
    await database.collection("Chat").get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((value) {
        log(value.id);
      });
    });

    // _list = ModelStatic.user.chatList;

    // var keyRoom = [
    //   ModelStatic.user.uid,
    //   uid,
    // ];
    // keyRoom.sort((a, b) => a.compareTo(b));
    // String key = "${keyRoom[0]}_${keyRoom[1]}";
    // var chat = _list.where((element) => element == uid).toList();
    // log(chat.length.toString());
    // if (chat.length == 0) {
    //   _list.add(uid);
    //   await database
    //       .collection("Users")
    //       .doc(ModelStatic.user.uid)
    //       .update({"chatList": _list}).then((value) {
    //     ModelStatic.user.chatList = _list;
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (contaxt) => ChatRoomPage(
    //           keyRoom: key,
    //           user: widget.user,
    //         ),
    //       ),
    //     );
    //   });
    // } else {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (contaxt) => ChatRoomPage(
    //         keyRoom: key,
    //         user: widget.user,
    //       ),
    //     ),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.20,
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(80)),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff0068B4),
                      Color(0xff00B3ED),
                    ],
                    stops: [0.1, 1],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: BackButtonArrow(callback: () {
                  Navigator.pop(context);
                }),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(
                    0, MediaQuery.of(context).size.height * 0.10, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                      child: AvaterProfile(
                        pathAvater: widget.user.avatarUrl,
                        size: 120,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                      child: Text(
                        widget.user.firstname,
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                      child: Text(
                        widget.user.lastname,
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color(0xffE2F2F6),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 80,
                            child: Text(
                              'position',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 80,
                            child: IconAndText(
                              mainAxisAlignment: MainAxisAlignment.start,
                              icon: Icons.phone,
                              title: widget.user.phone,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 80,
                            child: IconAndText(
                              mainAxisAlignment: MainAxisAlignment.start,
                              icon: Icons.mail,
                              title: widget.user.email,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 80,
                            child: IconAndText(
                              mainAxisAlignment: MainAxisAlignment.start,
                              icon: Icons.language,
                              title: 'WWW.COMPANYNANE.COM',
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 80,
                            alignment: Alignment.centerRight,
                            child: Text(
                              '1234 YOUR LOCATION HERE',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 80,
                            alignment: Alignment.centerRight,
                            child: Text(
                              'YOUR RD. YOUR STREET POSTAL 00000',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Icon(
                        Icons.chat,
                        color: Color(0xff007EC4),
                        size: 50,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () {
                          _test(widget.user.uid);
                          // _update(widget.user.uid);
                        },
                        child: Container(
                          width: 100,
                          height: 40,
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color(0xff007EC4),
                          ),
                          child: Container(
                            width: 100,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Color(0xffffffff),
                            ),
                            child: Text(
                              'Chat',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Color(0xff007EC4)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
