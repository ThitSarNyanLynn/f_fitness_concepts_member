import 'dart:convert';
import 'dart:io';
import 'package:ffitnessconceptsmember/dataHelper.dart';
import 'package:ffitnessconceptsmember/globals.dart';
import 'package:ffitnessconceptsmember/model/userProfileModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DatabaseHelper _db = DatabaseHelper();
  TextEditingController _tecLoginID = TextEditingController();
  TextEditingController _tecPassword = TextEditingController();
  bool _showPassword = false;
  String _errMsg = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tecLoginID.dispose();
    _tecPassword.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    print("here at login button click");
    final _response = await http.post("$serverLink" + "login.php", body: {
      "MemberLoginID": _tecLoginID.text,
      "PWD": _tecPassword.text,
    });
    print("res $_response");
print("res body ${_response.body}");
    //here, u will get, MemberNo
    var loginMember = json.decode(_response.body);

    if (loginMember.length == 0) {
      setState(() {
        _errMsg = "Incorrect UserName or Password.";
      });
    } else {
      UserProfileModel _userProfile = UserProfileModel(
        isLogin: 1,
        memberNo: int.parse(loginMember[0]['MemberNo']),
        memberLoginID: _tecLoginID.text,
        memberID: loginMember[0]['MemberID'],
        memberName: loginMember[0]['MemberName'],
        memberRegisterDate: loginMember[0]['DurationFrom'],
        memberExpireDate: loginMember[0]['DurationTo'],
        memberTypeNo: int.parse(loginMember[0]['MemberTypeNo']),
        memberLevelNo: int.parse(loginMember[0]['MemberLevelNo']),
        memberLevelName: loginMember[0]['MemberLevelName'],
        memberPoint: int.parse(loginMember[0]['MemberPoint']),
        photo: loginMember[0]['Photo'],
      );
      _db.getNInsertUserProfile(_userProfile);


      //saving for temporary in globals

      memberNo = _userProfile.memberNo;
      memberLoginID = _tecLoginID.text;
      memberID = _userProfile.memberID;
      memberName = _userProfile.memberName;
      memberRegisterDate = _userProfile.memberRegisterDate;
      memberExpireDate = _userProfile.memberExpireDate;
      memberTypeNo = _userProfile.memberTypeNo;
      memberLevelNo = _userProfile.memberLevelNo;
      memberLevelName = _userProfile.memberLevelName;
      memberPhoto = _userProfile.photo;
      memberPoint = _userProfile.memberPoint;


      Navigator.pushNamedAndRemoveUntil(
          context, '/myProfile', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
          key: _formKey,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                //logo
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 70.0,
                  child: Image.asset(
                    'assets/logo.jpg',
                  ),
                ),
                SizedBox(height: 38.0),
                //memberName
                TextFormField(
                  controller: _tecLoginID,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.account_box,
                      color: Colors.teal,
                    ),
                    hintText: 'Login ID',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  ),
                  validator: (String val) {
                    if (val.isEmpty) {
                      return 'Please enter Login ID.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.0),
                //Password
                TextFormField(
                  controller: _tecPassword,
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock, color: Colors.teal),
                    hintText: 'Password',
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                      child: Icon(_showPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  ),
                  obscureText: !_showPassword,
                  validator: (String val) {
                    if (val.isEmpty) {
                      return 'Please enter password.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                //SizedBox(height: 20.0),
                Text(
                  _errMsg,
                  style: TextStyle(fontSize: 20.0, color: Colors.red),
                ),
                //LoginButton
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: EdgeInsets.all(12),
                    color: Colors.teal,
                    child:
                        Text('Log In', style: TextStyle(color: Colors.white)),
                    /*onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyProfile()),
                  );
                },*/
                    onPressed: () async {
                      //check memberID and password are filled
                      if (_formKey.currentState.validate()) {
                        //checking server connection
                        try {
                          final _connectSrv = await http
                              .post("$serverLink" + "checkConnect.php");
                          var _connectResult = json.decode(_connectSrv.body);
                          //server connected
                          if (_connectResult[0]['Test'] == "OK") {

                            _login();
                          }
                        } on SocketException catch (_) {
                          //Not connected to server

                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Not connected to server'),
                                  content: Text(
                                      'Please make sure that your phone is connected to server.'),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text(
                                        'CANCEL',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
