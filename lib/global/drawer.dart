import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:matrinomy/main_page/blocked_passed.dart';
import 'package:matrinomy/main_page/chat.dart';
import 'package:matrinomy/main_page/like_nearby_online.dart';
import 'package:matrinomy/main_page/main_page.dart';
import 'package:matrinomy/model/usermodel.dart';
import 'package:matrinomy/provider/declare.dart';

import '../dashboard/myprofile.dart';
import '../main_page/follower.dart';
import '../main_page/premium.dart';
import '../main_page/settings.dart';

class Global{

  static Future<void> Follow(List s, String UserId) async {
    String Myid = FirebaseAuth.instance.currentUser!.uid ;
    if(s.contains([Myid])){
      await FirebaseFirestore.instance.collection("Users").doc(UserId).update(
          {
            "Followers": FieldValue.arrayRemove([Myid]),
          });
      await FirebaseFirestore.instance.collection("Users").doc(Myid).update(
          {
            "Following": FieldValue.arrayRemove([UserId]),
          });
    }else{
      await FirebaseFirestore.instance.collection("Users").doc(UserId).update(
          {
            "Followers": FieldValue.arrayUnion([Myid]),
          });
      await FirebaseFirestore.instance.collection("Users").doc(UserId).update(
          {
            "Following": FieldValue.arrayUnion([Myid]),
          });
    }
  }
  static int index = 0 ;

  static Drawer as(BuildContext context){

    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Drawer(
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50,),
            Container(
              color : Colors.white,
              width: MediaQuery.of(context).size.width,
              child: CircleAvatar(
                radius: 55,
                backgroundImage: NetworkImage(_user!.pic,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(_user.Name, style : TextStyle(fontSize: 27, fontWeight: FontWeight.w600)),
            ),
            TextButton.icon(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Premium()),
              );
            }, label: Text("Get Premium", style : TextStyle(color : Colors.orange)), icon : Icon(Icons.diamond, color : Colors.orange)),
            SizedBox(height : 10 ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap : (){
      Navigator.push(
      context,
      MaterialPageRoute(
      builder: (context) => Follower( b : true,  yu : _user.uid),
      ),
      );
      },
                  child: Container(
                      height: 80, width: 70,
                      child: Column(
                    children: [
                      Text(_user.following.length.toString(), style : TextStyle(fontWeight: FontWeight.w800)),
                      Text("Following", style : TextStyle(fontWeight: FontWeight.w800)),
                    ],
                  )),
                ),
                InkWell(
                  onTap : (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Follower( b : false,  yu : _user.uid),
                      ),
                    );
                  },
                  child: Container(
                      height: 80, width: 70,
                      child: Column(
                        children: [
                          Text(_user.follower.length.toString(), style : TextStyle(fontWeight: FontWeight.w800)),
                          Text("Followers", style : TextStyle(fontWeight: FontWeight.w800)),
                        ],
                      )),
                ),
              ],
            ),
           InkWell(
                onTap: (){

                    index = 0 ;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ),
                    );
                },
                child: s(context, 0, "Explore")
            ),
            InkWell(
                onTap: (){
                    index = 1 ;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Online(likes: false),
                    ),
                  );
                },
                child: s(context, 1, "Online")
            ),
            InkWell(
                onTap: (){
                    index = 2 ;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Nearby(),
                    ),
                  );
                },
                child: s(context, 2, "Nearby")
            ),
            InkWell(
                onTap: (){

                    index =  3;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Online(likes: true,),
                    ),
                  );
                },
                child: s(context, 3, "Likes")
            ),
            InkWell(
                onTap: (){
                    index = 4 ;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Chat(),
                      ),
                    );
                },
                child: s(context, 4, "Chats")
            ),
            InkWell(
                onTap: (){

                    index = 5 ;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyP()),
                  );
                },
                child: s(context, 5, "Profile")
            ),
            InkWell(
                onTap: (){

                    index = 6 ;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlockedPassed(b: true,),
                      ),
                    );
                },
                child: s(context, 6, "Blocked")
            ),
            InkWell(
                onTap: (){

                    index =  7;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlockedPassed(b: false,),
                      ),
                    );
                },
                child: s(context, 7, "Passed")
            ),
            InkWell(
                onTap: (){
                    index =  8;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Sett(),
                      ),
                    );
                },
                child: s(context, 8, "Settings")
            ),
          ],
        ),
      ),
    );
  }
  static Widget s (BuildContext context, int j, String jk){
    return  Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        decoration: BoxDecoration(
          color : index == j ?  Color(0xffE9075B) : Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        width: MediaQuery.of(context).size.width, height: 50,
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                iconn(j),
                SizedBox(width: 10,),
                Center(child: Text(jk, style: TextStyle(color: index == j ? Colors.white : Colors.black, fontSize: 24),)),
              ],
            ),
          ),
        ),
      ),
    );
  }
  static Widget iconn( int j){
    if ( j == 0){
      return  Icon(Icons.card_membership_sharp, color: index == j ? Colors.white : Colors.black,);
    }else if (j == 1){
      return Icon(Icons.language, color: index == j ? Colors.white : Colors.black,);
    }else if ( j == 2){
      return Icon(Icons.add_location, color: index == j ? Colors.white : Colors.black,);
    }else if(j == 3){
      return Icon(Icons.favorite, color: index == j ? Colors.white : Colors.black,);
    }else if ( j == 4){
      return Icon(Icons.mark_chat_read_sharp, color: index == j ? Colors.white : Colors.black,);
    }else if(j == 5){
      return Icon(Icons.person, color: index == j ? Colors.white : Colors.black,);
    }else if ( j == 6){
      return Icon(Icons.block_flipped, color: index == j ? Colors.white : Colors.black,);
    }else if ( j == 7){
      return Icon(Icons.thumb_down_alt_rounded, color: index == j ? Colors.white : Colors.black,);
    }else{
      return Icon(Icons.settings, color: index == j ? Colors.white : Colors.black,);
    }
  }
}