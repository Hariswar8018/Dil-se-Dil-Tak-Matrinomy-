import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matrinomy/global/drawer.dart';
import 'package:matrinomy/model/usermodel.dart';

class BlockedPassed extends StatelessWidget {
 BlockedPassed({super.key, required this.b});
 bool b ;
  List<UserModel> _list = [];
 String yu = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Crea
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: Global.as(context),
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
            child: Text( b? "Blocked" : "Passed",
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: b ? FirebaseFirestore.instance
            .collection('Users')
            .where("Block", arrayContains: yu)
            .snapshots() : FirebaseFirestore.instance
            .collection('Users')
            .where("Passed", arrayContains: yu)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No Block / Passed Users",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "We will still wait for someone you would block or Pass",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }

          final data = snapshot.data?.docs;
          _list.clear();
          _list.addAll(data?.map((e) => UserModel.fromJson(e.data())).toList() ?? []);

          return ListView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return ChatUserr(user: _list[index], b: b);
            },
          );
        },
      ),
    );
  }
}
class ChatUserr extends StatelessWidget {
  UserModel user ; bool b ;
 ChatUserr({super.key, required this.user, required this.b});
  String g = FirebaseAuth.instance.currentUser!.uid ;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.grey.shade50,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.pic),
      ),
      title: Text(user.Name, style : TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
      subtitle: Text(user.lastlogin),
      trailing: InkWell(
        onTap: () async {
          if(b){
            await FirebaseFirestore.instance.collection("Users").doc(user.uid).update(
                {
                  "Block": FieldValue.arrayRemove([g]),
                });
          }else{
            await FirebaseFirestore.instance.collection("Users").doc(user.uid).update(
                {
                  "Passed": FieldValue.arrayRemove([g]),
                });
          }

        },
        child: Container(
          width : MediaQuery.of(context).size.width/3 - 20, height : 30,
          decoration: BoxDecoration(
              color: Colors.white70, // Background color of the container
              borderRadius: BorderRadius.circular(10.0), // Rounded corners
              border: Border.all(color: Color(0xffE9075B), width: 2
              )
          ),
          child : Padding(
            padding: const EdgeInsets.all(3.0),
            child: Center(child: Text("Delete")),
          ),
        ),
      ),
    );
  }
}

