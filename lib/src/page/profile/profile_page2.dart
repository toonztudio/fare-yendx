import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:toast/toast.dart';
import 'package:yen/models/user_model.dart';
import 'package:yen/src/widget_custom/button/non_corner_button.dart';
import 'package:yen/src/widget_custom/card/avater_profile.dart';
import 'package:yen/src/widget_custom/line/line.dart';
import 'package:yen/src/widget_custom/textfield/main_textfield.dart';
import 'package:yen/statics/list_satatic.dart';
import 'package:yen/statics/model_satatic.dart';

class ProfilePage2 extends StatefulWidget {
  @override
  _ProfilePage2State createState() => _ProfilePage2State();
}

class _ProfilePage2State extends State<ProfilePage2> {
  TextEditingController _firstname = TextEditingController();
  TextEditingController _lastname = TextEditingController();
  TextEditingController _country = TextEditingController();
  TextEditingController _yen = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _business = TextEditingController();
  bool edit = false;
  final picker = ImagePicker();
  File _image;
  FirebaseFirestore _database = FirebaseFirestore.instance;
  bool _loading = false;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void update() async {
    setState(() {
      _loading = true;
    });
    String avatarUrl = "";
    if (_image != null) {
      var now = DateTime.now().millisecondsSinceEpoch.toString();
      final StorageReference storageRef =
          FirebaseStorage.instance.ref().child(now);
      StorageUploadTask uploadTask = storageRef.putFile(
        File(_image.path),
        StorageMetadata(
          contentType: 'image/jpg',
        ),
      );
      StorageTaskSnapshot download = await uploadTask.onComplete;
      avatarUrl = await download.ref.getDownloadURL();
    } else {
      avatarUrl = ModelStatic.user.avatarUrl;
    }

    ModelStatic.user = UserModel(
      avatarUrl: avatarUrl,
      firstname: _firstname.text,
      lastname: _lastname.text,
      country: _country.text,
      phone: _phone.text,
      yenDSections: _yen.text,
      email: _email.text,
      business: _business.text,
      displayname: "${_firstname.text} ${_lastname.text}",
      uid: ModelStatic.user.uid,
      notitoken: "token",
      address: "",
      position: "",
      website: "",
    );
    await _database
        .collection("Users")
        .doc(ModelStatic.user.uid)
        .set(ModelStatic.user.toJson())
        .then((value) {
      Toast.show("บันทึกสำเร็จ", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      setState(() {
        _loading = false;
        edit = false;
      });
    });
  }

  @override
  void initState() {
    _email.text = ModelStatic.user.email;
    _firstname.text = ModelStatic.user.firstname;
    _lastname.text = ModelStatic.user.lastname;
    _country.text = ModelStatic.user.country;
    _yen.text = ModelStatic.user.yenDSections;
    _phone.text = ModelStatic.user.phone;
    _business.text = ModelStatic.user.business;
    super.initState();
  }

  @override
  void dispose() {
    _firstname.dispose();
    _lastname.dispose();
    _country.dispose();
    _yen.dispose();
    _phone.dispose();
    _email.dispose();
    _business.dispose();
    super.dispose();
  }

  void _selectCountry() {
    SelectDialog.showModal<String>(
      context,
      label: "Country",
      selectedValue: _country.text,
      items: ListStatic.countryList,
      onChange: (String selected) {
        setState(() {
          _country.text = selected;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: _loading,
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg_profile.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    width: MediaQuery.of(context).size.width - 60,
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Image.asset(
                            "assets/images/frame2.png",
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              InkWell(
                                onTap: edit
                                    ? () {
                                        getImage();
                                      }
                                    : null,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  child: Stack(
                                    children: [
                                      _image == null
                                          ? Container(
                                              width: 100,
                                              height: 100,
                                              child: AvaterProfile(
                                                pathAvater:
                                                    ModelStatic.user.avatarUrl,
                                              ),
                                            )
                                          : Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              clipBehavior: Clip.hardEdge,
                                              child: Image.file(
                                                _image,
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                      edit
                                          ? Align(
                                              alignment: Alignment.topRight,
                                              child: Icon(
                                                Icons.add_a_photo,
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "My Profile",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff3A79B1)),
                              ),
                              SizedBox(height: 2),
                              Line(width: 110),
                              SizedBox(height: 10),
                              MainTextField(
                                controller: _firstname,
                                enabled: edit,
                                labelText: 'First name',
                              ),
                              SizedBox(height: 10),
                              MainTextField(
                                controller: _lastname,
                                enabled: edit,
                                labelText: 'Last name',
                              ),
                              SizedBox(height: 10),
                              InkWell(
                                onTap: !edit
                                    ? null
                                    : () {
                                        _selectCountry();
                                      },
                                child: MainTextField(
                                  controller: _country,
                                  enabled: false,
                                  disabledBorder: !edit
                                      ? null
                                      : OutlineInputBorder(
                                          borderSide: new BorderSide(
                                            color: Color(0xff6E8EC6),
                                          ),
                                        ),
                                  labelText: 'Country',
                                ),
                              ),
                              SizedBox(height: 10),
                              MainTextField(
                                controller: _yen,
                                enabled: edit,
                                labelText: 'YEN-D Sections',
                              ),
                              SizedBox(height: 10),
                              MainTextField(
                                controller: _phone,
                                enabled: edit,
                                labelText: 'Contact Tel',
                              ),
                              SizedBox(height: 10),
                              MainTextField(
                                controller: _email,
                                enabled: false,
                                labelText: 'E-mail',
                              ),
                              SizedBox(height: 10),
                              MainTextField(
                                enabled: edit,
                                controller: _business,
                                labelText: 'Business',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  edit ? _buildSaveBtn(context) : _buildEditBtn(context),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveBtn(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NonCornerButton(
          textButton: "Save",
          textColor: Color(0xffffffff),
          borderRadius: 40,
          padding: 0,
          color: Color(0xff80D3F6),
          width: MediaQuery.of(context).size.width / 2.7,
          textSize: 20,
          onTap: () {
            setState(() {
              update();
            });
          },
        ),
        SizedBox(width: 10),
        NonCornerButton(
          textButton: "Cancel",
          textColor: Color(0xffffffff),
          borderRadius: 40,
          padding: 0,
          color: Color(0xffEC2024),
          width: MediaQuery.of(context).size.width / 2.7,
          textSize: 20,
          onTap: () {
            setState(() {
              edit = false;
              _image = null;
            });
          },
        ),
      ],
    );
  }

  Widget _buildEditBtn(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NonCornerButton(
          textButton: "Edit Profile",
          textColor: Color(0xffffffff),
          borderRadius: 40,
          padding: 0,
          color: Color(0xff80D3F6),
          width: MediaQuery.of(context).size.width / 2.7,
          textSize: 20,
          onTap: () {
            setState(() {
              edit = true;
            });
          },
        ),
      ],
    );
  }
}
