import 'package:flutter/material.dart';
import 'package:yen/models/user_model.dart';
import 'package:yen/src/widget_custom/button/back_button2.dart';
import 'package:yen/src/widget_custom/item_list/member_list_item.dart';
import 'package:yen/src/widget_custom/textfield/search_textfield.dart';
import 'package:yen/statics/list_satatic.dart';
import 'package:yen/statics/model_satatic.dart';

import 'member_detail_page.dart';

class MemberListPage extends StatefulWidget {
  final List<UserModel> userList;
  final int country;

  const MemberListPage({Key key, this.userList, this.country})
      : super(key: key);
  @override
  _MemberListPageState createState() => _MemberListPageState();
}

class _MemberListPageState extends State<MemberListPage> {
  List<UserModel> _userList = List<UserModel>();
  @override
  void initState() {
    _fillter(widget.country);
    super.initState();
  }

  void _fillter(int index) {
    for (var i = 0; i < widget.userList.length; i++) {
      if (widget.userList[i].uid != ModelStatic.user.uid) {
        if (widget.userList[i].country == ListStatic.countryList[index]) {
          _userList.add(widget.userList[i]);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffE1F2F5),
        body: Column(
          children: [
            _header(context),
            Expanded(
              child: ListView.builder(
                itemCount: _userList.length,
                itemBuilder: (context, index) {
                  return MemberListItem(
                    address1: '1234 YOUR LOCATION HERE',
                    address2: 'YOUR RD. YOUR STREET POSTAL 00000',
                    email: _userList[index].email,
                    imageUrl: _userList[index].avatarUrl,
                    name: _userList[index].displayname,
                    phone: _userList[index].phone,
                    position: 'position',
                    website: "WWW.COMPANYNANE.COM",
                    callback: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MemberDetailPage(
                            user: _userList[index],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _header(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        color: Color(0xffE1F2F5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            alignment: Alignment.center,
            child: Row(
              children: [
                BackButtonArrow2(
                  callback: () {
                    Navigator.pop(context);
                  },
                ),
                SearchTextField(),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Text(
              'Member',
              style: TextStyle(
                color: Color(0xff007EC4),
                fontSize: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
