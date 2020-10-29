import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Clothing extends StatefulWidget {
  @override
  _ClothingState createState() => _ClothingState();
}

class _ClothingState extends State<Clothing> {
  String _userId;
  User loginUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildStreamElectronics(),
    );
  }

  StreamBuilder<QuerySnapshot> buildStreamElectronics() {
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
          return GridView.builder(
            // scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.docs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.4),
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
            ),
            itemBuilder: (context, index) {
              DocumentSnapshot products = snapshot.data.docs[index];
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                _userId = user.uid;
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.0),
                    height: 160,
                    width: 140,
                    decoration: BoxDecoration(
                        color: Color(0xFFD8D8D8),
                        borderRadius: BorderRadius.circular(16)),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Row(
                      children: [
                        Text(
                          "\R " + products['price'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 60,
                        ),
                        GestureDetector(
                          child: Icon(
                            // CupertinoIcons.cart_fill_badge_plus,
                            Icons.shopping_cart,
                            color: Colors.black,
                            size: 30,
                          ),
                          onTap: () {
                            DocumentReference documentReference =
                                FirebaseFirestore.instance
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                                textAlign: TextAlign.start,
                              ),
                              duration: Duration(milliseconds: 300),
                              backgroundColor: Color(0xFF3D82AE),
                            ));
                          },
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
            // separatorBuilder: (BuildContext context, int index) {
            //   return SizedBox(width: 10);
            // }
          );
        });
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      title: Text(
        "Coin Clothing",
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
}
