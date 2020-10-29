import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loyalty_points/helper/color_helper.dart';
import 'package:loyalty_points/helper/fryo_icons.dart';
import 'package:loyalty_points/model/category_model.dart';
import 'package:loyalty_points/model/expense_model.dart';

class PurchaseHistory extends StatefulWidget {
  @override
  _PurchaseHistoryState createState() => _PurchaseHistoryState();
}

class _PurchaseHistoryState extends State<PurchaseHistory> {
  User user;
  int price;
  String phoneNumber;
  int points;
  int groceriesTotal;
  int cosmeticsTotal;
  int electronicsTotal;
  int clothingTotal;
  int freshproduceTotal;

  Future getUserData() async {
    User userData = await FirebaseAuth.instance.currentUser;
    setState(() {
      user = userData;
      print(userData.uid);
    });
  }

  Future gettotalId() async {
    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection('userOrders')
        .doc('${user.uid}')
        .collection('orders')
        .get();
    return qn.docs.length.toString();
  }

  Future getpointsId() async {
    QuerySnapshot qnB = await FirebaseFirestore.instance
        .collection('userOrders')
        .doc('${user.uid}')
        .collection('orders')
        .get();
    return qnB.docs.length.toString();
  }

  Future gettotal() async {
    int total = 0;
    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection('userOrders')
        .doc('${user.uid}')
        .collection('orders')
        .get();
    for (int i = 0; i < qn.docs.length; i++) {
      total = total + int.parse(qn.docs[i]['price']);
      price = total;
    }
    setState(() {
      price = total;
      return price;
    });
    return total;
  }

  //TODO
  //change price to total
  Future getgroceriestotal() async {
    int total = 0;
    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection('userOrders')
        .doc('${user.uid}')
        .collection('orders')
        .where("producttype", isEqualTo: "groceries")
        .get();
    for (int i = 0; i < qn.docs.length; i++) {
      total = total + int.parse(qn.docs[i]['price']);
      groceriesTotal = total;
    }
    setState(() {
      groceriesTotal = total;
      return groceriesTotal;
    });
    return total;
  }

  Future getclothingtotal() async {
    int total = 0;
    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection('userOrders')
        .doc('${user.uid}')
        .collection('orders')
        .where("producttype", isEqualTo: "clothing")
        .get();
    for (int i = 0; i < qn.docs.length; i++) {
      total = total + int.parse(qn.docs[i]['price']);
      clothingTotal = total;
    }
    setState(() {
      clothingTotal = total;
      return clothingTotal;
    });
    return total;
  }

  Future getelectronicstotal() async {
    int total = 0;
    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection('userOrders')
        .doc('${user.uid}')
        .collection('orders')
        .where("producttype", isEqualTo: "electronics")
        .get();
    for (int i = 0; i < qn.docs.length; i++) {
      total = total + int.parse(qn.docs[i]['price']);
      electronicsTotal = total;
    }
    setState(() {
      electronicsTotal = total;
      return electronicsTotal;
    });
    return total;
  }

  Future getfreshproducetotal() async {
    int total = 0;
    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection('userOrders')
        .doc('${user.uid}')
        .collection('orders')
        .where("producttype", isEqualTo: "freshproduce")
        .get();
    for (int i = 0; i < qn.docs.length; i++) {
      total = total + int.parse(qn.docs[i]['price']);
      freshproduceTotal = total;
    }
    setState(() {
      freshproduceTotal = total;
      return freshproduceTotal;
    });
    return total;
  }

  Future getcosmeticsstotal() async {
    int total = 0;
    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection('userOrders')
        .doc('${user.uid}')
        .collection('orders')
        .where("producttype", isEqualTo: "cosmetics")
        .get();
    for (int i = 0; i < qn.docs.length; i++) {
      total = total + int.parse(qn.docs[i]['price']);
      cosmeticsTotal = total;
    }
    setState(() {
      cosmeticsTotal = total;
      return cosmeticsTotal;
    });
    return total;
  }

  Future getpoints() async {
    int point = 0;
    QuerySnapshot qnB = await FirebaseFirestore.instance
        .collection('userOrders')
        .doc('${user.uid}')
        .collection('orders')
        .get();
    for (int i = 0; i < qnB.docs.length; i++) {
      point = point + int.parse(qnB.docs[i]['points']);
      points = point;
    }
    setState(() {
      points = point;
      return points;
    });
    return point;
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    gettotalId();
    getpointsId();
    gettotal();
    getpoints();
    getclothingtotal();
    getcosmeticsstotal();
    getelectronicstotal();
    getfreshproducetotal();
    getgroceriestotal();
  }

