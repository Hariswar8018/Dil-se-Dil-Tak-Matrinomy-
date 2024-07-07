import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:matrinomy/first/step/info.dart';
import 'package:matrinomy/global/notification.dart';

import 'package:otp_text_field_v2/otp_field_v2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:matrinomy/first/login2.dart';
import 'package:matrinomy/main_page/main_page.dart';
import 'package:matrinomy/model/usermodel.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final TextEditingController _ref = TextEditingController();
  String s = "Demo";
  String d = "Demo";
  bool round = false ;
  @override
  void dispose() {
    _emailController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool on = false;
  String var1 = " ";
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show the alert dialog and wait for a result
        bool exit = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Exit App'),
              content: Text('Are you sure you want to exit?'),
              actions: [
                ElevatedButton(
                  child: Text('No'),
                  onPressed: () {
                    // Return false to prevent the app from exiting
                    Navigator.of(context).pop(false);
                  },
                ),
                ElevatedButton(
                  child: Text('Yes'),
                  onPressed: () {
                    // Return true to allow the app to exit
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        );

        // Return the result to handle the back button press
        return exit ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,  backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("  Let's get Started",
                  style: TextStyle(fontSize: 29, fontWeight: FontWeight.w800)),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                    "Type your Phone Number, and We will send you Confirmation Code",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              ),
              SizedBox(
                height: 40,
             ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width : 100  , height : 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100, // Background color of the container
                              borderRadius: BorderRadius.circular(15.0), // Rounded corners
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only( left : 10.0),
                              child: IntlPhoneField(
                                decoration: InputDecoration(
                                  labelText: 'Phone Number',
                                  isDense: true, enabled : false ,
                                  border: InputBorder.none, // No border
                                ),
                                initialCountryCode: 'IN',
                                onChanged: (phone) {
                                  print(phone.completeNumber);
                                }, readOnly: true, disableLengthCheck: true,
                              ),
                            ),
                          ),
                          SizedBox(width : 10),
                          Container(
                            width : MediaQuery.of(context).size.width - 150  , height : 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100, // Background color of the container
                              borderRadius: BorderRadius.circular(15.0), // Rounded corners
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only( left :10, right : 18.0),
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                decoration: InputDecoration(
                                  labelText: 'Your Phone Number',
                                  isDense: true,
                                  enabled: !on,
                                  border: InputBorder.none, // No border
                                  counterText: '', // Remove the character counter text
                                ),
                              )
                            ),
                          ),
                        ],
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width : MediaQuery.of(context).size.width  , height : 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100, // Background color of the container
                    borderRadius: BorderRadius.circular(15.0), // Rounded corners
                  ),
                  child: Padding(
                      padding: const EdgeInsets.only( left :10, right : 18.0),
                      child: TextFormField(
                        controller: _ref,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: InputDecoration(
                          labelText: 'Referral Code ( Optional )',
                          isDense: true,
                          enabled: !on,
                          border: InputBorder.none, // No border
                          counterText: '', // Remove the character counter text
                        ),
                      )
                  ),
                ),
              ),
              SizedBox(
                height: 18,
              ),
                    round ? Center(child: CircularProgressIndicator()) :  Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: SocialLoginButton(
                      backgroundColor: Color(0xffE9075B),
                      height: 40,
                      text: 'SEND OTP',
                      borderRadius: 20,
                      fontSize: 21,
                      buttonType: SocialLoginButtonType.generalLogin,
                      onPressed: () async {
                        setState((){
                          round = true ;
                        });
                        if (_emailController.text.length == 10) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Please wait ! We are verfying you are not a robot'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                          try {
                            await _auth.verifyPhoneNumber(
                              phoneNumber: "+91" + _emailController.text,
                              verificationCompleted:
                                  (PhoneAuthCredential credential) async {
                                await _auth.signInWithCredential(credential);
                                String uid =
                                    FirebaseAuth.instance.currentUser!.uid;

                              },
                              verificationFailed: (FirebaseAuthException e) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content:
                                        Text('${e}'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                    print(
                                        'Verification failed: ${e.message}');
                                  },
                                  codeSent: (String verificationId,
                                      int? resendToken) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Code sent to your number'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                    Navigator.push(
                                        context, PageTransition(
                                        child: Step2(var1: verificationId,
                                          phone: _emailController.text,),
                                        type: PageTransitionType.leftToRight,
                                        duration: Duration(milliseconds: 300)
                                    ));
                                    print(
                                        'Verification ID: $verificationId');
                                  },
                                  codeAutoRetrievalTimeout:
                                      (String verificationId) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text('Code time out '),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                    // Auto-retrieval of the SMS code timed out.
                                    // Handle the situation by manually verifying the code.
                                    print(
                                        'Auto Retrieval Timeout. Verification ID: $verificationId');
                                  },
                                );
                            setState((){
                              round = false ;
                            });
                              } catch (e) {
                            setState((){
                              round = false ;
                            });
                                print(
                                    'Error sending verification code: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${e}'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            } else {
                          setState((){
                            round = false ;
                          });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Type 10 digit number'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }

                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
              Center(child: Text("OR")),
              SizedBox(
                height: 10,
              ),
              round ? Center(child: CircularProgressIndicator()) :  Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: SocialLoginButton(
                    backgroundColor: Colors.blue.shade100,
                    height: 40,
                    text: 'Login by Google',
                    borderRadius: 20,
                    fontSize: 21,
                    buttonType: SocialLoginButtonType.google,
                    onPressed: () async {
                      setState((){
                        round = true ;
                      });
                      try {
                        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
                        final GoogleSignInAuthentication googleAuth = await googleUser!
                            .authentication;
                        final AuthCredential credential = GoogleAuthProvider
                            .credential(
                          accessToken: googleAuth.accessToken,
                          idToken: googleAuth.idToken,
                        );
                        await FirebaseAuth.instance.signInWithCredential(credential);
                        String uid= await FirebaseAuth.instance.currentUser!.uid;
                        nowsend(uid);
                        setState((){
                          round =false ;
                        });
                      }catch(e){
                        print(e);
                        Send.message(context, "$e", false);
                        setState((){
                          round =false ;
                        });
                      }

                    }),
              ),
              SizedBox(
                height: 10,
              ),
                  ],
          ),
        ),
      ),
    );
  }
  void nowsend (String uid ) async {
    String uidToSearch = uid; // Replace with the actual uid you want to search

    UserModel? user2 = await getUserByUid(uidToSearch);

    if (user2 != null) {
      print("User found: His Name }");
      await FirebaseFirestore.instance.collection("Users").doc(uid).update({
        "phone" : "None",
      });
      Navigator.push(
          context, PageTransition(
          child: Home(), type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 300)
      ));
    } else {
      Navigator.push(
          context, PageTransition(
          child: Step1(phone : "NONE"), type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 300)
      ));
    }
  }
  Future<UserModel?> getUserByUid(String uid) async {
    try {
      // Reference to the 'users' collection
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');
      // Query the collection based on uid
      QuerySnapshot querySnapshot = await usersCollection.where('uid', isEqualTo: uid).get();
      // Check if a document with the given uid exists
      if (querySnapshot.docs.isNotEmpty) {
        // Convert the document snapshot to a UserModel
        UserModel user = UserModel.fromSnap(querySnapshot.docs.first);
        return user;
      } else {
        // No document found with the given uid
        return null;
      }
    } catch (e) {
      print("Error fetching user by uid: $e");
      return null;
    }
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void verifyPhoneNumber(String phoneNumber) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {

    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print('Phone verification failed: ${authException.message}');
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      String smsCode = '...'; // Get the SMS code from the user.
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      // Sign in with the credential.
      await _auth.signInWithCredential(credential);
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      // Auto retrieval timeout.
    };

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

}

