import 'package:ffitnessconceptsmember/dataHelper.dart';
import 'package:ffitnessconceptsmember/model/weightModel.dart';
import 'package:ffitnessconceptsmember/saveMyWeight.dart';
import 'package:ffitnessconceptsmember/drawer.dart';
import 'package:ffitnessconceptsmember/globals.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class BodyWeight extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BodyWeightState();
}

class BodyWeightState extends State<BodyWeight> {

  DatabaseHelper _db = DatabaseHelper();
  bool _isWeightData = true;
  bool _isLoadingForm = true;
  bool _isLoadingChart = true;

  int _currentWeight = 0, _initialWeight = 0, _weightDifference = 0;
  List<FlSpot> _flSpot = [];
  String _gainOrLoss = "";

  WeightModel _currentWeightData, _initialWeightData;

  @override
  void initState() {
    super.initState();
    //
    _getWeightReportData();
  }

  @override
  void dispose() {
    //
    super.dispose();
  }

  final _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  _getWeightReportData() async {
    //here, 1. get measuredYear from database, 2. save it in array, 3. save latest year index to show

    _db.getCurrentWeightData().then((val) {
      setState(() {
        if(val!=null) {
          _currentWeightData = val;
          _currentWeight = _currentWeightData.weight;
        }else{
          _currentWeight=0;
        }

      });
      //_currentWeight
      _db.getInitialWeightData().then((val) {
        setState(() {
          if(val!=null){
            _initialWeightData = val;
            _initialWeight = _initialWeightData.weight;
          }else{
            _initialWeight=0;
          }



          _gainOrLoss =
              _currentWeight > _initialWeight ? "Weight Gain" : "Weight Loss";

          _weightDifference = _currentWeight > _initialWeight
              ? (_currentWeight - _initialWeight)
              : (_initialWeight - _currentWeight);
        });
      });
      _getMonthlyWeight();
      _isLoadingForm = false;
    });
  }

  var _xaxisTitles = [];
  var _tooltipTitles = [];

  // List<FlSpot> _anotherMonthlyWt=[];
  _getMonthlyWeight() {
    int i = 0;
    _db.getMonthlyWeightData().then((val) {
      setState(() {

        _flSpot.clear();

        _xaxisTitles.clear();
        val.forEach((v) {
          _flSpot.add(FlSpot((i++).toDouble(), v.averageWeight));
          if (v.measureMonth == 1) {
            _xaxisTitles.add(_months[0]);
          } else if (v.measureMonth == 2) {
            _xaxisTitles.add(_months[1]);
          } else if (v.measureMonth == 3) {
            _xaxisTitles.add(_months[2]);
          } else if (v.measureMonth == 4) {
            _xaxisTitles.add(_months[3]);
          } else if (v.measureMonth == 5) {
            _xaxisTitles.add(_months[4]);
          } else if (v.measureMonth == 6) {
            _xaxisTitles.add(_months[5]);
          } else if (v.measureMonth == 7) {
            _xaxisTitles.add(_months[6]);
          } else if (v.measureMonth == 8) {
            _xaxisTitles.add(_months[7]);
          } else if (v.measureMonth == 9) {
            _xaxisTitles.add(_months[8]);
          } else if (v.measureMonth == 10) {
            _xaxisTitles.add(_months[9]);
          } else if (v.measureMonth == 11) {
            _xaxisTitles.add(_months[10]);
          } else if (v.measureMonth == 12) {
            _xaxisTitles.add(_months[11]);
          }

          if (v.measureMonth == 1) {
            _tooltipTitles.add("${v.measureYear} ${_months[0]}");
          } else if (v.measureMonth == 2) {
            _tooltipTitles.add("${v.measureYear} ${_months[1]}");
          } else if (v.measureMonth == 3) {
            _tooltipTitles.add("${v.measureYear} ${_months[2]}");
          } else if (v.measureMonth == 4) {
            _tooltipTitles.add("${v.measureYear} ${_months[3]}");
          } else if (v.measureMonth == 5) {
            _tooltipTitles.add("${v.measureYear} ${_months[4]}");
          } else if (v.measureMonth == 6) {
            _tooltipTitles.add("${v.measureYear} ${_months[5]}");
          } else if (v.measureMonth == 7) {
            _tooltipTitles.add("${v.measureYear} ${_months[6]}");
          } else if (v.measureMonth == 8) {
            _tooltipTitles.add("${v.measureYear} ${_months[7]}");
          } else if (v.measureMonth == 9) {
            _tooltipTitles.add("${v.measureYear} ${_months[8]}");
          } else if (v.measureMonth == 10) {
            _tooltipTitles.add("${v.measureYear} ${_months[9]}");
          } else if (v.measureMonth == 11) {
            _tooltipTitles.add("${v.measureYear} ${_months[10]}");
          } else if (v.measureMonth == 12) {
            _tooltipTitles.add("${v.measureYear} ${_months[11]}");
          }
        });
        i = 0;




        _isLoadingChart = false;
      });
    });
  }

