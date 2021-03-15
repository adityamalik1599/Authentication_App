import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../ProductPage.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  int total=0;
  User user=FirebaseAuth.instance.currentUser;
  CollectionReference cart=FirebaseFirestore.instance.collection('Users');
  @override
  void initState() {
    getTotal();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: cart.doc(user.uid).collection('Cart').snapshots(),
        builder:
            (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.waiting||snapshot.hasData!=true){
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(backgroundColor: Colors.black,),
              ),
            );
          }
          else{
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue,
                title: Text('Cart'),
              ),
              body: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.all(12.0),
                         child: Container(
                         color: Colors.grey,
                          child: Column(
                           children: <Widget>[
                             InkWell(
                               onTap: (){
                                Navigator.push(context,   MaterialPageRoute(builder: (context) =>
                                ProductPage(product_name: snapshot.data.docs[index].get('Name'),product_discountedPrice: snapshot.data.docs[index].get('Current Price'),ISBN: snapshot.data.docs[index].get('ISBN'))));
                                  },
                                   child: ListTile(
                                    leading: Icon(Icons.book,
                                     size: 35.0,
                                    ),
                                     title: Text(snapshot.data.docs[index].get('Name'),
                                     style: TextStyle(
                                     fontWeight: FontWeight.bold
                                      )
                                     ),
                                      subtitle: Text(snapshot.data.docs[index].get('Quality')),
                                       trailing: Text(snapshot.data.docs[index].get('Current Price'),
                                       style: TextStyle(
                                       fontWeight: FontWeight.w500,
                                         fontSize: 16.0
                                      ),
                                     ),
                                    ),
                                   ),
                                  Padding(
                                   padding: EdgeInsets.only(left: 16.0, right: 16.0),
                                    child: FlatButton(
                                     onPressed: () async {
                                       setState(() {
                                         total=total-int.parse(snapshot.data.docs[index].get('Current Price'));
                                       });
                                      cart.doc(user.uid).collection('Cart').doc(snapshot.data.docs[index].get('ISBN')+snapshot.data.docs[index].get('Quality')).delete();
                                         },
                                      minWidth: double.infinity,
                                      color: Colors.orange,
                                       child: Text('Remove'),
                                         ),
                                        )
                                      ]
                                     )
                                    ),
                                  );
                                }
                  ),
                bottomNavigationBar:
                Container(
                  color: Colors.orange,
                  child: ListTile(
                    leading: Icon(Icons.money),
                    title: Text('Total Amount'),
                    subtitle: Text(total.toString()),
                    trailing: FlatButton(
                      onPressed: (){},
                      color: Colors.blue,
                      child: Text('CheckOut'),
                    ),
                  ),
                )
              );
          }
        }
    );
  }
  Future<String> getTotal() async{
    QuerySnapshot documentsAddedtoCart= await FirebaseFirestore.instance.collection('Users').doc(user.uid).collection('Cart').get();
    documentsAddedtoCart.docs.forEach((document) {
      Map<String, dynamic> data = document.data();
      setState(() {
        total=total+int.parse(data['Current Price']);
        return total.toString();
      });
    });
  }
}
