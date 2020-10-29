import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loyalty_points/screens/home_page.dart';
import 'package:loyalty_points/screens/login_page.dart';
import 'package:loyalty_points/screens/on_boarding_page.dart';

class Check extends StatefulWidget {
  @override
  _CheckState createState() => _CheckState();
}

class _CheckState extends State<Check> {
  Future _data;

  Future getUsers() async {
    var user = FirebaseAuth.instance.currentUser;
    // QuerySnapshot qn = await firestore.collection('electronics').getDocuments();
    return user;
  }

  @override
  void initState() {
    super.initState();

    _data = getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _data,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            // ignore: unused_local_variable
            User user = snapshot.data; // this is your user instance
            /// is because there is user already logged
            return HomePage();
          }

          /// other way there is no user logged.
          return OnBoardingPage();
        });
  }
}
