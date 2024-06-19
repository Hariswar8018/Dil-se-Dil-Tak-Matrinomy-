import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../cards/profile.dart';
import '../global/drawer.dart';
import '../model/usermodel.dart';

class Follower extends StatelessWidget {
  bool b;
  String yu;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List<UserModel> _list = [];
  Follower({super.key, required this.b, required this.yu});
  String g = FirebaseAuth.instance.currentUser!.uid;

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
            child: Text(b ? "My Following" : "My Followers",
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: b
                  ? FirebaseFirestore.instance
                  .collection('Users')
                  .where("Followers", arrayContains: yu)
                  .snapshots()
                  : FirebaseFirestore.instance
                  .collection('Users')
                  .where("Following", arrayContains: yu)
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
                          "Looks Likes No one is following",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "We will still wait for someone you would block or Pass",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  );
                }
                final data = snapshot.data?.docs;
                _list.clear();
                _list.addAll(
                    data?.map((e) => UserModel.fromJson(e.data())).toList() ??
                        []);
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
          ),
        ],
      ),
    );
  }
}

class ChatUserr extends StatelessWidget {
  UserModel user;
  bool b;
  ChatUserr({super.key, required this.user, required this.b});
  String g = FirebaseAuth.instance.currentUser!.uid;
  a() {
    if (g == user.uid) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Profile(user: user)),
        );
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.pic),
      ),
      title: Text(user.Name,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
      subtitle: Text(user.lastlogin),
      trailing: b && a()
          ? InkWell(
        onTap: () async {
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(g)
              .update({
            "Following": FieldValue.arrayRemove([user.uid]),
          });
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(user.uid)
              .update({
            "Followers": FieldValue.arrayRemove([g]),
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 3 - 20,
          height: 30,
          decoration: BoxDecoration(
              color: Colors.white70, // Background color of the container
              borderRadius: BorderRadius.circular(10.0), // Rounded corners
              border: Border.all(
                  color: Color(0xffE9075B), width: 2 // Border color and width
              )),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Center(child: Text("Remove")),
          ),
        ),
      )
          : Container(
        width: MediaQuery.of(context).size.width / 3 - 20,
        height: 30,
        decoration: BoxDecoration(
            color: Colors.white70, // Background color of the container
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
            border: Border.all(
                color: Color(0xffE9075B), width: 2 // Border color and width
            )),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Center(child: Text("See Profile")),
        ),
      ),
    );
  }
}
