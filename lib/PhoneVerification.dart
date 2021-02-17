import 'package:authentication_app/OTPpage.dart';
import 'package:flutter/material.dart';
import 'package:authentication_app/WelcomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PhoneVerification extends StatefulWidget {
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  String number;
  String nameOfPerson;
  String emailadd;
  final _form = GlobalKey<FormState>();


 /* @override
  void initState() {
    initializeFirebase();
    super.initState();
  }

  void initializeFirebase() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      print('error');
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _form,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  onChanged: (value) {
                    nameOfPerson = value;
                  },
                  textInputAction: TextInputAction.next,
                  validator: (String name) {
                    if (name.isEmpty)
                      return 'Invalid Name';
                    else
                      return null;
                  },
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                TextFormField(
                  onChanged: (value) {
                    emailadd = value;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.start,
                  validator: (String email) {
                    if (EmailValidator.validate(email))
                      return null;
                    else
                      return 'Invalid Email';
                  },
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                TextFormField(
                  onChanged: (value) {
                    number = value;
                  },
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  textAlign: TextAlign.start,
                  validator: (String no) {
                    if (no.length != 10)
                      return 'Invalid Number';
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Mobile No.',
                  ),
                ),
                SizedBox(
                  height: 32.0,
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: MaterialButton(
                    color: Colors.green,
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (_form.currentState.validate())
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OTP(
                                  name: nameOfPerson,
                                  email: emailadd,
                                  number: number)),
                          (Route<dynamic> route) => false,
                        );
                    },
                    child: Text('Send OTP'),
                  ),
                ),
                SizedBox(
                  height: 64.0,
                ),
                Divider(
                  thickness: 1.0,
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: MaterialButton(
                    color: Colors.blue,
                    onPressed: () {
                      _signInWithGoogle();
                    },
                    child: Text('Sign in with Google'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    FirebaseAuth _firebase = FirebaseAuth.instance;
    FirebaseFirestore _firestore=FirebaseFirestore.instance;
    final GoogleSignInAccount googleSignInAccount = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final UserCredential authResult =
        await _firebase.signInWithCredential(credential);
    final User user = authResult.user;
    if (user != null) {
      await  _firestore.collection('Users').doc(user.uid).set({
        'Name':user.displayName,
        'Email':user.email,
        'Number':user.phoneNumber
      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      print('error');
    }
  }
}



//