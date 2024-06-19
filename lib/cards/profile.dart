import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matrinomy/cards/meessagecard.dart';
import 'package:matrinomy/main_page/follower.dart';
import 'package:matrinomy/model/usermodel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../global/drawer.dart';
import '../main_page/premium.dart';
import '../provider/declare.dart';

class Profile extends StatelessWidget {
  UserModel user;
  Profile({super.key, required this.user});
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
                        "Following": FieldValue.arrayUnion([user.uid]),
                      });
                  await FirebaseFirestore.instance
                      .collection("Users")
                      .doc(user.uid)
                      .update(
                      {
                        "Followers": FieldValue.arrayUnion([g]),
                      });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("You are now Following " + user.Name),
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
                  await FirebaseFirestore.instance.collection("Users").doc(user.uid).update(
                      {
                        "Like": FieldValue.arrayUnion([g]),
                      });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text( user.Name + " added to Like Section"),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(user: user),
                    ),
                  );
                },
                icon: Icon(Icons.chat, color: Colors.white),
              ),
            ),
            CircleAvatar(
              backgroundColor:Color(0xffE9075B),
              radius: 30,
              child: IconButton(
                onPressed: () async {
                  await FirebaseFirestore.instance.collection("Users").doc(user.uid).update(
                      {
                        "Passed": FieldValue.arrayUnion([g]),
                      });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text( user.Name + " will not be showed from now on"),
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

                  await FirebaseFirestore.instance.collection("Users").doc(user.uid).update(
                      {
                        "Block": FieldValue.arrayUnion([g]),
                      });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text( user.Name + " blocked"),
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
                  image: NetworkImage(user.pic),
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
                              if ( _user!.premium ) {
                                final Uri _url = Uri.parse(
                                    "tell:${user.phone}" );
                                if (!await launchUrl(_url)) {
                                  throw Exception('Could not launch $_url');
                                }
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
                             if ( _user!.premium ) {
                               final Uri _url = Uri.parse(
                                   "mailto:${user.Email}" );
                               if (!await launchUrl(_url)) {
                              throw Exception('Could not launch $_url');
                              }
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
                              child : Icon(Icons.mail, color : Colors.white),
                            ),
                          ),
                          SizedBox(width : 15),
                        ]

                    ),
                    SizedBox(height: 330),
                    Container(
                      height: MediaQuery.of(context).size.height + 100,
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
                              user.Name,
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
                                          "Following": FieldValue.arrayUnion([user.uid]),
                                        });
                                    await FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(user.uid)
                                        .update(
                                        {
                                          "Followers": FieldValue.arrayUnion([g]),
                                        });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Success ! Now following ' + user.Name) ,
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                    },
                                  child: sd(context, "Follow me", user.follower.contains([g]))),
                              InkWell(
                                  onTap : () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Follower(b : true, yu : user.uid)),
                                    );

                                  },
                                  child: InkWell(child: sd(context, "My Followers", true))),
                              InkWell(
                                  onTap : (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Follower(b : false, yu : user.uid)),
                                    );
                                  },
                                  child: sd(context, "My Following", true)),
                            ],
                          ),
                          SizedBox(height: 28),
                          r1(0, "Lives In", user.address, context),
                          r(1, user.looking, ""),
                          r(2, user.height, ""),
                          r(3, user.weight, ""),
                          divide(),
                          r(4, "Looking For ", " "),
                          t(user.looking),
                          divide(),
                          r(5, "About Me", " "),
                          t(user.work),
                          divide(),
                          r(6, "Gender", " "),
                          t(user.gender),
                          divide(),
                          r(7, "Interests", " "),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: List.generate(
                                user.hobbies.length,
                                    (index) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: sd(context, user.hobbies[index], false),
                                ),
                              ),
                            ),
                          ),
                          divide(),
                          r(8, "Education", " "),
                          t(user.education),
                          divide(),
                          r(9, "Drinking", " "),
                          t(user.drink),
                          divide(),
                          r(10, "Smoking", " "),
                          t(user.smoke),
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

  Widget t (String hj){
    return Padding(
      padding: const EdgeInsets.only( left : 18.0, top : 9),
      child: Text("$hj " ),
    );
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
