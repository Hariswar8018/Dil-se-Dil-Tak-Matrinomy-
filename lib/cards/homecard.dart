import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matrinomy/cards/profile.dart';
import 'package:matrinomy/model/usermodel.dart';
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
class ChatUser extends StatelessWidget {
  UserModel user;

  ChatUser({required this.user});

  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return InkWell(
      onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Profile(user: user)),
            );
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 50,
        height: MediaQuery.of(context).size.height - 70,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(user.pic),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black26,
            ],
          ),
          borderRadius:
          BorderRadius.circular(20), // specify the border radius here
        ),
        child: Container(
          width: MediaQuery.of(context).size.width - 50,
          height: MediaQuery.of(context).size.height - 70,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black38,
              ],
            ),
            borderRadius: BorderRadius.circular(20), // specify the border radius here
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, bottom: 9),
                child: Text(user.Name + "  " + " ( " +  cal(user.bday) + " " + sty() +  " )" , style:  TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 28),),
              ),
              hk(0, user.address, context),
              hk(1, calculateDistance(user.lat, user.lon, _user!.lat, _user.lon) + " km away", context),
              hk(2, "Followers " + user.follower.length.toString(), context),
              hk(3, "Following " + user.following.length.toString(), context),
              SizedBox(height: 15,),
            ],
          ),
        ),
      ),
    );
  }
  String cal(String dateString) {
    // Parse the input date string
    try {
      DateFormat dateFormat = DateFormat("dd/MM/yyyy");
      DateTime inputDate = dateFormat.parse(dateString);

      // Get today's date
      DateTime today = DateTime.now();

      // Calculate the difference in years
      int yearDifference = inputDate.year - today.year;

      // Adjust if the input date is before today's date in the same year
      if (inputDate.month < today.month ||
          (inputDate.month == today.month && inputDate.day < today.day)) {
        yearDifference--;
      }
      if(yearDifference <= 18){
        return "18" ;
      }

      return yearDifference.toString();
    }catch(e){
      return "19";
    }
  }
  String sty (){
    if(user.gender == "Male"){
      return "♂️";
    }else  if(user.gender == "Female"){
      return "♀️";
    }else{
      return "‍⚧️";
    }
  }
  Widget hk(int i, String hj, BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 11,),
          iconn(i),
          SizedBox(width: 9,),
          Container(
              width : MediaQuery.of(context).size.width - 140,
              child: Text(hj, style:  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),))
        ],
      ),
    );
  }
  Widget iconn( int j){
    if ( j == 0){
      return  Icon(Icons.location_pin, color :   Colors.white ,);
    }else if (j == 1){
      return Icon(Icons.directions_walk,color :  Colors.white ,);
    }else if ( j == 2){
      return Icon(Icons.people, color : Colors.white ,);
    }else{
      return Icon(Icons.follow_the_signs_sharp,color :  Colors.white ,);
    }
  }


  String calculateDistance(double lat1, double lon1, double lat2, double lon2) {
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

    // Format the distance as a string
    return distance.toStringAsFixed(0); // Adjust the precision as needed
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180.0);
  }


}