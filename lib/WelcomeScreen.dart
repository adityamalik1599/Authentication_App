import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:authentication_app/PhoneVerification.dart';
class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          child: Text('SignOut'),
          color: Colors.green,
          onPressed: (){
            _byebye();
          },
        ),
      ),
    );
  }
  Future<void> _byebye() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(context, 
      MaterialPageRoute(builder: (context)=>PhoneVerification())
    );
    
  }
}
