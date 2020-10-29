import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loyalty_points/screens/PurchaseHistory.dart';
import 'package:loyalty_points/helper/fryo_icons.dart';
import 'package:loyalty_points/screens/cosmetics.dart';
import 'package:loyalty_points/screens/fresh_produce.dart';
import 'package:loyalty_points/screens/groceries.dart';

import 'SpendingDetails.dart';
import 'SpendingDetails.dart';
import 'clothing.dart';
import 'electronics.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user;
  final _key = GlobalKey<ScaffoldState>();

  Future<void> getUserData() async {
    User userData = await FirebaseAuth.instance.currentUser;
    setState(() {
      user = userData;
      print(userData.uid);
    });
  }

  Future<void> getUser() async {
    DocumentSnapshot cn = await FirebaseFirestore.instance
        .collection('users')
        .doc('${user.uid}')
        .get();
    return cn;
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    getUser();
  }

  startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            "#ff6666", "Cancel", true, ScanMode.BARCODE)
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    if (barcodeScanRes != '-1' || null) {
      return showDialog(
          context: context,
          builder: (context) {
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("products")
                    .where("barcode", isEqualTo: '$barcodeScanRes')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Dialog(
                      child: Container(
                        height: 350,
                        child: Text('Product Not Found'),
                      ),
                    );
                  } else {
                    return Dialog(
                      child: Container(
                        height: 352,
                        child: Column(children: [
                          Container(
                              height: 352,
                              width: 165,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot products =
                                      snapshot.data.documents[index];
                                  return ScanCard(products: products);
                                },
                              )),
                        ]),
                      ),
                    );
                  }
                });
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      floatingActionButton: floatingBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // appBar: buildAppBar(),
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            FutureBuilder(
                future: getUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return UserAccountsDrawerHeader(
                        decoration: BoxDecoration(color: Colors.black),
                        currentAccountPicture: new CircleAvatar(
                          radius: 60.0,
                          backgroundColor: Colors.white70,
                          backgroundImage: NetworkImage(
                              "https://cdn2.iconfinder.com/data/icons/website-icons/512/User_Avatar-512.png"),
                        ),
                        accountName: Text(
                          "${snapshot.data['displayName']}",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        accountEmail: Text(
                          "${snapshot.data['email']}",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ));
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text(
                "Purchase History",
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => PurchaseHistory()));
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(
                "Log out",
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pop();
                FirebaseAuth.instance.signOut().then(
                  (value) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/loginpage', (Route<dynamic> route) => false);
                  },
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.black,
            size: 30.0,
          ),
          onPressed: () {
            _key.currentState.openEndDrawer();
          },
        ),
        // leading: Icon(Icons.menu),
        actions: [
          IconButton(
            icon: Icon(
              Icons.person,
              color: Colors.black,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskHomePage(),
                ),
              );
            },
          ),
          IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.black,
                size: 30.0,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/cartpage');
              }),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                // Positioned(
                //   top: 10,
                //   right: 20,
                //   child: Align(
                //       alignment: Alignment.topRight,
                //       child: GestureDetector(
                //           onTap: () {
                //             _key.currentState.openEndDrawer();
                //           },
                //           child: Icon(Icons.menu))),
                // ),
                // Positioned(
                //   top: 10,
                //   right: 60,
                //   child: Align(
                //       alignment: Alignment.topRight,
                //       child: GestureDetector(
                //           onTap: () {
                //             // changeScreen(context, CartScreen());
                //             Navigator.of(context).pushNamed('/cartpage');
                //           },
                //           child: Icon(Icons.shopping_cart))),
                // ),
                // Positioned(
                //   top: 10,
                //   right: 100,
                //   child: Align(
                //       alignment: Alignment.topRight,
                //       child: GestureDetector(
                //           onTap: () {
                //             // _key.currentState.showSnackBar(
                //             //     SnackBar(content: Text("User profile")));
                //             Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                 builder: (_) => TaskHomePage(),
                //               ),
                //             );
                //           },
                //           child: Icon(Icons.person))),
                // ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'What are you shopping for?',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.black.withOpacity(0.6),
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8, left: 8, right: 8, bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    title: TextField(
                      textInputAction: TextInputAction.search,
                      onSubmitted: (pattern) async {
                        // await productProvider.search(productName: pattern);
                        // changeScreen(context, ProductSearchScreen());
                      },
                      decoration: InputDecoration(
                        hintText: "blazer, dress...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            headerTopCategories(context),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Groceries',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
              ),
            ),
            buildStreamBuilder(),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Clothing',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
              ),
            ),
            buildStreamClothes(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Electronics',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
              ),
            ),
            buildStreamElectronics(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Cosmetics',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
              ),
            ),
            buildStreamCosmetics(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Fresh Produce',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
              ),
            ),
            buildStreamFreshProduce(),
          ],
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot> buildStreamBuilder() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("products")
            .where("producttype", isEqualTo: "groceries")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null)
            return Text(
              'Scan Barcode',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          return Container(
              height: 270,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot products = snapshot.data.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ItemCard(products: products),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 5);
                  }));
        });
  }

  StreamBuilder<QuerySnapshot> buildStreamClothes() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("products")
            .where("producttype", isEqualTo: "clothing")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null)
            return Text(
              'Scan Barcode',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          return Container(
              height: 270,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot products = snapshot.data.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ItemCard(products: products),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 5);
                  }));
        });
  }

  StreamBuilder<QuerySnapshot> buildStreamElectronics() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("products")
            .where("producttype", isEqualTo: "electronics")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null)
            return Text(
              'Scan Barcode',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            );
          return Container(
              height: 270,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot products = snapshot.data.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ItemCard(products: products),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 5);
                  }));
        });
  }

  StreamBuilder<QuerySnapshot> buildStreamCosmetics() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("products")
            .where("producttype", isEqualTo: "cosmetics")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null)
            return Text(
              'Scan Barcode',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          return Container(
              height: 270,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot products = snapshot.data.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ItemCard(products: products),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 5);
                  }));
        });
  }

  StreamBuilder<QuerySnapshot> buildStreamFreshProduce() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("products")
            .where("producttype", isEqualTo: "freshproduce")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null)
            return Text(
              'Scan Barcode',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          return Container(
              height: 270,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot products = snapshot.data.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ItemCard(products: products),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 5);
                  }));
        });
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      title: Text(
        "Coin",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.shopping_cart,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/cartpage');
          },
        )
      ],
    );
  }

  Widget floatingBar() => Ink(
        decoration: ShapeDecoration(
          shape: StadiumBorder(),
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            scanBarcodeNormal();
          },
          backgroundColor: Colors.black,
          icon: Icon(
            FontAwesomeIcons.barcode,
            color: Colors.white,
          ),
          label: Text(
            "SCAN",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
}

//This is the part that shows up on the home screen
class ItemCard extends StatelessWidget {
  const ItemCard({
    Key key,
    @required this.products,
  }) : super(key: key);

  final DocumentSnapshot products;

  @override
  Widget build(BuildContext context) {
    String _userId;
    User loginUser;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
    }

    return Container(
      width: 220,
      // color: Colors.blueGrey,
      // decoration: BoxDecoration(color: Color(0xFF535353)),
      child: Card(
        color: Colors.white70,
        shape: RoundedRectangleBorder(
            // borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  child: Icon(
                    // CupertinoIcons.cart_fill_badge_plus,
                    Icons.shopping_cart,
                    color: Colors.black,
                    size: 26,
                  ),
                  onTap: () {
                    DocumentReference documentReference = FirebaseFirestore
                        .instance
                        .collection('userData')
                        .doc(_userId)
                        .collection('cartData')
                        .doc();
                    documentReference
                        .set({
                          'uid': _userId,
                          'barcode': products['barcode'],
                          'img': products['img'],
                          'name': products['name'],
                          'netweight': products['netweight'],
                          'price': products['price'],
                          'points': products['points'],
                          'producttype': products['producttype'],
                          'id': documentReference.id
                        })
                        .then((result) {})
                        .catchError((e) {
                          print(e);
                        });
                    Scaffold.of(context).showSnackBar(new SnackBar(
                      content: new Text(
                        'Added to Cart',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.start,
                      ),
                      duration: Duration(milliseconds: 300),
                      backgroundColor: Colors.black,
                    ));
                  },
                ),
              ),
            ),
            Container(
              // padding: EdgeInsets.all(20.0),
              height: 130,
              width: 160,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
              child: Image.network(products['img']),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0 / 4),
              child: Text(
                products['name'],
                style: TextStyle(
                  color: Color(0xFF535353),
                ),
              ),
            ),
            Text(
              "\R " + products['price'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class ScanCard extends StatelessWidget {
  const ScanCard({
    Key key,
    @required this.products,
  }) : super(key: key);
  final DocumentSnapshot products;

  @override
  Widget build(BuildContext context) {
    String _userId;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          height: 180,
          width: 160,
          decoration: BoxDecoration(
              color: Color(0xFF3D82AE),
              borderRadius: BorderRadius.circular(16)),
          child: Image.network(products['img']),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0 / 4),
          child: Text(
            products['name'],
            style: TextStyle(
              color: Color(0xFF535353),
              fontSize: 18,
            ),
          ),
        ),
        Column(
          children: [
            Text(
              "netweight- " + products['netweight'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(
              width: 30,
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "\R " + products['price'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              width: 60,
            ),
            Icon(
              Icons.add_shopping_cart,
              color: Colors.black,
              size: 27,
            ),
          ],
        ),
        SizedBox(
          width: 10,
        ),
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              color: Color(0xFF3D82AE),
              child: Text(
                "Add to cart",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                DocumentReference documentReference = FirebaseFirestore.instance
                    .collection('userData')
                    .doc(_userId)
                    .collection('cartData')
                    .doc();
                documentReference.set({
                  'uid': _userId,
                  'barcode': products['barcode'],
                  'img': products['img'],
                  'name': products['name'],
                  'netweight': products['netweight'],
                  'price': products['price'],
                  'id': documentReference.id
                }).then((result) {
                  dialogTrigger(context);
                }).catchError((e) {
                  print(e);
                });
              },
            ),
          ),
        )
      ],
    );
  }
}

