import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:toast/toast.dart';

import 'package:yen/models/post_model.dart';
import 'package:yen/src/page/navigation/navigation_page.dart';
import 'package:yen/src/widget_custom/button/non_corner_button.dart';
import 'package:yen/src/widget_custom/card/avater_profile.dart';
import 'package:yen/src/widget_custom/line/line.dart';
import 'package:yen/src/widget_custom/textfield/post_textfield.dart';
import 'package:yen/statics/model_satatic.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  List<dynamic> _commentList = List<dynamic>();
  List<dynamic> _linkList = List<dynamic>();
  TextEditingController _topic = TextEditingController();
  TextEditingController _content = TextEditingController();
  String _date = "";
  File _file;
  bool _loading = false;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void dispose() {
    _topic.dispose();
    _content.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _getDate();
    super.initState();
  }

  String _month(int m) {
    String month = "";
    switch (m) {
      case 01:
      case 1:
        month = "January";
        break;
      case 02:
      case 2:
        month = "February";
        break;
      case 03:
      case 3:
        month = "March";
        break;
      case 04:
      case 4:
        month = "April";
        break;
      case 05:
      case 5:
        month = "May";
        break;
      case 06:
      case 6:
        month = "June";
        break;
      case 07:
      case 7:
        month = "July";
        break;
      case 08:
      case 8:
        month = "August";
        break;
      case 09:
      case 9:
        month = "September";
        break;
      case 10:
        month = "October";
        break;
      case 11:
        month = "November";
        break;
      case 12:
        month = "December";
        break;
      default:
    }
    return month;
  }

  void _getDate() {
    var day = DateTime.now().day;
    var year = DateTime.now().year;
    String month = _month(DateTime.now().month);
    _date = "$month $day $year";
  }

  void _post() async {
    setState(() {
      _loading = true;
    });
    FirebaseFirestore _database = FirebaseFirestore.instance;
    var date = DateTime.now().millisecondsSinceEpoch;
    String avatarUrl = "";
    if (_file != null) {
      var now = DateTime.now().millisecondsSinceEpoch.toString();
      final StorageReference storageRef =
          FirebaseStorage.instance.ref().child(now);
      StorageUploadTask uploadTask = storageRef.putFile(
        File(_file.path),
        StorageMetadata(
          contentType: 'image/jpg',
        ),
      );
      StorageTaskSnapshot download = await uploadTask.onComplete;
      avatarUrl = await download.ref.getDownloadURL();
    }

    PostModel post = PostModel(
      avatarUrl: ModelStatic.user.avatarUrl,
      displayname: ModelStatic.user.displayname,
      topic: _topic.text,
      content: _content.text,
      timePost: _date,
      comment: _commentList,
      like: _linkList,
      imageUrl: avatarUrl,
      id: date.toString(),
      uid: ModelStatic.user.uid,
    );

    await _database
        .collection("Posts")
        .doc(ModelStatic.user.uid)
        .collection("detail")
        .doc("$date")
        .set(post.toJson())
        .then((value) {
      setState(() {
        _loading = false;
        Toast.show(
          "Saved",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NavigationPage(),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE2F2F6),
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: _loading,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _headerPost(),
                SizedBox(height: 50),
                PostTextField(
                  hint: 'Topic..',
                  maxLength: 120,
                  maxLines: 1,
                  controller: _topic,
                ),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Color(0xff007EC4),
                    borderRadius: new BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: new BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          maxLength: 1000,
                          maxLines: null,
                          controller: _content,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            hintText: 'content..',
                          ),
                        ),
                        _file != null
                            ? Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                margin: EdgeInsets.only(top: 10),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Image.file(
                                        _file,
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _file = null;
                                          });
                                        },
                                        child: Icon(Icons.close),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                // PostTextField(
                //   hint: 'content..',
                //   maxLength: 10000,
                //   maxLines: 10,
                //   controller: _content,
                // ),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: new BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: new BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                getImage();
                              },
                              child: Icon(
                                Icons.image,
                                size: 30,
                                color: Color(0xff009EF8),
                              ),
                            ),
                            Icon(
                              Icons.sentiment_satisfied,
                              size: 30,
                              color: Color(0xff009EF8),
                            ),
                          ],
                        ),
                      ),
                      NonCornerButton(
                        textButton: 'POST',
                        onTap: () {
                          _post();
                        },
                        borderRadius: 5,
                        padding: 0,
                        color: Color(0xff009EF8),
                        width: 70,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _headerPost() {
    return Container(
      margin: EdgeInsets.fromLTRB(40, 20, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AvaterProfile(
            pathAvater: ModelStatic.user.avatarUrl,
            size: 80,
          ),
          Column(
            children: [
              Text(
                'POST',
                style: TextStyle(
                    color: Color(0xff009EF8),
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Line(
                width: 120,
              )
            ],
          ),
          Expanded(
            child: Container(
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NavigationPage(),
                  ),
                ),
                child: Icon(
                  Icons.close,
                  size: 30,
                  color: Color(0xff009EF8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
