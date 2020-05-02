import 'dart:convert';
import 'dart:io';
import 'package:ffitnessconceptsmember/drawer.dart';
import 'package:ffitnessconceptsmember/globals.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;


class ChangePassword extends StatefulWidget {
  ChangePassword({Key key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _errMsg = '';
  TextEditingController _tecPassword = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() {
    _tecPassword.dispose();
    super.dispose();
  }

  Future _changePassword() async {
    print('here at change password button click');
    print('$memberLoginID and "${_tecPassword.text}"');
    setState(() {
      _errMsg = "";
    });

    final response =
        await http.post("$serverLink" + "changePassword.php", body: {
      "LoginID": memberLoginID.toString(),
      "Password": _tecPassword.text,
    });
    if (response.statusCode == 200) {

      _tecPassword.text = "";
      Fluttertoast.showToast(
          msg: "Successfully Save Password.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          backgroundColor: Colors.black.withOpacity(0.8),
          textColor: Colors.white,
          fontSize: 16.0
      );
      Navigator.pushNamedAndRemoveUntil(
                          context, '/myProfile', (route) => false);
    }
  }

  Future<void> _okChangePswAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: const Text('Your password is successfully changed.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                _tecPassword.clear();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Change Password')),
      drawer: DrawerMenu(),
      body: Form(
          key: _formKey,
          child: Card(
            elevation: 3.0,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: Text(
                      memberName,
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  TextFormField(
                    controller: _tecPassword,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock, color: Colors.teal),
                      hintText: 'New Password',
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
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    ),
                    obscureText: !_showPassword,
                    validator: (String val) {
                      if (val.isEmpty) {
                        return 'Please enter new password.';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: RaisedButton(
                      onPressed: () async {
                        //check password is filled
                        if (_formKey.currentState.validate()) {
                          //check internet connection firstly
                          try {
                            final _connectSrv = await http
                                .post("$serverLink" + "checkConnect.php");
                            var _connectResult = json.decode(_connectSrv.body);
                            //server connected
                            if (_connectResult[0]['Test'] == "OK") {

                              _changePassword();
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
                      child: Text(
                        'Change Password',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                  Text(
                    _errMsg,
                    style: TextStyle(fontSize: 15.0, color: Colors.red),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
