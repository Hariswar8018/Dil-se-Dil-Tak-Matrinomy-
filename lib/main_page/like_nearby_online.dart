import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matrinomy/cards/profile.dart';
import 'package:matrinomy/global/drawer.dart';
import 'package:matrinomy/model/usermodel.dart';
import 'package:matrinomy/provider/declare.dart';
import 'package:provider/provider.dart';

class Online extends StatelessWidget {
  bool likes  ;
  Online({super.key, required this.likes});

  String f(){
    if(likes){
      return "Likes";
    }else{
      return "Online";
    }
  }
  String yu = FirebaseAuth.instance.currentUser!.uid;
  List<UserModel> _list = [];
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Crea
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
            child: Text(f(),
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: likes ? FirebaseFirestore.instance.collection('Users').where("Like", arrayContains: yu).get() :
        FirebaseFirestore.instance.collection('Users').where("online", isEqualTo: true).get(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              _list = data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];
              if (_list.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                          "https://creazilla-store.fra1.digitaloceanspaces.com/cliparts/33843/woman-girl-smartphone-clipart-md.png",
                          height: 150),
                      Text("Sorry, No one's in Your City",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600)),
                      Text(
                          "Why don't you Share your App to your Friends",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text("Share App now >>"),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {

                        },
                        child: Text("Use Another City"),
                      ),
                    ],
                  ),
                );
              }
              return GridView.builder(
                itemCount: _list.length,
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 5.0, // Space between columns
                  mainAxisSpacing: 5.0, // Space between rows
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChatUserr(user: _list[index]),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
class ChatUserr extends StatelessWidget {
  UserModel user ;
  ChatUserr({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Profile(user: user)),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 20,
        height: MediaQuery.of(context).size.width / 2 - 20,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(user.pic),
            fit: BoxFit.cover
          ),
          borderRadius: BorderRadius.circular(15)
        ),
        child: Container(
          width: MediaQuery.of(context).size.width / 2 - 20,
          height: MediaQuery.of(context).size.width / 2 - 20,
          decoration: BoxDecoration(

              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black38,
                ],
              ),
              borderRadius: BorderRadius.circular(15)
          ),
          child: Padding(
            padding: const EdgeInsets.only( left :10.0, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16,),
                Container(
                  width: MediaQuery.of(context).size.width  ,
                  height: 20,
                  child: Row(
                    children: [
                      Spacer(),
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.circle, color : Colors.white, size: 8,),
                      )
                    ],
                  ),
                ),
                Spacer(),
                Text(user.Name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20),),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, color: Colors.white, size: 20,),
                    Container(
                        width : MediaQuery.of(context).size.width - 245,
                        child: Text(user.address, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 10),)),
                  ],
                ),
                SizedBox(height: 7,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class Nearby extends StatelessWidget {
  Nearby({super.key});

  String yu = FirebaseAuth.instance.currentUser!.uid;
  List<UserModel> _list = [];
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Crea
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
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
            child: Text("Nearby",
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('Users').get(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final data = snapshot.data?.docs;
              var _list = data
                  ?.map((e) => UserModel.fromJson(e.data()))
                  .toList() ??
                  [];
              _list = _list.where((user) {
                final distance =  calculateDistance(user.lat, user.lon, _user!.lat, _user.lon);
                // return user.stringField == STR && distance < d1 && user.age >= age1 && user.age <= age2;
                return distance < 100.0 ;
              }).toList();
              if (_list.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                          "https://creazilla-store.fra1.digitaloceanspaces.com/cliparts/33843/woman-girl-smartphone-clipart-md.png",
                          height: 150),
                      Text("Sorry, No one's around your City ( 100 km range )",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600)),
                      Text(
                          "Why don't you Share our App to your Friends, and come here to find them",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text("Share App now >>"),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {

                        },
                        child: Text("Use Another City"),
                      ),
                    ],
                  ),
                );
              }
              return GridView.builder(
                itemCount: _list.length,
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 5.0, // Space between columns
                  mainAxisSpacing: 5.0, // Space between rows
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChatUserr(user: _list[index]),
                  );
                },
              );
          }
        },
      ),
    );
  }
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0; // Earth radius in kilometers

    // Convert latitude and longitude from degrees to radians
    final lat1Rad = _degreesToRadians(lat1);
    final lon1Rad = _degreesToRadians(lon1);
    final lat2Rad = _degreesToRadians(lat2);
    final lon2Rad = _degreesToRadians(lon2);

    // Calculate the differences between coordinates
    final dLat = lat2Rad - lat1Rad;
    final dLon = lon2Rad - lon1Rad;

    // Haversine formula
    final a = pow(sin(dLat / 2), 2) +
        cos(lat1Rad) * cos(lat2Rad) * pow(sin(dLon / 2), 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Calculate the distance
    final distance = R * c;
    print(distance);
    // Format the distance as a string
    return distance; // Adjust the precision as needed
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180.0);
  }
}

