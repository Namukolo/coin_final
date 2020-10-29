import 'package:flutter/material.dart';
//import '../shared/styles.dart';
// import '../widgets/common.dart';
// import '../widgets/small_button.dart';

import 'package:page_transition/page_transition.dart';
import './signup.dart';
import 'login_page.dart';

class LandingPageScreen extends StatefulWidget {
  final String pageTitle;

  LandingPageScreen({Key key, this.pageTitle}) : super(key: key);

  @override
  _LandingPageScreenState createState() => _LandingPageScreenState();
}

class _LandingPageScreenState extends State<LandingPageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/coin.png', width: 190, height: 190),
          Container(
            margin: EdgeInsets.only(bottom: 10, top: 0),
            child: Text(
              'Coin!',
            ),
          ),
          Container(
            width: 200,
            margin: EdgeInsets.only(bottom: 0),
            child: btnFlat('Sign In', () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.rotate,
                      duration: Duration(seconds: 1),
                      child: LoginPage()));
            }),
          ),
          Container(
            width: 200,
            padding: EdgeInsets.all(0),
            child: btnOutline('Sign Up', () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.rotate,
                      duration: Duration(seconds: 1),
                      child: Signup()));
              // Navigator.of(context).pushReplacementNamed('/signup');
            }),
          ),
          Container(
            margin: EdgeInsets.only(top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Language:', style: TextStyle(color: Colors.black)),
                Container(
                  margin: EdgeInsets.only(left: 6),
                  child: Text('English ›',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500)),
                )
              ],
            ),
          )
        ],
      )),
      backgroundColor: Colors.white70,
    );
  }
}

FlatButton btnFlat(String text, onPressed) {
  return FlatButton(
    onPressed: onPressed,
    child: Text(text),
    textColor: Colors.white,
    color: Colors.black,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  );
}

OutlineButton btnOutline(String text, onPressed) {
  return OutlineButton(
    onPressed: onPressed,
    child: Text(text),
    textColor: Colors.black,
    highlightedBorderColor: Colors.blue,
    borderSide: BorderSide(color: Colors.black),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  );
}
