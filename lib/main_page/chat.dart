import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:matrinomy/cards/meessagecard.dart';
import 'package:matrinomy/global/drawer.dart';

import '../model/usermodel.dart';
import '../model/messagw.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);
  @override
  State<Chat> createState() => ChatState();
}


class ChatState extends State<Chat> {



  List<UserModel> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController() ;
  final Fire = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  String yu = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Global.as(context),
      key: _key, // Assign the key to Scaffold.
      backgroundColor: Colors.white,
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
            padding: const EdgeInsets.only(
                left: 35, right: 35, top: 9, bottom: 9),
            child: Text("Chats",
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: Fire.collection('Users').where("Mess", arrayContains: yu).snapshots(),
        builder: ( context,  snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center( child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs ;
              list = data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];
              return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index){
                  return ChatUser(user: list[index],);
                },);
          }
        },
      ),
    );
  }
}







class ChatUser extends StatefulWidget {

  final UserModel user;
  const ChatUser({Key? key, required this.user}) : super(key: key);
  @override
  State<ChatUser> createState() => ChatUserState();
}
class ChatUserState extends State<ChatUser> {



  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.push(
            context, PageTransition(
            child: ChatPage(user: widget.user,), type: PageTransitionType.topToBottom, duration: Duration(milliseconds: 800)

        ));
        String g = DateTime.now().toString();
        await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).update(
            {
              "last": g,
            });
      },
      child: ListTile(
        title: Text(widget.user.Name, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),),
        subtitle: Text(widget.user.Email, maxLines: 1,),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.user.pic),
        ),
        trailing: Text(fo(widget.user.lastlogin)),
      ),
    );
  }
  String fo(String dateTimeString) {
    // Parse the DateTime string
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Get the current date
    DateTime now = DateTime.now();

    // Check if the dateTime is today
    bool isToday = dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;

    // Define date formats
    DateFormat timeFormat = DateFormat('HH:mm');
    DateFormat dateFormat = DateFormat('dd/MM/yy');

    // Return the formatted date
    return isToday ? timeFormat.format(dateTime) : dateFormat.format(dateTime);
  }
}



