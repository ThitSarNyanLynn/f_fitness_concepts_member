import 'dart:convert';
import 'package:ffitnessconceptsmember/drawer.dart';
import 'package:ffitnessconceptsmember/globals.dart';
import 'package:ffitnessconceptsmember/model/myClassModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MyClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyClassState();
}

class MyClassState extends State<MyClass> {
  @override
  void initState() {
    super.initState();
    _getMyClassList();
  }

  Future<List<MyClassModel>> _getMyClassList() async {
    List<MyClassModel> _myClassLists = [];
    //final Map<String, dynamic> jsonResponse = json.decode(response.body);

    print('here at search init button click');

    final response = await http.post("$serverLink" + "myClasses.php", body: {
      "MemberNo": memberNo.toString(),
    });

    print(response.body);
    //here, u will get, ClassName,ClassInfo,ClassTime,Fees,TrainerName
    var jsonResponse = json.decode(response.body);
    print("json response is $jsonResponse");

    for (var r in jsonResponse) {
      MyClassModel rj = MyClassModel(
          durationFrom: r["DurationFrom"],
          durationTo: r["DurationTo"],
          className: r["ClassName"],
          classInfo: r["ClassInfo"],
          classTime: r["ClassTime"],
          fees: r["Fees"],
          trainerName: r["TrainerName"]);
      _myClassLists.add(rj);
    }
    print("length is ${_myClassLists.length}");
    print("pending form list is $_myClassLists");
    return _myClassLists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Classes'),
      ),
      drawer: DrawerMenu(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            FutureBuilder<List<MyClassModel>>(
                future: _getMyClassList(),
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
                                snapshot.data[index].className,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  "${DateFormat('dd MMMM , yyyy').format(DateTime.parse(snapshot.data[index].durationFrom))}  -  ${DateFormat('dd MMMM , yyyy').format(DateTime.parse(snapshot.data[index].durationTo))}"),
                              Text("${snapshot.data[index].fees} MMK"),
                              Text(snapshot.data[index].classTime),
                              Text(snapshot.data[index].trainerName),
                              Text(snapshot.data[index].classInfo),
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
