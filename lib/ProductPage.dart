import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'HomePageThings/Cart.dart';

class ProductPage extends StatefulWidget {
  String product_name;
  String product_discountedPrice;
  String product_price;
  String ISBN;
  ProductPage(  {Key key, @required this.product_name, @required this.product_discountedPrice, this.product_price,@required this.ISBN})
      : super(key: key);
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String groupValue='New';
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  User user=FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    CollectionReference products=FirebaseFirestore.instance.collection('Product').doc(widget.ISBN).collection('Extra Details');
    return   StreamBuilder<DocumentSnapshot>(
        stream: products.doc(widget.ISBN).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.waiting||snapshot.hasData!=true) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,),
              ),
            );
          }
          Map<String, dynamic> data = snapshot.data.data();
          return Scaffold(
            backgroundColor: Colors.grey,
            appBar: AppBar(
              backgroundColor: Colors.blue,
              title: Text('Pustak Boy'),
              actions: [
                IconButton(icon: Icon(Icons.share), onPressed: (){
                  String text='Checkout ${widget.product_name} by ${data['Author']} at such a low price ${widget.product_discountedPrice}';
                  Share.share(text);
                }),
                IconButton(icon: Icon(Icons.shopping_cart), onPressed: (){
                  Navigator.push(context,  MaterialPageRoute(
                      builder: (context) =>   Cart()));
                })
              ]
              ),
            body: Column(
              children:<Widget> [
                Padding(
                  padding: EdgeInsets.only(top: 32.0,left: 16.0
                  ),
                  child: Text(widget.product_name,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(
                    child: Icon(Icons.book,
                    size: 150.0,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(16.0),
                child:Text('ISBN: ${widget.ISBN}'),),
                Padding(
                  padding: EdgeInsets.all(16.0),
                    child: Text('Author: ${data['Author']}',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500
                    ),)),
                Padding(
                  padding: EdgeInsets.all(16.0),
                    child: Text('Subject: ${data['Subject']}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 25.0
                    ),
                    )),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                        children:<Widget>[ Text(widget.product_discountedPrice,
                          style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 40.0
                          ),
                        ),
                          Text(widget.product_price==null?'':widget.product_price,
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                              fontSize: 18.0
                            ),

                          )
                        ]
                    ),
                ),
                RadioListTile(value: 'New', groupValue: groupValue, onChanged: (current){
                  onChanged(current);
                },
                  title: Text('New'),
                ),
                RadioListTile(value: 'Old', groupValue: groupValue, onChanged: (current){ onChanged(current);
                },
                title: Text('Old'),
                ),
                RadioListTile(value: 'Very Old', groupValue: groupValue, onChanged: (current){ onChanged(current);
                },
                  title: Text('Very '
                      'Old'),
                )
            ],
            ),
            bottomNavigationBar: FlatButton(
              onPressed: () async {
            QuerySnapshot Book = await FirebaseFirestore
                .instance
                .collection('Users').doc(user.uid).collection('Cart').where(
                'ISBN',isEqualTo: widget.ISBN).where('Quality',isEqualTo: groupValue).get();
            List<DocumentSnapshot> BookDocument = Book.docs;
            if(BookDocument.length==0){
                  await _firestore.collection('Users')
                      .doc(user.uid).collection('Cart').doc(widget.ISBN+groupValue)
                      .set({
                    'ISBN': widget.ISBN,
                    'Name': widget.product_name,
                    'Current Price': widget.product_discountedPrice,
                    'Quality': groupValue,
                  });
                  Fluttertoast.showToast(msg: 'Successful added to Cart');
                }
                else{
                  Fluttertoast.showToast(msg: 'Already added');
                }
              },
              child: Text('Add to Cart'),
              color: Colors.orange,
            ),
          );
        }
    );
  }
  onChanged(current){
    setState(() {
      groupValue=current;
    });
  }
}

