import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yen/models/user_model.dart';
import 'package:yen/src/page/login/login_page.dart';
import 'package:yen/src/page/navigation/navigation_page.dart';
import 'package:yen/src/page/profile/profile_page.dart';
import 'package:yen/statics/list_satatic.dart';
import 'package:yen/statics/model_satatic.dart';
import 'package:yen/statics/string_static.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  List<String> _uidList = List<String>();
  void _timer() {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  void _getData() async {
    FirebaseFirestore _database = FirebaseFirestore.instance;
    await _database
        .collection("Users")
        .doc(StringStatic.uid)
        .get()
        .then((value) {
      ModelStatic.user = UserModel.fromJson(value.data());
    }).then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NavigationPage()));
    });
  }

  void _getUserAll() async {
    FirebaseFirestore _database = FirebaseFirestore.instance;

    await _database.collection("Users").get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((value) {
        UserModel user = UserModel.fromJson(value.data());
        ListStatic.userAllList.add(user);
      });
    });
  }

  void _checkUser() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User user = _auth.currentUser;
    FirebaseFirestore _databaseReference = FirebaseFirestore.instance;
    if (user != null) {
      await _databaseReference
          .collection("Users")
          .get()
          .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((value) {
          _uidList.add(value.id);
        });
      }).then((value) {
        var uid = _uidList.where((element) => element == user.uid).toList();
        if (uid.length != 0) {
          StringStatic.uid = user.uid;
          // log("${user.uid}");
          _getData();
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => ProfilePage(user: user)));
        }
      });
    } else {
      _timer();
    }
  }

  @override
  void initState() {
    _getUserAll();
    _checkUser();
    _getPostUID();

    super.initState();
  }

  void _getPostUID() async {
    FirebaseFirestore _database = FirebaseFirestore.instance;
    await _database.collection("Users").get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((value) {
        // log("--------------------------------${value.id}");
        ListStatic.uidList.add(value.id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Image.asset(
          "assets/images/bg.png",
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
