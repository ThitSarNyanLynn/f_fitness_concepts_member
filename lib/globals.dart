import 'package:flutter/material.dart';
//memberNo is member table primary key
//memberID is member RFID card number
//memberLoginID is member login account number

int memberNo,memberTypeNo, memberLevelNo,memberPoint;
String memberLoginID,memberID,memberName,memberRegisterDate,memberExpireDate,memberLevelName,memberPhoto;
Container dividingSpace = Container(margin: EdgeInsets.only(top: 20.0));
Padding smallDividingSpace=Padding(padding: EdgeInsets.only(top: 8.0));
Divider myDivider=Divider(color: Colors.blueGrey,);
//String serverLink = 'http://192.168.1.3:8080/fitnessConcepts/';
//String serverLink = 'http://192.168.100.32:90/fitnessConcepts/';
//String serverLink = 'http://192.168.1.10:8080/fitnessConcepts/';

//mdy fitness
String serverLink = 'http://192.168.1.10:90/fitnessConcepts/';
const weightTblSqlite='BodyWeight';
const userProfileTblSqlite='UserProfile';
