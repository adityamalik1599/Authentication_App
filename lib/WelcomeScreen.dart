import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:authentication_app/PhoneVerification.dart';
import 'package:shared_preferences/shared_preferences.dart';
class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    String uid = FirebaseAuth.instance.currentUser.uid;
    return StreamBuilder<DocumentSnapshot>(
      stream: users.doc(uid).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("loading");
        }
          Map<String, dynamic> data = snapshot.data.data();
          return Scaffold(
            appBar: AppBar(title: Text('Profile'),
            ),
            body: Container(
              child: Center(child: Text('Hello')),
            ),
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  DrawerHeader(
                      child: Container(
                       child:Icon(Icons.account_circle),
                      )
                  ),
                  ListTile(
                    leading: Icon(Icons.person), title: Text(data['Name']),),
                  ListTile(
                    leading: Icon(Icons.email), title: Text(data['Email']),),
                  ListTile(
                    leading: Icon(Icons.phone), title: Text(data['Number']),),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: RaisedButton(onPressed: ()async{ _byebye();},
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
    SharedPreferences preferences=await SharedPreferences.getInstance();
    preferences.remove('Key');
    await FirebaseAuth.instance.signOut();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => PhoneVerification()

        )
    );
  }
}

