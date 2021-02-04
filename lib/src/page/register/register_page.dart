import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:toast/toast.dart';
import 'package:yen/src/page/login/login_page.dart';
import 'package:yen/src/page/navigation/navigation_page.dart';
import 'package:yen/src/page/profile/profile_page.dart';
import 'package:yen/src/widget_custom/button/back_button.dart';
import 'package:yen/src/widget_custom/button/non_corner_button.dart';
import 'package:yen/src/widget_custom/textfield/main_textfield.dart';
import 'package:yen/statics/list_satatic.dart';
import 'package:yen/statics/string_static.dart';

class RegisterPage extends StatefulWidget {
  final int type;

  const RegisterPage({Key key, this.type}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore database = FirebaseFirestore.instance;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  List<String> _allowedEmailList = List<String>();
  List<String> _uidList = List<String>();
  // List<String> _idList = List<String>();
  bool _loading = false;

  @override
  void initState() {
    _getID();
    _getIDUser();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _getID() async {
    await database
        .collection("allowed_emails")
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((value) {
        String email = value.data()['email'];
        _allowedEmailList.add(email);
      });
    }).then((value) {});
  }

  void _getIDUser() async {
    await database.collection("Users").get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((value) {
        _uidList.add(value.id);
        log(value.id);
      });
    });
  }

  // void _getMail(String id) async {
  //   await database.collection("allowed_emails").doc(id).get().then((value) {
  //     log(email);
  //     _allowedEmailList.add(email);
  //   });
  // }

  void _checkField({@required String email, @required String password}) {
    email.toLowerCase();
    password.toLowerCase();
    FocusScope.of(context).requestFocus(FocusNode());
    if (email == "" || password == "") {
      Toast.show("E-mail and Password cannot be empty", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
    if (password.length < 6) {
      Toast.show(
        "Password must be more then 6 characters",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
      );
    } else {
      setState(() {
        _loading = true;
      });
      if (widget.type == 1) {
        _login(email: email, password: password);
      } else {
        var usedList = ListStatic.userAllList
            .where((element) => element.email == email)
            .toList();

        if (usedList.length == 1) {
          Toast.show(
            "This email is already a member.",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
          );
          setState(() {
            _loading = false;
          });
        } else {
          _createUser(email: email, password: password);
        }
      }
    }
  }

  void _createUser({@required String email, @required String password}) async {
    var allowedlist =
        _allowedEmailList.where((element) => element == email).toList();

    if (allowedlist.length == 0) {
      Toast.show(
        "This email is not allowed or you are not YenDx member",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
      );
      setState(() {
        _loading = false;
      });
    } else {
      try {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .whenComplete(
          () {
            Toast.show(
              "Successfully registered",
              context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM,
            );
          },
        );

        if (userCredential.user != null) {
          setState(() {
            _loading = false;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(
                user: userCredential.user,
              ),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          Toast.show(
            "The password provided is too weak.",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
          );
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          Toast.show(
            "The account already exists for that email.",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
          );
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void _login({@required String email, @required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // log("userCredential");
      if (userCredential.user != null) {
        setState(() {
          _loading = false;
        });
        var check = _uidList
            .where((element) => element == userCredential.user.uid)
            .toList();
        if (check.length == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(
                user: userCredential.user,
              ),
            ),
          );
        } else {
          StringStatic.uid = userCredential.user.uid;
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => NavigationPage()));
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: _loading,
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg_main.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  BackButtonArrow(
                    callback: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 5.5,
                    ),
                    child: Stack(
                      children: [
                        Image.asset(
                          "assets/images/frame.png",
                          width: MediaQuery.of(context).size.width - 80,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 100),
                          width: MediaQuery.of(context).size.width - 80,
                          child: Column(
                            children: [
                              MainTextField(
                                labelText: 'E-mail',
                                controller: _email,
                              ),
                              SizedBox(height: 10),
                              MainTextField(
                                labelText: 'Password',
                                controller: _password,
                                obscureText: true,
                              ),
                              SizedBox(height: 40),
                              NonCornerButton(
                                textButton:
                                    widget.type == 1 ? "SIGN IN" : "SIGN UP",
                                textColor: Color(0xff676767),
                                borderRadius: 10,
                                padding: 0,
                                color: Color(0xffE6F5FC),
                                width: MediaQuery.of(context).size.width / 2,
                                onTap: () {
                                  _checkField(
                                    email: _email.text,
                                    password: _password.text,
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("Already have an account?")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
