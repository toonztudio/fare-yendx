import 'package:flutter/material.dart';
import 'package:yen/src/widget_custom/card/avater_profile.dart';
import 'package:yen/src/widget_custom/icon/icon_and_text.dart';

class MemberListItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String position;
  final String phone;
  final String email;
  final String website;
  final String address1;
  final String address2;
  final Function callback;

  const MemberListItem(
      {Key key,
      @required this.imageUrl,
      @required this.name,
      @required this.position,
      @required this.phone,
      @required this.email,
      @required this.website,
      this.address1,
      this.address2,
      @required this.callback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: AvaterProfile(
              pathAvater: imageUrl,
              size: 80,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  position,
                  style: TextStyle(fontSize: 16),
                ),
                IconAndText(
                  icon: Icons.phone,
                  title: phone,
                  color: Colors.black,
                ),
                IconAndText(
                  icon: Icons.mail,
                  title: email,
                  color: Colors.black,
                ),
                IconAndText(
                  icon: Icons.language,
                  title: website,
                  color: Colors.black,
                ),
                SizedBox(height: 5),
                Text(
                  address1,
                  style: TextStyle(color: Colors.black, fontSize: 8),
                ),
                Text(
                  address2,
                  style: TextStyle(color: Colors.black, fontSize: 8),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          InkWell(
            onTap: callback,
            child: Container(
              height: 140,
              margin: EdgeInsets.all(10),
              alignment: Alignment.bottomRight,
              child: Icon(Icons.arrow_forward_ios),
            ),
          )
        ],
      ),
    );
  }
}
