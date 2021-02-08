import 'package:flutter/material.dart';
import 'package:authentication_app/WelcomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
class PhoneVerification  extends StatefulWidget {
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
   String number;
   String smsCode;
   String verificationCode;
   @override
   void initState() {
     initializeFirebase();
    super.initState();
  }
  void initializeFirebase() async{
     try{
       await Firebase.initializeApp();
     }catch(e)
    {
      print('error');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
               onChanged: (value)
                {
                  number=value;
                },
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                hintText: 'Enter your Mobile No.',
               ),
              ),
              SizedBox(
                height: 32.0,
              ),
             Padding(
                padding: EdgeInsets.all(5),
                child: MaterialButton(
                     color: Colors.green,
                    onPressed: (){
               _letsbegin();
                },
                 child:  Text(
                   'Send OTP'
                ),
              ),
             ),
              Padding(
                padding: EdgeInsets.all(5),
                child: MaterialButton(
                  color: Colors.blue,
                  onPressed: (){
                    _signInWithGoogle();
                  },
                  child:  Text(
                      'Sign in with Google'
                  ),
                ),
              ),


            ],

          ),
        ),
      ),
    );
  }
   Future<void> _letsbegin() async
   {
     FirebaseAuth _auth=FirebaseAuth.instance;
     await _auth.verifyPhoneNumber(
         phoneNumber: '+91'+ number,
         timeout: Duration(seconds: 60),
         verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential result= await _auth.signInWithCredential(credential);
          User user=result.user;
          if(user!=null) {
            Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => WelcomeScreen()),
                (Route<dynamic> route)=>false,
            );
          }
          else{
            print('Error');
          }
         },
         verificationFailed: (FirebaseAuthException e) {
           if (e.code == 'invalid-phone-number') {
             print('The provided phone number is not valid.');
           }
         },
         codeSent: (String verificationId, int resendToken)  {
           verificationCode=verificationId;
           showDialog(
               context: context,
               barrierDismissible: false,
               builder: (context){
                 return AlertDialog(
                   title: Text('Enter the OTP'),
                   content: Column(
                     children: <Widget>[
                       TextField(
                          onChanged: (value){
                             smsCode=value;
               },
                         keyboardType: TextInputType.number,
                       ),
                     ],
                   ),
                   actions:<Widget> [
                     FlatButton(
                       child: Text('Verify'),
                       onPressed: () async {
                         PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationCode, smsCode:smsCode);
                         UserCredential result= await _auth.signInWithCredential(phoneAuthCredential);
                         User user=result.user;
                         if(user!=null) {
                           Navigator.pushAndRemoveUntil(context,
                             MaterialPageRoute(builder: (context) => WelcomeScreen()),
                                 (Route<dynamic> route)=>false,
                           );
                         }else{
                           print('Error');
                         }
                       },
                     ),
                   ],
                 );
               }
           );
         },
         codeAutoRetrievalTimeout: (String verificationId) {
           verificationCode=verificationId;
         },
        );
         }
   Future<void>_signInWithGoogle() async {
     FirebaseAuth _firebase=FirebaseAuth.instance;
     final GoogleSignInAccount googleSignInAccount = await GoogleSignIn().signIn();
     final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount
         .authentication;
     final GoogleAuthCredential credential = GoogleAuthProvider.credential(
       accessToken: googleSignInAuthentication.accessToken,
       idToken: googleSignInAuthentication.idToken,
     );
     final UserCredential authResult = await _firebase.signInWithCredential(
         credential);
     final User user = authResult.user;
     if (user != null) {
       Navigator.pushAndRemoveUntil(context,
         MaterialPageRoute(builder: (context)=>WelcomeScreen() ),
           (Route<dynamic> route)=>false,
       );
     }
     else
     {
       print ('error');
     }
   }

}