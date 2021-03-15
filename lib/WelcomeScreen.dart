import 'package:authentication_app/HomePageThings/Cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:authentication_app/PhoneVerification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePageThings/GridItemList.dart';
class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  String uid = FirebaseAuth.instance.currentUser.uid;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return
      StreamBuilder<DocumentSnapshot>(
          stream: users.doc(uid).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
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
              drawerEnableOpenDragGesture: true,

              appBar: AppBar(
                backgroundColor: Colors.blue,
                title: Text('Pustak Boy'),
                actions: [
                  IconButton(icon: Icon(Icons.search), onPressed:(){}),
                  IconButton(icon: Icon(Icons.shopping_cart), onPressed: (){
                    Navigator.push(context,  MaterialPageRoute(
                        builder: (context) =>   Cart() ));
                  })
                ],
              ),
              body: GridItemList(),
              drawer: Drawer(
                child: ListView(
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      accountName: Text(data['Name']),
                      accountEmail: Text(data['Email']),
                      currentAccountPicture: CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, color: Colors.white,)),
                    ),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: RaisedButton(onPressed: () async {
                        _byebye();
                      },
                        color: Colors.blueAccent,
                        child: Text('Logout'),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
      );
  }


  Future<void> _byebye() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('Key');
    await FirebaseAuth.instance.signOut();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => PhoneVerification()

        )
    );
  }
  }

