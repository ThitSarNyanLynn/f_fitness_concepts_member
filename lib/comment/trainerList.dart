import 'dart:convert';
import 'package:ffitnessconceptsmember/comment/makeComment.dart';
import 'package:ffitnessconceptsmember/drawer.dart';
import 'package:ffitnessconceptsmember/globals.dart';
import 'package:ffitnessconceptsmember/model/trainerModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class TrainerList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TrainerListState();
}

class TrainerListState extends State<TrainerList> {
  var formatter = new DateFormat('dd-MMM');


  @override
  void initState() {
    super.initState();
    //_getTrainerList();
  }

  Future<List<TrainerModel>> _getTrainerList() async {
    List<TrainerModel> trainerList = [];
    //final Map<String, dynamic> jsonResponse = json.decode(response.body);

    print('here at search init button click');

    final _response = await http.post("$serverLink" + "getTrainer.php");
    //print('res ${response}');
    //print('res ${response.body}');
    //print('res phrase ${response.reasonPhrase}');
    //print('res statusCode ${response.statusCode}');
    //print('res headers ${response.headers}');

    //here, u will get, ClassName,ClassInfo,ClassTime,Fees,TrainerName
    print("bbbbb");
    var jsonResponse = json.decode(_response.body);
    print("aaaaaaaaa");
    //print("json response is $jsonResponse");

    for (var r in jsonResponse) {
      //print("r is $r");
      TrainerModel rj = TrainerModel(
        trainerID: int.parse(r["TrainerNo"]),
        trainerName: r["TrainerName"],
        trainerPhoto: r["Photo"],
      );
      print("rj is $rj");
      trainerList.add(rj);
    }
    print("length is ${trainerList.length}");
    print("pending form list is $trainerList");
    return trainerList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Trainer"),
      ),
      drawer: DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.only(top:8.0),
        child: FutureBuilder<List<TrainerModel>>(
            future: _getTrainerList(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data.length == 0) {
                return Center(
                  child: Text(
                    "There is no trainer.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        fontSize: 16),
                  ),
                );
              } else if (snapshot.data != null) {
                print("found data here");
                return ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.memory(base64Decode(snapshot.data[index].trainerPhoto)),
                      /*leading: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.transparent,
                        //backgroundImage: AssetImage("assets/girl.jpg"),
                        backgroundImage: MemoryImage(
                            base64Decode(snapshot.data[index].trainerPhoto)),
                      ),*/
                      title: Text(snapshot.data[index].trainerName),
                      trailing: GestureDetector(
                        child: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          print("this will be sent ${snapshot.data[index]}");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MakeComment(trainerModel: snapshot.data[index])));
                        },
                      ),
                    );
                  },
                );
                /*
                return ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: trainerList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.transparent,
                        //backgroundImage: AssetImage("assets/girl.jpg"),
                        backgroundImage: MemoryImage(
                            base64Decode(trainerList[index].trainerPhoto)),
                      ),
                      title: Text(trainerList[index].trainerName),
                      trailing: GestureDetector(
                        child: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          print("this will be sent ${trainerList[index]}");
                          /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MakeComment()));*/
                        },
                      ),
                    );
                  },
                );
                 */
              }
              return Container(
                alignment: AlignmentDirectional.center,
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
