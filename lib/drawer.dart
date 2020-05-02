import 'dart:convert';
import 'package:ffitnessconceptsmember/bodyWeight.dart';
import 'package:ffitnessconceptsmember/changePsw.dart';
import 'package:ffitnessconceptsmember/comment/trainerList.dart';
import 'package:ffitnessconceptsmember/dataHelper.dart';
import 'package:ffitnessconceptsmember/globals.dart';
import 'package:ffitnessconceptsmember/myClass.dart';
import 'package:ffitnessconceptsmember/myProfile.dart';
import 'package:ffitnessconceptsmember/my_flutter_app_icons.dart';
import 'package:ffitnessconceptsmember/gymClass.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class DrawerMenu extends StatelessWidget {
  DrawerMenu({Key key}) : super(key: key);

  Future _logout() async {
    DatabaseHelper _db = DatabaseHelper();
    _db.deleteTable(sqliteTableName: weightTblSqlite).then((value) {
      _db.deleteTable(sqliteTableName: userProfileTblSqlite).then((value) {
        SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    {
      return Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the Drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                "",
              ),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/drawerBackground.jpg"),
                      fit: BoxFit.cover)),
              /*accountEmail: Text(
                '${loginUser.userName}',
                style: TextStyle(fontSize: 20.0),
              ),*/

              accountEmail: Text(
                //memberName,
                memberName,
                style: TextStyle(fontSize: 20.0),
              ),
              /*
                accountEmail: ScopedModelDescendant<LoginUserModel>(
                builder: (context, child, loginUser) => Text(
                  '${loginUser.userName}',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
                 */
              currentAccountPicture: CircleAvatar(
                radius: 30,
                backgroundImage: MemoryImage(base64Decode(memberPhoto)),
              ),
            ),
            ListTile(
              leading: Icon(
                MyFlutterApp.user,
                size: 20,
              ),
              title: Text(
                'My Profile',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyProfile()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                MyFlutterApp.gauge,
                size: 20,
              ),
              title: Text(
                'My Body Weight',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BodyWeight()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                MyFlutterApp.users,
                size: 20,
              ),
              title: Text(
                'Gym Classes',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () async {
                try {
                  final _connectSrv =
                      await http.post("$serverLink" + "checkConnect.php");
                  var _connectResult = json.decode(_connectSrv.body);
                  //server connected
                  if (_connectResult[0]['Test'] == "OK") {

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GymClass()),
                    );
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
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(
                                'CANCEL',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        );
                      });
                }
              },
            ),
            ListTile(
              leading: Icon(
                MyFlutterApp.user_add,
                size: 20,
              ),
              title: Text(
                'My Classes',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () async {
                try {
                  final _connectSrv =
                      await http.post("$serverLink" + "checkConnect.php");
                  var _connectResult = json.decode(_connectSrv.body);
                  //server connected
                  if (_connectResult[0]['Test'] == "OK") {

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyClass()),
                    );
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
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(
                                'CANCEL',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        );
                      });
                }
              },
            ),
            /*ListTile(
              leading: Icon(MyFlutterApp.calendar_check_o),
              title: Text(
                'My Attendance',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Attendance()),
                );
              },
            ),*/
            ListTile(
              leading: Icon(
                MyFlutterApp.comment,
                size: 20,
              ),
              title: Text(
                "Comment Trainer",
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TrainerList()));
              },
            ),
            ListTile(
              leading: Icon(
                MyFlutterApp.key,
                size: 20,
              ),
              title: Text(
                'Change My Password',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePassword()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                MyFlutterApp.logout,
                size: 20,
              ),
              title: Text(
                'LogOut',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Logout'),
                        content: Text(
                            'Do you really want to logout of this app? You will have to log in again next time.'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('No'),
                          ),
                          FlatButton(
                            onPressed: () {
                              _logout();
                            },
                            child: Text('Yes'),
                          ),
                        ],
                      );
                    });
              },
            ),
          ],
        ),
      );
    }
  }
}