Future<bool> dialogTrigger(BuildContext context) async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Job done', style: TextStyle(fontSize: 22.0)),
          content: Text(
            'Added Successfully',
            style: TextStyle(fontSize: 20.0),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Alright',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}

Widget sectionHeader(String headerTitle, {onViewMore}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(left: 15, top: 10),
        child: Text(headerTitle,
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            )),
      ),
      // Container(
      //   margin: EdgeInsets.only(left: 15, top: 2),
      //   child: FlatButton(
      //     onPressed: onViewMore,
      //     child: Text('See all ›',
      //         style: TextStyle(
      //           color: Colors.black,
      //           fontSize: 20,
      //           fontWeight: FontWeight.w800,
      //         )),
      //   ),
      // )
    ],
  );
}

Widget headerTopCategories(context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      sectionHeader('Categories', onViewMore: () {}),
      SizedBox(
        height: 150,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: <Widget>[
              headerCategoryItem('Groceries', Fryo.shop, onPressed: () {
                // changeScreen(context, Groceries());
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Groceries()));
              }),
              headerCategoryItem('Clothing', Fryo.shirt, onPressed: () {
                // changeScreen(context, Clothing());
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Clothing()));
              }),
              headerCategoryItem('Electronics', Fryo.camera, onPressed: () {
                // changeScreen(context, Electronics());
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Electronics()));
              }),
              headerCategoryItem('Cosmetics', Fryo.pencil, onPressed: () {
                // changeScreen(context, Cosmetics());
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Cosmetics()));
              }),
              headerCategoryItem('Fresh Produce', Fryo.leaf, onPressed: () {
                // changeScreen(context, FreshProduce());
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => FreshProduce()));
              }),
            ],
          ),
        ),
      )
    ],
  );
}

Widget headerCategoryItem(String name, IconData icon, {onPressed}) {
  return Container(
    margin: EdgeInsets.only(left: 15),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(bottom: 10),
            width: 65,
            height: 65,
            child: FloatingActionButton(
              elevation: 0.5,
              shape: CircleBorder(),
              heroTag: name,
              onPressed: onPressed,
              backgroundColor: Colors.white,
              child: Icon(icon, size: 30, color: Colors.black87),
            )),
        Text(name,
            style: TextStyle(
              color: Colors.black,
              fontSize: 19,
              fontWeight: FontWeight.w200,
            ))
      ],
    ),
  );
}
