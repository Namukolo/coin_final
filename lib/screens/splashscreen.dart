import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 2), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.of(context).pushReplacementNamed('/check');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 80.0,
            child: Image.asset('assets/coin.png')),
      ),
    );
  }
}
