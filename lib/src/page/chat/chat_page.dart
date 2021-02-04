import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yen/models/user_model.dart';
import 'package:yen/src/page/chat/chat_room/chat_room_page.dart';
import 'package:yen/src/widget_custom/card/avater_profile.dart';
import 'package:yen/src/widget_custom/textfield/search_textfield.dart';
import 'package:yen/statics/model_satatic.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  FirebaseFirestore _database = FirebaseFirestore.instance;
  List<UserModel> _chatList = List<UserModel>();
  List<String> _keyList = List<String>();

  @override
  void initState() {
    _getPostUID();
    super.initState();
  }

  void _getPostUID() async {
    List<String> keyList = List<String>();
    List<String> keyList2 = List<String>();
    _chatList.clear();
    await _database.collection("Chat").get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((value) {
        keyList.add(value.id);
      });
    }).then((value) {
      keyList2 = keyList
          .where((element) => element.contains(ModelStatic.user.uid))
          .toList();
      if (keyList2.length != 0) {
        for (var i = 0; i < keyList2.length; i++) {
          var strSplit = keyList2[i].split("_");

          for (var j = 0; j < strSplit.length; j++) {
            // log(strSplit[j]);
            if (strSplit[j] != ModelStatic.user.uid) {
              UserModel user;
              _database
                  .collection("Users")
                  .doc(strSplit[j])
                  .get()
                  .then((value) {
                user = UserModel.fromJson(value.data());
              }).then((value) {
                _keyList.add(keyList2[i]);
                log(keyList2[i]);
                _chatList.add(user);
                setState(() {});
              });
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                _headerContainer(context),
                Expanded(
                  child: ListView.builder(
                    itemCount: _chatList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 80,
                        child: InkWell(
                          onTap: () {
                            String key = _keyList[index];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (contaxt) => ChatRoomPage(
                                  keyRoom: key,
                                  user: _chatList[index],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 5,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                AvaterProfile(
                                  pathAvater: _chatList[index].avatarUrl,
                                  size: 60,
                                  maginRight: 10,
                                ),
                                Text(
                                  _chatList[index].displayname,
                                  style: TextStyle(
                                      color: Colors.grey[800], fontSize: 20),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _headerContainer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      decoration: BoxDecoration(
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
      child: Container(
        padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
        child: Column(
          children: [
            Row(
              children: [
                AvaterProfile(
                  pathAvater: ModelStatic.user.avatarUrl,
                  size: 70,
                  maginRight: 10,
                ),
                Text(
                  "Chat",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            SearchTextField(),
          ],
        ),
      ),
    );
  }
}
