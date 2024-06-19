import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:matrinomy/global/drawer.dart';
import 'package:matrinomy/model/usermodel.dart';
import 'package:matrinomy/provider/declare.dart';

class Up extends StatelessWidget {
  Up({super.key, required this.fireup, required this.number, required this.show });
 TextEditingController _ref = TextEditingController();
  bool number ; String fireup ; String show ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
centerTitle: true,
        title: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xffE9075B),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 35, right: 35, top: 9, bottom: 9),
              child: Text( "Update ",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ),
        ),
        actions: [
          SizedBox(width: 40,),
        ],
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 70,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text("What's your New $show ?", style : TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
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
                    keyboardType: number ? TextInputType.number : TextInputType.text,
                    decoration: InputDecoration(
                      labelText: show,
                      isDense: true,
                      border: InputBorder.none, // No border
                    ),
                  )
              ),
            ),
          ),
          SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18),
            child: SocialLoginButton(
                backgroundColor: Color(0xffE9075B),
                height: 40,
                text: 'UPDATE',
                borderRadius: 20,
                fontSize: 21,
                buttonType: SocialLoginButtonType.generalLogin,
                onPressed: () async {
                  await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                    fireup : _ref.text,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Success ! Changes will take place shortly'),
                      duration: Duration(seconds: 2),
                      // Duration for how long the Snackbar will be visible
                      action: SnackBarAction(
                        label: 'Close',
                        onPressed: () {
                          // Add your action here
                          ScaffoldMessenger.of(context)
                              .hideCurrentSnackBar(); // Hides the current Snackbar
                        },
                      ),
                    ),
                  );
                  Navigator.pop(context);
                  UserProvider _userprovider = Provider.of(context, listen: false);
                  await _userprovider.refreshuser();
                }),
          ),
        ],
      ),
    );
  }
}

