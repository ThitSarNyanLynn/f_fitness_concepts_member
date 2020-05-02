import 'dart:convert';
import 'dart:io';
import 'package:ffitnessconceptsmember/dataHelper.dart';
import 'package:ffitnessconceptsmember/globals.dart';
import 'package:ffitnessconceptsmember/model/weightModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class SaveMyWeight extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SaveMyWeightState();
}

class SaveMyWeightState extends State<SaveMyWeight> {
  DatabaseHelper _db = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _tecWeight = TextEditingController();

  DateTime _today = DateTime.now();
  DateTime _minYear = DateTime(1970);
  DateTime _maxYear = DateTime(2100);
  String _showMeasureDateTime = '';
  String _saveMeasureDateTime = '';
  int _saveMeasureMonth = 0, _saveMeasureYear = 0;

  void _changeMeasureDate({@required DateTime dateTime}) {
    int year = dateTime.year, month = dateTime.month, date = dateTime.day;
    String strMonth =
        month.toString().length == 1 ? "0$month" : month.toString();
    String strDate = date.toString().length == 1 ? "0$date" : date.toString();
    setState(() {
      _showMeasureDateTime = ': ( $strDate - $strMonth - $year )';
      _saveMeasureDateTime = '$year-$strMonth-$strDate';
      _saveMeasureMonth = month;
      _saveMeasureYear = year;
    });
  }

  Future _saveWeight() async {



    WeightModel _weightM = WeightModel(
      measureDateTime: _saveMeasureDateTime,
      weight: int.parse(_tecWeight.text),
      measureMonth: _saveMeasureMonth,
      measureYear: _saveMeasureYear,
    );
    //save weight in server
    final response = await http.post("$serverLink" + "saveWeight.php", body: {
      "MemberNo": memberNo.toString(),
      "Dated": _weightM.measureDateTime,
      "Weight": _weightM.weight.toString(),
    });

    //if successfully save weight in server
    if (response.statusCode == 200) {
      //check weight is already saved in sqlite
      if ((await _db.checkWeightExist(measureDateTime: _saveMeasureDateTime) < 1)) {

        //there is no weight data created with given date, so, we will insert weight data in sqflite
        await _db.insertWeightDate(weightModel: _weightM);
      } else {

        //there is already created weight data, so, we will update weight data in sqflite
        await _db.updateWeightData(weightM: _weightM);
      }
      _tecWeight.text = "";
      Fluttertoast.showToast(
          msg: "Successfully Save Weight.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          backgroundColor: Colors.black.withOpacity(0.8),
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pushNamedAndRemoveUntil(context, '/bodyWeight', (route) => false);
    }
  }

  @override
  void dispose() {
    _tecWeight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Body Measurement'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Weight in pounds",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              TextFormField(
                controller: _tecWeight,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "Weight"),
              ),
              dividingSpace,
              //
              Text(
                "Date of measurement $_showMeasureDateTime",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              RaisedButton(
                  child: Text('Choose Date'),
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      firstDate: _minYear,
                      lastDate: _maxYear,
                      initialDate: _today,

                    ).then((DateTime value) => _changeMeasureDate(dateTime:value));
                  }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8),
        child: RaisedButton(
          child: Text(
            "Save",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          color: Colors.teal,
          onPressed: () async {
            //check password is filled
            if (_formKey.currentState.validate()) {
              //check server connection firstly
              try {
                final _connectSrv =
                    await http.post("$serverLink" + "checkConnect.php");
                var _connectResult = json.decode(_connectSrv.body);
                //server connected
                if (_connectResult[0]['Test'] == "OK") {

                  //save weight in server
                  _saveWeight();
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
            }
          },
        ),
      ),
    );
  }
}
