import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yen/models/comment_model.dart';
import 'package:yen/models/post_model.dart';
import 'package:yen/src/widget_custom/card/avater_profile.dart';
import 'package:yen/statics/list_satatic.dart';
import 'package:yen/statics/model_satatic.dart';

class CommentPage extends StatefulWidget {
  final PostModel post;
  final int index;

  const CommentPage({
    Key key,
    @required this.post,
    this.index,
  }) : super(key: key);
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  List<CommentModel> _commentList = List<CommentModel>();
  List<String> _commentList2 = List<String>();
  TextEditingController _controller = TextEditingController();
  // List<dynamic> _commentListDummy = List<dynamic>();
  String _date = "";

  @override
  void initState() {
    // log(widget.post.uid);
    // log(widget.post.id);
    getComment();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void getComment() async {
    for (var i = 0; i < widget.post.comment.length; i++) {
      _commentList2.add(widget.post.comment[i].toString());
      Map data = jsonDecode(widget.post.comment[i].toString());
      CommentModel comment = CommentModel.fromJson(data);
      _commentList.add(comment);
      setState(() {});
    }
  }

  void _comment(String comment) async {
    FirebaseFirestore _database = FirebaseFirestore.instance;
    var day = DateTime.now().day;
    var year = DateTime.now().year;
    var month = DateTime.now().month;
    // String month = _month(DateTime.now().month);
    _date = "$day/$month/$year";
    var commentModel = CommentModel(
      avaterUrl: ModelStatic.user.avatarUrl,
      image: "",
      name: ModelStatic.user.displayname,
      text: comment,
      timecomment: _date,
    );

    var commentStr =
        "{\"avaterUrl\": \"${ModelStatic.user.avatarUrl}\",\"image\": \"\",\"name\": \"${ModelStatic.user.displayname}\",\"text\": \"$comment\",\"timecomment\": \"$_date\"}";

    log(commentStr);
    _commentList2.add(commentStr);
    _commentList.add(commentModel);
    _controller.clear();
    FocusScope.of(context).requestFocus(new FocusNode());

    widget.post.comment = _commentList2;
    await _database
        .collection("Posts")
        .doc(widget.post.uid)
        .collection("detail")
        .doc(widget.post.id)
        .update({"comment": _commentList2}).then((value) {
      ListStatic.postList[widget.index] = widget.post;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double _cWidth = MediaQuery.of(context).size.width * 0.6;
    double _cWidth2 = MediaQuery.of(context).size.width * 0.7;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(bottom: 50),
                  child: Column(
                    children: [
                      // Card(
                      //   child: Container(
                      //     padding: EdgeInsets.all(10),
                      //     width: MediaQuery.of(context).size.width,
                      //     child: Row(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         AvaterProfile(
                      //           pathAvater: widget.post.avatarUrl,
                      //           size: 60,
                      //         ),
                      //         SizedBox(width: 5),
                      //         Container(
                      //           width: _cWidth2,
                      //           child: Column(
                      //             mainAxisAlignment: MainAxisAlignment.start,
                      //             children: [
                      //               SizedBox(height: 10),
                      //               Row(
                      //                 children: [
                      //                   Text(
                      //                     widget.post.displayname,
                      //                     style: TextStyle(
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.bold,
                      //                       fontSize: 16,
                      //                     ),
                      //                   ),
                      //                   SizedBox(width: 5),
                      //                   Text(
                      //                     widget.post.timePost,
                      //                     style: TextStyle(
                      //                       color: Colors.grey,
                      //                       fontWeight: FontWeight.bold,
                      //                       fontSize: 10,
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //               SizedBox(height: 20),
                      //               Container(
                      //                 width: _cWidth2,
                      //                 child: Text(
                      //                   widget.post.content,
                      //                   style: TextStyle(
                      //                       color: Colors.black, fontSize: 12),
                      //                   textAlign: TextAlign.left,
                      //                 ),
                      //               ),
                      //               SizedBox(height: 20),
                      //               InkWell(
                      //                 onTap: () {},
                      //                 child: Row(
                      //                   children: [
                      //                     Icon(
                      //                       Icons.thumb_up_outlined,
                      //                       color: Colors.grey,
                      //                       size: 20,
                      //                     ),
                      //                     SizedBox(width: 5),
                      //                     Text(
                      //                       'ถูกใจ ${widget.post.totalLike}',
                      //                       style: TextStyle(
                      //                         color: Colors.grey,
                      //                         fontSize: 12,
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.arrow_back_ios_outlined),
                                Text("กลับไปที่โพสต์"),
                              ],
                            )),
                      ),
                      SizedBox(height: 20),
                      _commentList.length == 0
                          ? _noComment()
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _commentList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _commentItem(
                                  context: context,
                                  cWidth: _cWidth,
                                  commentList: _commentList[index],
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: Colors.grey,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: 'เขียนความคิดเห็น',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.camera_alt_outlined),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              _comment(_controller.text);
                            },
                            child: Icon(Icons.send),
                          ),
                        ],
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

  Widget _noComment() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            color: Colors.grey,
            size: 100,
          ),
          Text(
            'ยังไม่มีความคิดเห็น',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'เป็นคนแรกที่แสดงความคิดเห็น',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Container _commentItem({
    BuildContext context,
    double cWidth,
    CommentModel commentList,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AvaterProfile(
                  pathAvater: commentList.avaterUrl,
                  size: 40,
                ),
                SizedBox(width: 5),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                commentList.name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                commentList.timecomment,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 8),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          Container(
                            width: cWidth,
                            child: Text(
                              commentList.text,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    // InkWell(
                    //   onTap: () {},
                    //   child: Row(
                    //     children: [
                    //       Icon(
                    //         Icons.thumb_up_outlined,
                    //         color: Colors.grey,
                    //         size: 20,
                    //       ),
                    //       SizedBox(width: 5),
                    //       Text(
                    //         'ถูกใจ',
                    //         style: TextStyle(
                    //           color: Colors.grey,
                    //           fontSize: 12,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
