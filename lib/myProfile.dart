import 'dart:convert';
import 'dart:io';
import 'package:ffitnessconceptsmember/dataHelper.dart';
import 'package:ffitnessconceptsmember/drawer.dart';
import 'package:ffitnessconceptsmember/model/userProfileModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ffitnessconceptsmember/globals.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:async/async.dart';

class MyProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyProfileState();
}

class MyProfileState extends State<MyProfile> {
  DatabaseHelper _db = DatabaseHelper();
  File _imageFile;

  //File _profileImage = base64Decode(memberPhoto);
  Future<void> _refreshProfile() async {
    final _response = await http.post("$serverLink" + "getProfile.php", body: {
      "MemberNo": memberNo.toString(),
    });
    print('before we decode');
    print("hey${_response.body}hey");
    //here, u will get, MemberNo
    var loginMember = json.decode(_response.body);
    print(loginMember);

    if (loginMember.length > 1) {
      UserProfileModel _userProfile = UserProfileModel(
        isLogin: 1,
        memberNo: int.parse(loginMember[0]['MemberNo']),
        memberLoginID: loginMember[0]['MemberLoginID'],
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
      _db.updateUserProfile(userProfileModel: _userProfile);

      print('here login correct');

      //saving for temporary in globals

      setState(() {
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

      print(_userProfile);
    }
  }

  /* Future<void> _saveImageToServer() async {
    final response = await http.post("$serverLink" + "uploadImage.php", body: {
      "photo": memberPhoto,
      "memberNo": memberNo.toString(),
    });
    print("res ${response.body}");print("res code ${response.statusCode}");
    if (response.statusCode == 200) {
      print("success save photo to server");
    }
  }*/
  Future<void> _saveImageToServer() async {


    //save media file to server folder

    //upload image1
    var streamI1 =
        http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
    var lengthI1 = await _imageFile.length();
    var multipartFileI1 = http.MultipartFile("photo", streamI1, lengthI1,
        filename: basename(_imageFile.path));
    //
    var uriImage1 = Uri.parse("${serverLink}uploadImage.php");
    //
    var requestImage1 = http.MultipartRequest("POST", uriImage1);
    //
    requestImage1.fields['memberNo'] =memberNo.toString();
    requestImage1.files.add(multipartFileI1);
    var image1Response = await requestImage1.send();
    image1Response.stream.transform(utf8.decoder).listen((value) {
      print("i1 stream response is $value");
    });
    if (image1Response.statusCode == 200) {
      print("image 1 uploaded");
    } else {
      print("image 1 upload failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        actions: <Widget>[
          // action button
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text('Refresh Profile'),
              ),
              PopupMenuItem(
                value: 2,
                child: Text('Take Profile Picture'),
              ),
              PopupMenuItem(
                value: 3,
                child: Text('Choose from Gallery'),
              ),
            ],
            onSelected: (value) async {
              //checking server connection
              try {
                final _connectSrv =
                    await http.post("$serverLink" + "checkConnect.php");
                var _connectResult = json.decode(_connectSrv.body);
                //server connected
                if (_connectResult[0]['Test'] == "OK") {
                  print('server connected');
                  if (value == 1) {
                    _refreshProfile();
                  } else if (value == 2) {
                    File img =
                        await ImagePicker.pickImage(source: ImageSource.camera);
                    //File a=await ImagePicker.p
                    if (img != null) {
                      setState(() {
                        List<int> imageBytes = img.readAsBytesSync();
                        memberPhoto = base64Encode(imageBytes);
                        print("memberphoto camera $memberPhoto");
                        _imageFile = img;
                      });
                      //save photo in sqlite database
                      _db.updateProfileImage(
                          image: memberPhoto, memberNo: memberNo);
                      //save photo in server database
                      _saveImageToServer();
                    }
                  } else if (value == 3) {
                    File img = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
                    //File a=await ImagePicker.p
                    if (img != null) {
                      setState(() {
                        List<int> imageBytes = img.readAsBytesSync();
                        memberPhoto = base64Encode(imageBytes);
                        print("memberphoto galler $memberPhoto");
                        _imageFile = img;
                      });
                      //save photo in sqlite database
                      _db.updateProfileImage(
                          image: memberPhoto, memberNo: memberNo);
                      //save photo in server database
                      _saveImageToServer();
                    }
                  }
                }
              } on SocketException catch (_) {
                //Not connected to server
                print('not server connected');
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
        ],
      ),
      drawer: DrawerMenu(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.transparent,
                          //backgroundImage: AssetImage("assets/girl.jpg"),
                          backgroundImage:
                              MemoryImage(base64Decode(memberPhoto)),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            //memberName,
                            memberName,
                            style: TextStyle(fontSize: 20),
                          ),
                          Padding(padding: const EdgeInsets.all(2)),
                          Text(
                            memberLevelName,
                            style: TextStyle(fontSize: 14, color: Colors.teal),
                          ),
                          Text(
                            "${memberPoint.toString()} Points",
                            style: TextStyle(fontSize: 14, color: Colors.teal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Register Date",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          DateFormat('dd MMMM , yyyy')
                              .format(DateTime.parse(memberRegisterDate)),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Expire Date",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        DateFormat('dd MMMM , yyyy')
                            .format(DateTime.parse(memberExpireDate)),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            myDivider,
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: QrImage(
                data: memberID,
                size: 0.5 * MediaQuery.of(context).size.width,
                foregroundColor: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