  Widget _showMonthlyChart() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 48, 24, 0),
        child: LineChart(
          LineChartData(
            backgroundColor: Colors.white,
            lineTouchData: LineTouchData(
                getTouchedSpotIndicator:
                    (LineChartBarData barData, List<int> spotIndexes) {
                  return spotIndexes.map((spotIndex) {
                    return TouchedSpotIndicatorData(
                      const FlLine(color: Colors.teal, strokeWidth: 4),
                      const FlDotData(dotSize: 8, dotColor: Colors.teal),
                    );
                  }).toList();
                },
                touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.teal,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        final flSpot = barSpot;

                        return LineTooltipItem(
                          '${_tooltipTitles[flSpot.x.toInt()]} \n${flSpot.y.round()} lb',
                          const TextStyle(color: Colors.white),
                        );
                      }).toList();
                    },
                    tooltipBottomMargin: 10)),
            lineBarsData: [
              LineChartBarData(
                spots: _flSpot,
                //spots:[],
                isCurved: true,
                barWidth: 3,
                colors: [
                  Colors.teal,
                ],
                dotData: const FlDotData(
                  show: true,
                  dotColor: Colors.teal,
                ),
              ),
            ],
            minY: 70,
            borderData: FlBorderData(
                show: true,
                border: Border(
                  left: BorderSide(
                    color: Colors.transparent,
                  ),
                  right: BorderSide(
                    color: Colors.transparent,
                  ),
                  top: BorderSide(
                    color: Colors.transparent,
                  ),
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 4,
                  ),
                )),
            titlesData: FlTitlesData(
              bottomTitles: SideTitles(
                  showTitles: true,
                  textStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                  getTitles: (value) {
                    return (_xaxisTitles[value.round()].toString());
                  }),
              leftTitles: SideTitles(
                interval: 10,
                showTitles: true,
                getTitles: (value) {
                  return '${value.round()}';
                },
              ),
            ),
            gridData: FlGridData(
              drawHorizontalGrid: false,
              drawVerticalGrid: false,
              show: false,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _db.getCurrentWeightData(),
      builder: (context, snapshotCurrentWt) {
        if (snapshotCurrentWt.connectionState == ConnectionState.done) {
          if (!snapshotCurrentWt.hasData) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text('My Body Weight'),
              ),
              drawer: DrawerMenu(),
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  backgroundColor: Colors.teal,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SaveMyWeight()),
                    );
                  }),
              body: Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                      "There is no weight data. Please save a new weight data."),
                ),
              ),
            );
          } else if (snapshotCurrentWt.hasData) {
            //_getWeightReportData();
            //end of get weight
            return _isLoadingForm
                ? Scaffold(
                    appBar: AppBar(
                      title: Text('My Body Weight'),
                    ),
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "Loading. This could take a few minutes. Please wait and don't quit."),
                          ),
                        ],
                      ),
                    ),
                  )
                : Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      title: Text('My Body Weight'),
                    ),
                    drawer: DrawerMenu(),
                    floatingActionButton: FloatingActionButton(
                        child: Icon(Icons.add),
                        backgroundColor: Colors.teal,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SaveMyWeight()),
                          );
                        }),
                    body: SingleChildScrollView(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          //line chart goes here
                          _isLoadingChart
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : _flSpot.length == 1
                                  ? Center(
                                      child: Text(
                                          "It needs at least two months records of your weight data to show Monthly Line Chart."),
                                    )
                                  : _showMonthlyChart(),
                          /*
                  Container(
                    //height: 550,
                    height: MediaQuery.of(context).size.height * 0.55,
                    width: MediaQuery.of(context).size.width,
                    child: _showMonthlyChart(),
                  ),
                   */
                          myDivider,
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text(
                                      "Current Weight",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.teal,
                                      ),
                                    ),
                                    RichText(
                                        text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                        text: _currentWeight.toString(),
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      TextSpan(
                                          text: "lb",
                                          style: TextStyle(color: Colors.blue)),
                                    ])),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      "Initial Weight",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.teal,
                                      ),
                                    ),
                                    RichText(
                                        text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                        text: _initialWeight.toString(),
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black45,
                                        ),
                                      ),
                                      TextSpan(
                                          text: "lb",
                                          style:
                                              TextStyle(color: Colors.black54)),
                                    ])),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text(
                                      _gainOrLoss,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.teal,
                                      ),
                                    ),
                                    RichText(
                                        text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                        text: _weightDifference.toString(),
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.pinkAccent,
                                        ),
                                      ),
                                      TextSpan(
                                          text: "lb",
                                          style: TextStyle(
                                              color: Colors.pinkAccent)),
                                    ])),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
          }
        } else {
          return CircularProgressIndicator();
        }
        return null;
      },
    );
  }
}
