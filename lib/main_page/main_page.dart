import 'dart:math';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:matrinomy/cards/meessagecard.dart';
import 'package:matrinomy/global/drawer.dart';
import 'package:matrinomy/main_page/premium.dart';
import 'package:matrinomy/provider/declare.dart';
import 'package:provider/provider.dart';

import '../model/usermodel.dart';
import '../model/messagw.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glassfy_flutter/glassfy_flutter.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:matrinomy/cards/homecard.dart';
import 'package:matrinomy/cards/meessagecard.dart';
import 'package:matrinomy/dashboard/myprofile.dart';
import 'package:matrinomy/global/drawer.dart';
import 'package:matrinomy/main_page/blocked_passed.dart';
import 'package:matrinomy/main_page/like_nearby_online.dart';
import 'package:matrinomy/provider/declare.dart';

import '../model/usermodel.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:matrinomy/ads.dart' ;
import 'filter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:matrinomy/g.dart' ;
class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  vq() async {
    UserProvider _userprovider = Provider.of(context, listen: false);
    await _userprovider.refreshuser();
    String uuu = FirebaseAuth.instance.currentUser!.uid ;
    UserService.saveToken(uuu);
  }


  void initState() {
    vq();
    super.initState();
    vq();
    ft();
  }
  void ft( ) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      var permission = await Glassfy.permissions();
      bool isPremium = false;

      // Check for valid premium permission
      for (var p in permission.all ?? []) {
        if (p.permissionId == "premium" && p.isValid == true) {
          isPremium = true;
          await FirebaseFirestore.instance.collection("Users").doc(userId).update({
            "p": true,
          });
          break; // Stop the loop once we find the "premium" permission
        }
      }
      UserModel? _user = Provider.of<UserProvider>(context, listen: false).getUser;
      if (!isPremium) {
        if(_user!.gender == "Female"){
          await FirebaseFirestore.instance.collection("Users").doc(userId).update({
            "p": true,
          });
        }else{
          await FirebaseFirestore.instance.collection("Users").doc(userId).update({
            "p": false,
          });
        }

      }
    } catch (e) {
      // Handle error
      print("Error while checking permissions: $e");
      UserModel? _user = Provider.of<UserProvider>(context, listen: false).getUser;
      if(_user!.gender=="Female"){
        await FirebaseFirestore.instance.collection("Users").doc(userId).update({
          "p": true,
        });
      }else{
        await FirebaseFirestore.instance.collection("Users").doc(userId).update({
          "p": false,
        });
      }

    }

    // Refresh user using UserProvider
    UserProvider _userprovider = Provider.of<UserProvider>(context, listen: false);
    await _userprovider.refreshuser();
  }


  int indexx = 0;
  List<UserModel> _list = [];
  final CardSwiperController controller = CardSwiperController();
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
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
            child: Text("Explore",
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          InkWell(
            onTap: () async {
              CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');
              QuerySnapshot querySnapshot = await usersCollection.where('uid', isEqualTo: _user!.uid ).get();
              UserModel userr = UserModel.fromSnap(querySnapshot.docs.first);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Filters(
                      d1: userr.distance,
                      a1: userr.age1,
                      a2: userr.age2,
                      str: userr.looking),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade400,
                child: Icon(Icons.filter_list_alt, color: Colors.black),
              ),
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 200,
            child: FutureBuilder(
              future: FirebaseFirestore.instance.collection('Users').get(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                  case ConnectionState.active:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final data = snapshot.data?.docs;
                    _list = data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];
                    _list = _list.where((user) {
                      final distance = calculateDistance(user.lat, user.lon, _user!.lat, _user.lon);
                      if (_user.looking == "Everyone") {
                        return distance < _user.distance && cal(user.bday) > _user.age1 && cal(user.bday) < _user.age2;
                      } else {
                        return distance < _user.distance && cal(user.bday) > _user.age1 && cal(user.bday) < _user.age2 && user.gender == _user.looking;
                      }
                    }).toList();

                    if (_list.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Sorry, No one's in Your City", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                            Text("Why don't you Share your App to your Friends", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            SizedBox(height: 10),
                          ],
                        ),
                      );
                    }

                    return CardSwiper(
                      cardsCount: _list.length,
                      numberOfCardsDisplayed: _list.length,
                      onSwipe: _onSwipe,
                      onUndo: _onUndo,
                      controller: controller,
                      cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                        return Container(
                          child: ChatUser(user: _list[index]),
                        );
                      },
                    );
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  radius: 30,
                  child: IconButton(
                    onPressed: () {
                      controller.undo();
                      setState(() {});
                    },
                    icon: Icon(Icons.refresh, color: Colors.white),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  radius: 30,
                  child: IconButton(
                    onPressed: () async {
                      if (_list.isNotEmpty) {
                        String g = FirebaseAuth.instance.currentUser!.uid;
                        // Navigate to the new page with the selected user
                        try {
                          await FirebaseFirestore.instance
                              .collection("Users")
                              .doc(_list[indexx].uid)
                              .update({
                            "Like": FieldValue.arrayUnion([g]),
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("User added to your Like Section"),
                            ),
                          );
                        } catch (e) {
                          print(e);
                        }
                        controller.swipe(CardSwiperDirection.right);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("No users available to like."),
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.favorite, color: Colors.white),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  radius: 30,
                  child: IconButton(
                    onPressed: () {
                      if (_list.isNotEmpty) {
                        if(check()){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(user: _list.elementAt(indexx)),
                            ),
                          );
                      }else{
                        Navigator.push(
                            context, PageTransition(
                            child: Premium(), type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 100)
                        ));
                      }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("No users available to chat."),
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.chat, color: Colors.white),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  radius: 30,
                  child: IconButton(
                    onPressed: () {
                      if (_list.isNotEmpty) {
                        controller.swipe(CardSwiperDirection.left);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("No users available to swipe."),
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void vqt() async {
    UserProvider _userprovider = Provider.of(context, listen: false);
    await _userprovider.refreshuser();
  }

  bool check(){
    vqt();
    UserModel? _user = Provider.of<UserProvider>(context, listen: false).getUser;
    if(_user!.premium){
      return true;
    }else{
      try {
        DateTime storedDateTime = DateTime.parse(_user!.lastp);
        DateTime currentDateTime = DateTime.now();
        print("$storedDateTime $currentDateTime");
        Duration difference = currentDateTime.difference(storedDateTime);
        return difference.inMinutes <= 30;
      }catch(e){
        return  false;
      }
    }
  }

  int cal(String dateString) {
    try {
      DateFormat dateFormat = DateFormat("dd/MM/yyyy");
      DateTime inputDate = dateFormat.parse(dateString);
      DateTime today = DateTime.now();
      int yearDifference = today.year - inputDate.year;
      if (inputDate.month > today.month || (inputDate.month == today.month && inputDate.day > today.day)) {
        yearDifference--;
      }
      if (yearDifference <= 18) {
        return 18;
      }
      return yearDifference;
    } catch (e) {
      return 19;
    }
  }

  bool _onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    if (indexx >= _list.length - 1) {
      indexx = 0;
    } else {
      indexx += 1;
    }
    return true;
  }

  bool _onUndo(int? previousIndex, int currentIndex, CardSwiperDirection direction) {
    indexx = 0;
    setState(() {});
    return true;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0; // Earth radius in kilometers
    final lat1Rad = _degreesToRadians(lat1);
    final lon1Rad = _degreesToRadians(lon1);
    final lat2Rad = _degreesToRadians(lat2);
    final lon2Rad = _degreesToRadians(lon2);
    final dLat = lat2Rad - lat1Rad;
    final dLon = lon2Rad - lon1Rad;
    final a = pow(sin(dLat / 2), 2) + cos(lat1Rad) * cos(lat2Rad) * pow(sin(dLon / 2), 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distance = R * c;
    return distance;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180.0);
  }
}


