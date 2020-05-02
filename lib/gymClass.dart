import 'dart:convert';
import 'package:ffitnessconceptsmember/drawer.dart';
import 'package:ffitnessconceptsmember/globals.dart';
import 'package:ffitnessconceptsmember/model/gymClassModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GymClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GymClassState();
}

class GymClassState extends State<GymClass> {
  @override
  void initState() {
    super.initState();
    _getGymClassList();
  }

  Future<List<GymClassModel>> _getGymClassList() async {
    List<GymClassModel> _gymClassLists = [];
    //final Map<String, dynamic> jsonResponse = json.decode(response.body);

    print('here at search init button click');

    final response = await http.post("$serverLink" + "gymClasses.php", body: {
      "SelectType": "all",
    });

    print(response.body);
    //here, u will get, ClassName,ClassInfo,ClassTime,Fees,TrainerName
    var jsonResponse = json.decode(response.body);
    print("json response is $jsonResponse");

    for (var r in jsonResponse) {
      GymClassModel rj = GymClassModel(
          className: r["ClassName"],
          classInfo: r["ClassInfo"],
          classTime: r["ClassTime"],
          fees: r["Fees"],
          trainerName: r["TrainerName"]);
      _gymClassLists.add(rj);
    }
    print("length is ${_gymClassLists.length}");
    print("pending form list is $_gymClassLists");
    return _gymClassLists;
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
            FutureBuilder<List<GymClassModel>>(
                future: _getGymClassList(),
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
