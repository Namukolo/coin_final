import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_chart_json/task.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:loyalty_points/data/data.dart';

class TaskHomePage extends StatefulWidget {
  @override
  _TaskHomePageState createState() {
    return _TaskHomePageState();
  }
}

class _TaskHomePageState extends State<TaskHomePage> {
  // User user;
  //
  // Future getUserData() async {
  //   User userData = await FirebaseAuth.instance.currentUser;
  //   setState(() {
  //     user = userData;
  //     print(userData.uid);
  //   });
  // }
  String _userId;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // getUserData();
  }

  List<charts.Series<Task, String>> _seriesPieData;
  List<Task> mydata;
  _generateData(mydata) {
    _seriesPieData = List<charts.Series<Task, String>>();

    _seriesPieData.add(
      charts.Series(
        domainFn: (Task task, _) => task.taskDetails,
        measureFn: (Task task, _) => int.parse(task.taskVal),
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor((task.taskDetails == 'groceries')
                ? Colors.green
                : (task.taskDetails == 'cosmetics')
                    ? Colors.purple
                    : (task.taskDetails == 'electronics')
                        ? Colors.blue
                        : (task.taskDetails == 'freshproduce')
                            ? Colors.orange
                            : (task.taskDetails == 'clothing')
                                ? Colors.black12
                                : Colors.red),
        id: 'tasks',
        data: mydata,
        labelAccessorFn: (Task row, _) =>
            "${row.taskDetails}\n" + "Points ${row.taskVal}",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Spending Habits',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: _buildBody(context),
              height: 500,
            ),
            Text(
              'Your spending details will appear here',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16.0),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (user != null) {
      _userId = user.uid;
    }
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('userOrders')
          .doc('${_userId}')
          .collection('orders')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return LinearProgressIndicator();
        } else {
          List<Task> task = snapshot.data.docs
              .map((documentSnapshot) => Task.fromMap(documentSnapshot.data()))
              .toList();
          return _buildChart(context, task);
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<Task> taskdata) {
    mydata = taskdata;
    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Points Tracker',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.PieChart(_seriesPieData,
                    animate: true,
                    animationDuration: Duration(seconds: 5),
                    behaviors: [
                      new charts.DatumLegend(
                        outsideJustification:
                            charts.OutsideJustification.endDrawArea,
                        horizontalFirst: false,
                        desiredMaxRows: 2,
                        cellPadding: new EdgeInsets.only(
                            right: 4.0, bottom: 4.0, top: 4.0),
                        entryTextStyle: charts.TextStyleSpec(
                            // color: charts.MaterialPalette.purple.shadeDefault,
                            fontFamily: 'Georgia',
                            fontSize: 18),
                      )
                    ],
                    defaultRenderer: new charts.ArcRendererConfig(
                        arcWidth: 100,
                        arcRendererDecorators: [
                          new charts.ArcLabelDecorator(
                              labelPosition: charts.ArcLabelPosition.inside)
                        ])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
