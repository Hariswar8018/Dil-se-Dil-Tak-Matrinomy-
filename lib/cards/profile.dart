import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matrinomy/cards/meessagecard.dart';
import 'package:matrinomy/global/notification.dart';
import 'package:matrinomy/main_page/follower.dart';
import 'package:matrinomy/model/usermodel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:matrinomy/cards/meessagecard.dart';
import 'package:matrinomy/global/drawer.dart';
import 'package:matrinomy/main_page/premium.dart';
import 'package:matrinomy/provider/declare.dart';
import 'package:provider/provider.dart';
import 'package:matrinomy/main_page/call/video.dart';
import '../model/usermodel.dart';
import '../model/messagw.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../global/drawer.dart';
import '../main_page/premium.dart';
import '../provider/declare.dart';

class Profile extends StatefulWidget {
  UserModel user;
  Profile({super.key, required this.user});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void vq() async {
    UserProvider _userprovider = Provider.of(context, listen: false);
    await _userprovider.refreshuser();
  }

  bool check(){
    vq();
    UserModel? _user = Provider.of<UserProvider>(context, listen: false).getUser;
    if(_user!.premium){
      return true;
    } else {
      DateTime storedDateTime = DateTime.parse(_user!.lastp);
      DateTime currentDateTime = DateTime.now();
      print("$storedDateTime $currentDateTime");
      Duration difference = currentDateTime.difference(storedDateTime);
      return difference.inMinutes <= 30;
    }
  }

String g = FirebaseAuth.instance.currentUser!.uid ;

  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      bottomSheet :Padding(
        padding: EdgeInsets.all(14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              backgroundColor: Color(0xffE9075B),
              radius: 30,
              child: IconButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("Users")
                      .doc(g)
                      .update(
                      {
                        "Following": FieldValue.arrayUnion([widget.user.uid]),
                      });
                  await FirebaseFirestore.instance
                      .collection("Users")
                      .doc(widget.user.uid)
                      .update(
                      {
                        "Followers": FieldValue.arrayUnion([g]),
                      });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("You are now Following " + widget.user.Name),
                    ),
                  );
                },
                icon: Icon(Icons.people, color: Colors.white),
              ),
            ),
            CircleAvatar(
              backgroundColor: Color(0xffE9075B),
              radius: 30,
              child: IconButton(
                onPressed: () async {
                  // Navigate to the new page with the selected user
                  await FirebaseFirestore.instance.collection("Users").doc(widget.user.uid).update(
                      {
                        "Like": FieldValue.arrayUnion([g]),
                      });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text( widget.user.Name + " added to Like Section"),
                    ),
                  );
                },
                icon: Icon(Icons.favorite, color: Colors.white),
              ),
            ),
            CircleAvatar(
              backgroundColor:Color(0xffE9075B),
              radius: 30,
              child: IconButton(
                onPressed: () async {
                  if(check()){
                    Navigator.push(
                        context, PageTransition(
                        child: ChatPage(user: widget.user,), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 400)
                    ));
                  }else{
                    Navigator.push(
                        context, PageTransition(
                        child: Premium(), type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 100)
                    ));
                  }
                },
                icon: Icon(Icons.chat, color: Colors.white),
              ),
            ),
            CircleAvatar(
              backgroundColor:Color(0xffE9075B),
              radius: 30,
              child: IconButton(
                onPressed: () async {
                  await FirebaseFirestore.instance.collection("Users").doc(widget.user.uid).update(
                      {
                        "Passed": FieldValue.arrayUnion([g]),
                      });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text( widget.user.Name + " will not be showed from now on"),
                    ),
                  );
                },
                icon: Icon(Icons.thumb_down, color: Colors.white),
              ),
            ),
            CircleAvatar(
              backgroundColor: Color(0xffE9075B),
              radius: 30,
              child: IconButton(
                onPressed: () async {

                  await FirebaseFirestore.instance.collection("Users").doc(widget.user.uid).update(
                      {
                        "Block": FieldValue.arrayUnion([g]),
                      });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text( widget.user.Name + " blocked"),
                    ),
                  );
                },
                icon: Icon(Icons.block, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.user.pic),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height : 70),
                    Row(
                        children : [
                          Spacer(),
                          InkWell(
                            onTap : () async {
                              if (check() ) {
                                showYesNoDialog( context,false);
                              }else{
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Premium()),
                                );
                              }
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.green,
                              child : Icon(Icons.add_call, color : Colors.white),
                            ),
                          ),
                          SizedBox(width : 15),
                        ]

                    ),SizedBox(height : 10),
                    Row(
                        children : [
                          Spacer(),
                          InkWell(
                            onTap : () async {
                             if ( check()) {
                               showYesNoDialog( context,true);
                             }else{
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context) => Premium()),
                               );
                             }
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.red,
                              child : Icon(Icons.video_call, color : Colors.white),
                            ),
                          ),
                          SizedBox(width : 15),
                        ]

                    ),
                    SizedBox(height: 330),
                    Container(
                      height: MediaQuery.of(context).size.height + 400,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                width: 80,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Text(
                              widget.user.Name,
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                  onTap : () async {
                                    await FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(g)
                                        .update(
                                        {
                                          "Following": FieldValue.arrayUnion([widget.user.uid]),
                                        });
                                    await FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(widget.user.uid)
                                        .update(
                                        {
                                          "Followers": FieldValue.arrayUnion([g]),
                                        });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Success ! Now following ' + widget.user.Name) ,
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                    },
                                  child: sd(context, "Follow me", widget.user.follower.contains([g]))),
                              InkWell(
                                  onTap : () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Follower(b : true, yu : widget.user.uid)),
                                    );

                                  },
                                  child: InkWell(child: sd(context, "My Followers", true))),
                              InkWell(
                                  onTap : (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Follower(b : false, yu : widget.user.uid)),
                                    );
                                  },
                                  child: sd(context, "My Following", true)),
                            ],
                          ),
                          SizedBox(height: 28),
                          r1(0, "Lives In", widget.user.address, context),
                          r(1, widget.user.looking, ""),
                          r(2, widget.user.height, ""),
                          r(3, widget.user.weight, ""),
                          divide(),
                          r(19,"Contact", ""),
                          check()?t(widget.user.Email):t("Email visible for Premium only"),
                          divide(),
                          r(4, "Looking For ", " "),
                          t(widget.user.looking),
                          divide(),
                          r(5, "About Me", " "),
                          t(widget.user.work),
                          divide(),
                          r(6, "Gender", " "),
                          t(widget.user.gender),
                          divide(),
                          r(7, "Interests", " "),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: List.generate(
                                widget.user.hobbies.length,
                                    (index) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: sd(context, widget.user.hobbies[index], false),
                                ),
                              ),
                            ),
                          ),
                          divide(),
                          r(8, "Education", " "),
                          t(widget.user.education),
                          divide(),
                          r(9, "Drinking", " "),
                          t(widget.user.drink),
                          divide(),
                          r(10, "Smoking", " "),
                          t(widget.user.smoke),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void showYesNoDialog(BuildContext context,bool video) {
    UserModel? _user = Provider.of<UserProvider>(context,listen: false).getUser;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(video?'Confirmat to Video Call?':'Confirmat to Voice Call?'),
          content: Text('You have maximum 10 Minutes for each video/voice call session. Confirm to Call? The Other user should also select on Video/Voice Call Icon'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                print('User selected No');
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                js();
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    PageTransition(
                        child: Zegoc(my:_user!, them: widget.user,video:video),
                        type: PageTransitionType.topToBottom,
                        duration: Duration(milliseconds: 800)));
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Widget t (String hj){
    return Padding(
      padding: const EdgeInsets.only( left : 18.0, top : 9),
      child: Text("$hj " ),
    );
  }
  void js(){
    Send.sendNotificationsToTokens(widget.user.Name+" is Calling you","Go to Video/Voice Call to Accept the Call Fast", widget.user.token);
  }
  Widget r(int i, String h, String hj){
    return Row(
      children: [
        SizedBox(width: 10,),
        f(i),
        SizedBox(width: 8,),
        Text("$h " + hj ),
      ],
    );
  }

  Widget r1(int i, String h, String hj, BuildContext context){
    return Row(
      children: [
        SizedBox(width: 10,),
        f(i),
        SizedBox(width: 8,),
        Container(
          width : MediaQuery.of(context).size.width - 70,
            child: Text("$h " + hj )),
      ],
    );
  }

  Widget f (int u){
    if(u == 0 ){
      return Icon(Icons.maps_home_work, color : Color(0xffE9075B));
    }else if ( u == 1){
      return Icon(Icons.directions_walk, color : Color(0xffE9075B));
    }else if ( u  == 2){
      return Icon(Icons.linear_scale, color : Color(0xffE9075B));
    }else if ( u == 3){
      return Icon(Icons.monitor_weight, color : Color(0xffE9075B));
    }else if ( u  == 4){
      return Icon(Icons.emoji_events, color : Color(0xffE9075B));
    }else if ( u == 5){
      return Icon(Icons.work, color : Color(0xffE9075B));
    }else if ( u  == 6){
      return Icon(Icons.transgender, color : Color(0xffE9075B));
    }else if ( u == 7){
      return Icon(Icons.schema, color : Color(0xffE9075B));
    }else if ( u  == 8){
      return Icon(Icons.school, color : Color(0xffE9075B));
    }else if ( u == 9){
      return Icon(Icons.no_drinks, color : Color(0xffE9075B));
    }else if ( u  == 10){
      return Icon(Icons.smoking_rooms, color : Color(0xffE9075B));
    }else if ( u == 11){
      return Icon(Icons.maps_home_work, color : Color(0xffE9075B));
    }else if ( u  == 12){
      return Icon(Icons.maps_home_work, color : Color(0xffE9075B));
    }else if ( u == 13){
      return Icon(Icons.maps_home_work, color : Color(0xffE9075B));
    }else if ( u  == 14){
      return Icon(Icons.maps_home_work, color : Color(0xffE9075B));
    }else if ( u == 15){
      return Icon(Icons.maps_home_work, color : Color(0xffE9075B));
    }else if ( u == 19){
      return Icon(Icons.phone, color : Color(0xffE9075B));
    }else{
      return Icon(Icons.maps_home_work, color : Color(0xffE9075B));
    }
  }

  Widget sd (BuildContext context, String j, bool b){
    return Container(
        width : MediaQuery.of(context).size.width/3 - 20, height : 35,
        decoration: BoxDecoration(
          color: b ? Color(0xffE9075B) : Colors.white70, // Background color of the container
          borderRadius: BorderRadius.circular(10.0), // Rounded corners
          border: Border.all(color: Color(0xffE9075B), width: 2
          )
        ),
        child : Padding(
          padding: const EdgeInsets.all(3.0),
          child: Center(child: Text(j, style :  TextStyle( color : b ? Colors.white : Colors.black)),),
        ),
    );
  }

  Widget divide(){
    return Padding(
      padding: const EdgeInsets.only(top : 10.0, bottom: 2, left: 10, right: 10),
      child: Divider(),
    );
  }
}
