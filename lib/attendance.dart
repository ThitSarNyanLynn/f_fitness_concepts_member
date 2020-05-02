import 'dart:convert';
import 'package:ffitnessconceptsmember/drawer.dart';
import 'package:ffitnessconceptsmember/model/AttendanceModel.dart';
import 'package:ffitnessconceptsmember/globals.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Attendance extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AttendanceState();
}

class AttendanceState extends State<Attendance> {
  @override
  void initState() {
    super.initState();
    _getAttendanceList();
  }

  Future<List<AttendanceModel>> _getAttendanceList() async {
    List<AttendanceModel> _attendanceLists = [];
    //final Map<String, dynamic> jsonResponse = json.decode(response.body);

    print('here at search init button click');

    final response = await http.post("$serverLink" + "attendance.php", body: {
      "MemberNo": memberNo.toString(),
    });

    print(response.body);
    //here, u will get, ClassName,ClassInfo,ClassTime,Fees,TrainerName
    var jsonResponse = json.decode(response.body);
    print("json response is $jsonResponse");

    for (var r in jsonResponse) {
      AttendanceModel rj = AttendanceModel(
          inDateTime: r["InDateTime"],
          outDateTime: r["OutDateTime"],
          inOutStatus: r["InOutStatus"],);
      _attendanceLists.add(rj);
    }
    print("length is ${_attendanceLists.length}");
    print("pending form list is $_attendanceLists");
    return _attendanceLists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gym Classes'),
      ),
      drawer: DrawerMenu(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            FutureBuilder<List<AttendanceModel>>(
                future: _getAttendanceList(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data.length == 0) {
                    return Center(
                      child: Text(
                        "There is no Gym Class.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                            fontSize: 16),
                      ),
                    );
                  } else if (snapshot.data != null) {
                    return ListView.separated(
                      //scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => myDivider,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                snapshot.data[index].inDateTime,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text("${snapshot.data[index].outDateTime} MMK"),


                            ],
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Container(
                    alignment: AlignmentDirectional.center,
                    child: CircularProgressIndicator(),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
