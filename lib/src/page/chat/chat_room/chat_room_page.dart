import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yen/models/user_model.dart';
import 'package:yen/statics/model_satatic.dart';

class ChatRoomPage extends StatefulWidget {
  final String keyRoom;
  final UserModel user;

  const ChatRoomPage({
    Key key,
    @required this.keyRoom,
    @required this.user,
  }) : super(key: key);
  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();
  List<ChatMessage> messages = List<ChatMessage>();
  var m = List<ChatMessage>();
  var i = 0;
  File _image;
  final picker = ImagePicker();

  final ChatUser user = ChatUser(
    name: ModelStatic.user.displayname,
    firstName: ModelStatic.user.firstname,
    lastName: ModelStatic.user.lastname,
    uid: ModelStatic.user.uid,
    avatar: ModelStatic.user.avatarUrl,
  );

  void onSend(ChatMessage message) async {
    FirebaseFirestore.instance
        .collection('Chat')
        .doc(widget.keyRoom)
        .set({"key": widget.keyRoom});

    var documentReference = FirebaseFirestore.instance
        .collection('Chat')
        .doc(widget.keyRoom)
        .collection('messages')
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        message.toJson(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.user.avatarUrl),
            ),
            SizedBox(width: 5),
            Text(widget.user.displayname),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Chat')
            .doc(widget.keyRoom)
            .collection('messages')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            );
          } else {
            List<DocumentSnapshot> items = snapshot.data.documents;
            var messages =
                items.map((i) => ChatMessage.fromJson(i.data())).toList();
            return DashChat(
              key: _chatViewKey,
              inverted: false,
              onSend: onSend,
              sendOnEnter: true,
              textInputAction: TextInputAction.send,
              user: user,
              inputDecoration: InputDecoration.collapsed(hintText: "ข้อความ"),
              dateFormat: DateFormat('yyyy-MMM-dd'),
              timeFormat: DateFormat('HH:mm'),
              messages: messages,
              showUserAvatar: false,
              showAvatarForEveryMessage: false,
              scrollToBottom: true,
              onLoadEarlier: () {
                print("loading...");
              },
              shouldShowLoadEarlier: false,
              showTraillingBeforeSend: true,
              trailing: <Widget>[
                IconButton(
                  icon: Icon(Icons.photo),
                  onPressed: () async {
                    final pickedFile =
                        await picker.getImage(source: ImageSource.gallery);

                    setState(() {
                      if (pickedFile != null) {
                        _image = File(pickedFile.path);
                      } else {
                        print('No image selected.');
                      }
                    });

                    if (_image != null) {
                      final StorageReference storageRef =
                          FirebaseStorage.instance.ref().child("chat_images");

                      StorageUploadTask uploadTask = storageRef.putFile(
                        _image,
                        StorageMetadata(
                          contentType: 'image/jpg',
                        ),
                      );
                      StorageTaskSnapshot download =
                          await uploadTask.onComplete;

                      String url = await download.ref.getDownloadURL();

                      ChatMessage message =
                          ChatMessage(text: "", user: user, image: url);

                      var documentReference = FirebaseFirestore.instance
                          .collection('Chat')
                          .doc(widget.keyRoom)
                          .collection('messages')
                          .doc(
                              DateTime.now().millisecondsSinceEpoch.toString());

                      FirebaseFirestore.instance
                          .runTransaction((transaction) async {
                        transaction.set(
                          documentReference,
                          message.toJson(),
                        );
                      });
                    }
                  },
                )
              ],
            );
          }
        },
      ),
    );
  }
}
