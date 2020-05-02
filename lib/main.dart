import 'dart:async';
import 'package:ffitnessconceptsmember/bodyWeight.dart';
import 'package:ffitnessconceptsmember/changePsw.dart';
import 'package:ffitnessconceptsmember/comment/trainerList.dart';
import 'package:ffitnessconceptsmember/dataHelper.dart';
import 'package:ffitnessconceptsmember/model/userProfileModel.dart';
import 'package:ffitnessconceptsmember/myProfile.dart';
import 'package:flutter/material.dart';
import 'globals.dart';
import 'login.dart';

void main() async {
  RouteFactory _routes() {
    return (settings) {
      //final Map<String, dynamic> args = settings.arguments;
      Widget screen;
      var args = settings.arguments;
      switch (settings.name) {
        case '/':
          //screen = LoginPage();
          screen = MyApp();
          break;
        case '/loginPage':
          screen = LoginPage();
          break;
        case '/myProfile':
          screen = MyProfile();
          break;
        case '/changePsw':
          screen = ChangePassword();
          break;
        case '/changePsw':
          screen = ChangePassword();
          break;
        case '/bodyWeight':
          screen = BodyWeight();
          break;
        case '/trainerList':
          screen = TrainerList();
          break;
        default:
          return null;
      }
      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }

  runApp(
    MaterialApp(
      title: 'Fitness Concepts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'OpenSans',
        primarySwatch: Colors.teal,
      ),
      onGenerateRoute: _routes(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  DatabaseHelper _db = DatabaseHelper();
  bool _bolIsLogin = false;
  Widget _myWidget = Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );

  @override
  void initState() {
    super.initState();
    _navigateHomeFuture().then((value) {
      setState(() {
        if (value == true) {
          _myWidget = MyProfile();
        } else if (value == false) {
          _myWidget = LoginPage();
        }
      });
    });
  }

  Future<bool> _navigateHomeFuture() async {
    UserProfileModel _userProfile = await _db.getUserProfile();
    print("navigate userProfileModel is $_userProfile");
    /*
    navigate userProfileModel is UserProfileModel{
    1,1,AA,0001664556,Aung Aung,2019-01-17 00:00:00.000,2020-01-01 00:00:00.000,1,1,Silver,0,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxISEhUSExIVFRUXFRgXFxYVFRUXFRUWFxcXGBgVFxcYHSggGBolGxcVITEhJSkrLi4uFx8zODMtNygtLisBCgoKDg0OGxAQGisfHx0rLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLSstLSstLTItLS0tLf/AABEIARMAtwMBIgACEQEDEQH/xAAcAAABBQEBAQAAAAAAAAAAAAAAAQIDBAUGBwj/xABREAABAwICBAkFDQUFBgcAAAABAAIDBBESIQUxQVEGEyJhcYGRobEyQnKSwRQjM1JigoOToqOytdEHQ3PC8BWEs7ThNFOUpMXSJFVjdKXE8f/EABkBAQEAAwEAAAAAAAAAAAAAAAABAgMEBf/EACMRAQEAAgEEAwEBAQEAAAAAAAABAhEDBBIhMRNBUWEygSL/2gAMAwEAAhEDEQA/APbEIQqFQkCVAIQhAIQhAIQhAIQhAIQhAIQhAIQhAJClSFAIQhUIhBSoBCEKASpEBAqEIQCEIQCEIQCFl6Y0iImOkxgYBcjKxtnhdtFxkOchUdO8Mqamh47FxouGhsZDnEkE78hlrV0unRIWXwf02yrhbK1rmXywvFiCPELTxKIVCEIBCEIBIUqQoBCEKhClSFKgEIQoBCEIFCEiAgVCF5j+1vh0ynZ7mhkHGk++WzLW2vg3XO0bulFi1wh/afDHK6CFrpA0cqVhs1pzvhuOVbLPVmvPq7h3WPJPHvw/EDsIdr2tA2bObnXHe7i8k2c8n5RBN9ZJGxJBOXuBkByOQDfKy3DnsVWc01ZuElRJcOmeQ4ZtxOAAGq43KgNJygBpe7De5z5NzzdKYY3NxFtj
     */

    //if user already log in,
    if (_userProfile.isLogin == 1) {
      //saving for temporary in globals
      setState(() {
        //_bolIsLogin=true;
        memberNo = _userProfile.memberNo;
        memberLoginID = _userProfile.memberLoginID;
        memberID = _userProfile.memberID;
        memberName = _userProfile.memberName;
        memberRegisterDate = _userProfile.memberRegisterDate;
        memberExpireDate = _userProfile.memberExpireDate;
        memberTypeNo = _userProfile.memberTypeNo;
        memberLevelNo = _userProfile.memberLevelNo;
        memberLevelName = _userProfile.memberLevelName;
        memberPoint = _userProfile.memberPoint;
        memberPhoto = _userProfile.photo;
      });
      return true;
    } else {
      //if user not log in
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _myWidget;
  }
}

/*
FutureBuilder(
      future: _navigateHomeFuture(),
        builder: (context,snapshot){
        Widget _children;
        if(snapshot.hasData){
          if(snapshot.data==true){
            _children= MyProfile();
          }else if(snapshot.data==false){
            _children= LoginPage();
          }
        }else if (snapshot.hasError){
          _children=Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:  <Widget>[
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ],
            ),
          );
        }else{
          _children=Center(
            child: CircularProgressIndicator(),
          );
        }
        return _children;
        })
import 'dart:async';
import 'package:ffitnessconceptsmember/bodyWeight.dart';
import 'package:ffitnessconceptsmember/changePsw.dart';
import 'package:ffitnessconceptsmember/dataHelper.dart';
import 'package:ffitnessconceptsmember/model/userProfileModel.dart';
import 'package:ffitnessconceptsmember/myProfile.dart';
import 'package:flutter/material.dart';
import 'globals.dart';
import 'login.dart';

void main() async {
  RouteFactory _routes() {
    return (settings) {
      //final Map<String, dynamic> args = settings.arguments;
      Widget screen;
      var args = settings.arguments;
      switch (settings.name) {
        case '/':
          //screen = LoginPage();
          screen = MyApp();
          break;
        case '/loginPage':
          screen = LoginPage();
          break;
        case '/myProfile':
          screen = MyProfile();
          break;
        case '/changePsw':
          screen = ChangePassword();
          break;
        case '/changePsw':
          screen = ChangePassword();
          break;
        case '/bodyWeight':
          screen = BodyWeight();
          break;
        default:
          return null;
      }
      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }

  runApp(
    MaterialApp(
      title: 'Fitness Concepts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'OpenSans',
        primarySwatch: Colors.teal,
      ),
      onGenerateRoute: _routes(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _bolIsLogin = false;
  DatabaseHelper _db = DatabaseHelper();

  Future<bool> _navigateHomeFuture(BuildContext context) async {
    UserProfileModel _userProfile = await _db.getUserProfile();
    print("navigate userProfileModel is $_userProfile");

    //if user already log in,
    if (_userProfile.isLogin == 1) {
      //saving for temporary in globals
      setState(() {
        //_bolIsLogin=true;
        memberNo = _userProfile.memberNo;
        memberLoginID = _userProfile.memberLoginID;
        memberID = _userProfile.memberID;
        memberName = _userProfile.memberName;
        memberRegisterDate = _userProfile.memberRegisterDate;
        memberExpireDate = _userProfile.memberExpireDate;
        memberTypeNo = _userProfile.memberTypeNo;
        memberLevelNo = _userProfile.memberLevelNo;
        memberLevelName = _userProfile.memberLevelName;
        memberPhoto = _userProfile.photo;
      });
      return true;
    } else {
      //if user not log in
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _navigateHomeFuture(context),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          _navigateHomeFuture(context).then((val) => _bolIsLogin = val);
          if (_bolIsLogin == false) {print("login page arrive");
            return LoginPage();
          } else {print("profile page arrive");
            return MyProfile();
          }
        });
  }
}

 */
