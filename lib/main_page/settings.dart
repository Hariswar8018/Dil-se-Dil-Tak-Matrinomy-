import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matrinomy/global/drawer.dart';
import 'package:matrinomy/main.dart';
import 'package:matrinomy/model/usermodel.dart';
import 'package:url_launcher/url_launcher.dart';

class Sett extends StatelessWidget {
  Sett({super.key});

  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Crea
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: Global.as(context),
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            _key.currentState!.openDrawer();
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade400,
              child: Icon(Icons.menu, color: Colors.black),
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Container(
          decoration: BoxDecoration(
            color: Color(0xffE9075B),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 35, right: 35, top: 9, bottom: 9),
            child: Text("Settings",
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 15,
          ),
          InkWell(
              onTap: () async {
                final Uri _url = Uri.parse('https://www.privacypolicyonline.com/live.php?token=zw7ZCaGXXhXlX2Z2Arq3rjgxvsiwZnAh');
                if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                }
              },
              child: r(context, "Code of Conduct")),
          SizedBox(
            height: 15,
          ),
          InkWell(
              onTap: () async {
                final Uri _url = Uri.parse(
                    'https://www.termsandconditionsgenerator.com/live.php?token=a4iUyjcZRti1Lp0EfQtyBZAzcJ53IvSj');
                if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                }
              },
              child: r(context, "Terms of Use")),
          SizedBox(
            height: 15,
          ),
          InkWell(
              onTap: () async {
                final Uri _url = Uri.parse(
                    'https://www.privacypolicyonline.com/live.php?token=zw7ZCaGXXhXlX2Z2Arq3rjgxvsiwZnAh');
                if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                }
              },
              child: r(context, "Privacy Policy")),
          SizedBox(
            height: 15,
          ),
          r(context, "About Us"),
          SizedBox(
            height: 23,
          ),
          InkWell(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(),
                  ),
                );
              },
              child: t(context, "Log Out", true)),
          SizedBox(
            height: 15,
          ),
          InkWell(
              onTap: () async {
                String io = FirebaseAuth.instance.currentUser!.uid;
                await FirebaseFirestore.instance
                    .collection("Users")
                    .doc(io)
                    .delete();
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(),
                  ),
                );
              },
              child: t(context, "Delete Account", false)),
        ],
      ),
    );
  }

  Widget r(BuildContext context, String str) {
    return Center(
      child: Container(
          width: MediaQuery.of(context).size.width - 50,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white, // Background color of the container
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(17.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  str,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 25),
              ],
            ),
          )),
    );
  }

  Widget t(BuildContext context, String str, bool b) {
    return Center(
      child: Container(
          width: MediaQuery.of(context).size.width - 50,
          height: 60,
          decoration: BoxDecoration(
            color: Color(0xffE9075B), // Background color of the container
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Shadow color
                spreadRadius: 5, // Spread radius
                blurRadius: 7, // Blur radius
                offset: Offset(0, 3), // Shadow position
              ),
            ],
          ),
          child: Padding(
              padding: const EdgeInsets.all(17.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  b
                      ? Icon(Icons.logout, color: Colors.white)
                      : Icon(Icons.delete, color: Colors.white),
                  Text(str, style: TextStyle(color: Colors.white)),
                ],
              ))),
    );
  }
}
