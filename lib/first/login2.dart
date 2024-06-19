import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matrinomy/first/step/info.dart';
import 'package:matrinomy/main_page/main_page.dart';
import 'package:matrinomy/model/usermodel.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_login_buttons/social_login_buttons.dart';


class Step2 extends StatefulWidget {
  String var1, phone ;
  Step2({required this.var1, required this.phone});
  @override
  _Step2State createState() => _Step2State();
}

class _Step2State extends State<Step2> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,  backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("  6 Digit Code",
                style: TextStyle(fontSize: 29, fontWeight: FontWeight.w800)),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                  "We have sent 6 digit code to your Number",
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            ),
            SizedBox(
              height: 40,
            ),



                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: OTPTextFieldV2(
                      length: 6,
                      width: MediaQuery.of(context).size.width,
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldWidth: 50,
                      fieldStyle: FieldStyle.box,
                      outlineBorderRadius: 35,
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w800),
                      onChanged: (pin) {
                        print("Changed: " + pin);
                      },
                      onCompleted: (pin) async {
                        print("Completed: " + pin);
                        String smsCode = pin;
                        PhoneAuthCredential credential = PhoneAuthProvider.credential(
                            verificationId: widget.var1,
                            smsCode: smsCode
                        );
                        try {
                          await _auth.signInWithCredential(credential);
                          String uid = FirebaseAuth.instance.currentUser!.uid ;
                          nowsend(uid);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Verification Failed ! Please use again'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                          print('Error signing in: $e');
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 11),
                    child: Row(
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: 3.0,
                        ),
                        SizedBox(width: 15),
                        Text("We are auto verifying your OTP",
                            style: TextStyle(fontSize: 15))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
          ],
        ),
      ),
    );
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

  void nowsend (String uid ) async {
    String uidToSearch = uid; // Replace with the actual uid you want to search

    UserModel? user2 = await getUserByUid(uidToSearch);

    if (user2 != null) {
      print("User found: His Name }");
      await FirebaseFirestore.instance.collection("Users").doc(uid).update({
        "phone" : widget.phone,
      });
      Navigator.push(
          context, PageTransition(
          child: Home(), type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 300)
      ));
    } else {
      Navigator.push(
          context, PageTransition(
          child: Step1(phone : widget.phone), type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 300)
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
}

class NewU extends StatelessWidget {
  const NewU({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body : Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children : [
              Spacer(),
              Image.network("https://previews.123rf.com/images/qualitdesign/qualitdesign1904/qualitdesign190400019/124007527-five-happy-friends-make-selfie-photo-friendship-vector-flat-illustration-young-people-have-a-fun.jpg"),
              SizedBox( height : 20),
              Text( textAlign : TextAlign.center , "Your Account Created Successfully", style : TextStyle ( fontSize:  29, fontWeight: FontWeight.w800)),
              SizedBox( height : 8),
              Text( textAlign : TextAlign.center ,"Now place order for your Products, pay, and get your products deliver at home, It is that simple !", style : TextStyle ( fontSize:  18, fontWeight: FontWeight.w400)),
              SizedBox( height : 18),
              ElevatedButton(onPressed: (){
                Navigator.push(
                    context, PageTransition(
                    child: Home(), type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 300)
                ));
              }, child: Text("Continue", style : TextStyle ( fontSize:  25))),
              Spacer(),
            ]
        )
    );
  }
}
