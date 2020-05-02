import 'dart:convert';
import 'package:ffitnessconceptsmember/globals.dart';
import 'package:ffitnessconceptsmember/model/trainerModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class MakeComment extends StatefulWidget {
  final TrainerModel trainerModel;

  MakeComment({Key key, @required this.trainerModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MakeCommentState();
}

class MakeCommentState extends State<MakeComment> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _tecComment = TextEditingController();


  Future _saveCommentInServer() async {
    print('here at _saveCommentInServer button click');
    final response =
    await http.post("$serverLink" + "makeComment.php", body: {
      "MemberNo": memberNo.toString(),
      "TrainerNo": widget.trainerModel.trainerID.toString(),
      "Comment": _tecComment.text,
    });
    if (response.statusCode == 200) {

      Fluttertoast.showToast(
          msg: "Successfully sent comment",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          backgroundColor: Colors.black.withOpacity(0.8),
          textColor: Colors.white,
          fontSize: 16.0
      );
      Navigator.pushNamedAndRemoveUntil(
                          context, '/trainerList', (route) => false);
    }
  }

  @override
  void dispose() {
    _tecComment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Make Comment"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                            backgroundImage: MemoryImage(
                                base64Decode(widget.trainerModel.trainerPhoto)),
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
                              widget.trainerModel.trainerName,
                              style: TextStyle(fontSize: 20),
                            ),
                            Padding(padding: const EdgeInsets.all(2)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(margin: EdgeInsets.only(top: 10)),
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Comment:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: _tecComment,
                        maxLines: null,
                        autovalidate: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter comment.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed: () {
                            if(_tecComment.text!=""){
                              _saveCommentInServer();
                            }
                          },
                          color: Colors.teal,
                          child: Text(
                            "Send",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