  @override
  Widget build(BuildContext context) {
    void _showSpendingAnalysis() {
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          context: context,
          builder: (context) {
            return SingleChildScrollView(
              child: Container(
                height: 500,
                child: FutureBuilder(
                    future: gettotalId(),
                    builder: (context, snapshot) {
                      return Container(
                        margin: EdgeInsets.only(left: 35, bottom: 25),
                        child: Column(
                          // mainAxisSize: MainAxisSize.max,
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Summary Spending Analysis',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w300,
                                  decoration: TextDecoration.underline),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.all(25),
                              child: Column(
                                children: [
                                  FutureBuilder(
                                      future: gettotal(),
                                      builder: (context, price) {
                                        return Row(
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Total:  ",
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w200),
                                            ),
                                            SizedBox(
                                              width: 100,
                                            ),
                                            Text('\R ${price.data}',
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w200))
                                          ],
                                        );
                                      }),
                                  FutureBuilder(
                                      future: getclothingtotal(),
                                      builder: (context, clothingTotal) {
                                        return Row(
                                          children: [
                                            Text(
                                              "Clothing:  ",
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w200),
                                            ),
                                            SizedBox(
                                              width: 80,
                                            ),
                                            Text('\R ${clothingTotal.data}',
                                                style: TextStyle(
                                                    fontSize: 19,
                                                    fontWeight:
                                                        FontWeight.w200))
                                          ],
                                        );
                                      }),
                                  FutureBuilder(
                                      future: getcosmeticsstotal(),
                                      builder: (context, cosmeticsTotal) {
                                        return Row(
                                          children: [
                                            Text(
                                              "Cosmetics: ",
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w200),
                                            ),
                                            SizedBox(
                                              width: 69,
                                            ),
                                            Text(
                                              '\R ${cosmeticsTotal.data}',
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w200),
                                            ),
                                          ],
                                        );
                                      }),
                                  FutureBuilder(
                                      future: getelectronicstotal(),
                                      builder: (context, electronicsTotal) {
                                        return Row(
                                          children: [
                                            Text(
                                              "Electronics:  ",
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w200),
                                            ),
                                            SizedBox(
                                              width: 60,
                                            ),
                                            Text(
                                              '\R ${electronicsTotal.data}',
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w200),
                                            ),
                                          ],
                                        );
                                      }),
                                  FutureBuilder(
                                      future: getfreshproducetotal(),
                                      builder: (context, freshproduceTotal) {
                                        return Row(
                                          children: [
                                            Text(
                                              "Fresh Produce: ",
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w200),
                                            ),
                                            SizedBox(
                                              width: 35,
                                            ),
                                            Text(
                                              '\R ${freshproduceTotal.data}',
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w200),
                                            ),
                                          ],
                                        );
                                      }),
                                  FutureBuilder(
                                      future: getgroceriestotal(),
                                      builder: (context, groceryTotal) {
                                        return Row(
                                          children: [
                                            Text(
                                              "Grocery: ",
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w200),
                                            ),
                                            SizedBox(
                                              width: 95,
                                            ),
                                            Text(
                                              '\R ${groceryTotal.data}',
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w200),
                                            ),
                                          ],
                                        );
                                      }),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: <Widget>[
                                  //     FutureBuilder(
                                  //         future: gettotal(),
                                  //         builder: (context, price) {
                                  //           return Text(
                                  //             "Total:                   R " +
                                  //                 '${price.data}',
                                  //             style: TextStyle(
                                  //                 fontSize: 22,
                                  //                 fontWeight: FontWeight.w200),
                                  //           );
                                  //         }),
                                  //   ],
                                  // ),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: <Widget>[
                                  //     FutureBuilder(
                                  //         future: getgroceriestotal(),
                                  //         builder: (context, groceryTotal) {
                                  //           return Text(
                                  //             "Grocery:                   R " +
                                  //                 '${groceryTotal.data}',
                                  //             style: TextStyle(
                                  //                 fontSize: 22,
                                  //                 fontWeight: FontWeight.w200),
                                  //           );
                                  //         }),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: Colors.grey[700],
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.symmetric(vertical: 30),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      FutureBuilder(
                                          future: getpoints(),
                                          builder: (context, points) {
                                            return Row(
                                              children: <Widget>[
                                                Text(
                                                  "Total Points:                   ",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(
                                                  width: 100,
                                                ),
                                                Text('${points.data}',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ))
                                              ],
                                            );
                                          }),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text("Quantity",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          )),
                                      SizedBox(
                                        width: 200,
                                      ),
                                      Text(
                                          snapshot.data != null
                                              ? snapshot.data
                                              : 'Loading',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            );
          });
    }

    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("userOrders")
                      .doc('${user.uid}')
                      .collection('orders')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null)
                      return Text(
                        '                    No Items In The Orders',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      );
                    return Container(
                        height: 500,
                        width: 400,
                        child: ListView.separated(
                            physics: AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot products =
                                  snapshot.data.documents[index];
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(height: 5),
                                      Container(
                                        padding: EdgeInsets.all(1.0),
                                        height: 80,
                                        width: 100,
                                        // decoration: BoxDecoration(
                                        //     // color: Color(0xFF3D82AE),
                                        //     borderRadius:
                                        //         BorderRadius.circular(16)),
                                        child: Image.network(products['img']),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    products['name'],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    "\R " + products['price'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(height: 20);
                            }));
                  }),
              // floatingActionButton:FloatingActionButton(
              //   onPressed: () => _showSpendingAnalysis(),
              //   child: Icon(Icons.person),
              // ),
              // SizedBox(
              //   height: 30,
              // )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSpendingAnalysis(),
        child: Icon(Fryo.doc),
        backgroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // bottomNavigationBar:
    );
  }
}

AppBar buildAppBar() {
  return AppBar(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.white70,
    iconTheme: IconThemeData(color: Colors.black),
    title: Text(
      "Purchase History",
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
  );
}
