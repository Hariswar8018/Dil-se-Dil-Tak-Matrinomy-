
import 'dart:typed_data' as lk;
import 'package:current_location/current_location.dart';
import 'package:current_location/model/location.dart';
import 'package:geocoding/geocoding.dart' as geocoding ;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:matrinomy/dashboard/update.dart';
import 'package:matrinomy/main.dart';
import 'package:matrinomy/model/usermodel.dart';
import 'package:matrinomy/provider/declare.dart';
import 'package:matrinomy/provider/storage.dart';

class MyP extends StatefulWidget {
 MyP({super.key});

  @override
  State<MyP> createState() => _MyPState();
}

class _MyPState extends State<MyP> {
 vq() async {
   UserProvider _userprovider = Provider.of(context, listen: true);
   await _userprovider.refreshuser();
 }

 void initState(){
   vq();
   super.initState();
   vq();
 }

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Image Selected');
  }

  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        title: Text("Your Profile"),
        actions: [
          IconButton(onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Home1(),
              ),
            );
    }, icon: Icon(Icons.login, color : Colors.red)
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _user!.pic == " " ? dot(context, "pic") : dott(context, _user.pic, "pic"),
                _user!.s1 == " " ? dot(context, "s1") : dott(context, _user.s1, "s1"),
                _user!.s2 == " " ? dot(context, "s2") : dott(context, _user.s2, "s2"),
          ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _user!.s3 == " " ? dot(context, "s3") : dott(context, _user.s3, "s3"),
                _user!.s4 == " " ? dot(context, "s4") : dott(context, _user.s4, "s4"),
                _user!.s5 == " " ? dot(context, "s5") : dott(context, _user.s5, "s5"),
              ],
            ),
            SizedBox(height: 25,),
            g(_user.Name, "Name", "name", false),
            g1(_user.gender, "Gender", "gender", false),
            g(_user.Email, "Email", "Email", false),
            g3(_user.address, _user.lat.toString(), _user.lon.toString(), _user.country, _user.state),
            g(_user.education, "Education", "education", false),
            g(_user.work, "Work", "work", false),
            g(_user.smoke, "Smoke", "smoke", false),
            g(_user.drink, "Drinking", "drink", false),
            g1(_user.looking, "Looking", "looking", false),
            g(_user.height, "Height", "height", true),
            g(_user.weight, "Weight", "weight", true),
            SizedBox(height: 30,),
            ],
        ),
      )
    );
  }
 Widget g3 (String address, String lat, String lon, String country, String state ){
   return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
       t("Address"),
       ListTile(
         tileColor: Colors.white,
         title: Text("Address : " + address),
         trailing: InkWell(
             onTap : () async {
               ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                   content: Text('Fetching Location.........'),
                   duration: Duration(seconds: 2),
                   // Duration for how long the Snackbar will be visible
                   action: SnackBarAction(
                     label: 'Close',
                     onPressed: () {
                       // Add your action here
                       ScaffoldMessenger.of(context)
                           .hideCurrentSnackBar(); // Hides the current Snackbar
                     },
                   ),
                 ),
               );
               try {
                 final Location? userLocation = await UserLocation.getValue();
                 String country = userLocation!.country ?? "INDIA";
                 String state = userLocation.regionName ?? "Odisha";
                 String ip = userLocation.currentIP ?? "y";
                 double lat = userLocation.latitude ?? 66.8;
                 double lon = userLocation.longitude ?? 88.4;
                 String address = " ";
                 print("hh");
                 List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(lat! , lon!);
            if (placemarks != null && placemarks.isNotEmpty) {
              geocoding.Placemark placemark = placemarks.first;
              // Access the address components
              address = "${placemark.street}, ${placemark.locality}, ${placemark.subLocality}, ${placemark.administrativeArea}, ${placemark.isoCountryCode}";
              print("User's address: $address");
              await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).update(
                  {
                    "address" : address,
                    "lat" : lat,
                    "lon" : lon,
                    "state" : state,
                    "country" : country,
                  });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Location Updated !'),
                  duration: Duration(seconds: 2),
                  // Duration for how long the Snackbar will be visible
                  action: SnackBarAction(
                    label: 'Close',
                    onPressed: () {
                      // Add your action here
                      ScaffoldMessenger.of(context)
                          .hideCurrentSnackBar(); // Hides the current Snackbar
                    },
                  ),
                ),
              );
              UserProvider _userprovider = Provider.of(context, listen: false);
              await _userprovider.refreshuser();
            }



               } catch (e) {
                 ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(
                     content: Text('${e}'),
                     duration: Duration(seconds: 2),
                     // Duration for how long the Snackbar will be visible
                     action: SnackBarAction(
                       label: 'Close',
                       onPressed: () {
                         // Add your action here
                         ScaffoldMessenger.of(context)
                             .hideCurrentSnackBar(); // Hides the current Snackbar
                       },
                     ),
                   ),
                 );
               }
   },
             child: Icon(Icons.refresh, color : Colors.blue)),
       ),
       ListTile(
         tileColor: Colors.white,
         title: Text("Latitude : " + lat),
       ),
       ListTile(
         tileColor: Colors.white,
         title: Text("Longitude : " + lon),
       ),
       ListTile(
         tileColor: Colors.white,
         title: Text("State : " + state),
       ),
       ListTile(
         tileColor: Colors.white,
         title: Text("Country : " + country),
       ),
     ],
   );
 }
  Widget g (String gh, String h, String str, bool ii){
   return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
       t(h),
       ListTile(
         onTap: (){
           Navigator.push(
             context,
             MaterialPageRoute(
               builder: (context) => Up(fireup: str, number: ii, show: h,),
             ),
           );
         },
         tileColor: Colors.white,
         title: Text(gh),
         trailing: Icon(Icons.arrow_forward_ios, ),
       ),
     ],
   );
  }
 Widget g1 (String gh, String h, String str, bool ii){
   return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
       t(h),
       ListTile(
         tileColor: Colors.white,
         title: Text(gh),
       ),
     ],
   );
 }
  Widget t(String gh){
   return Padding(
     padding: const EdgeInsets.all(10.0),
     child: Text(gh, style : TextStyle(fontWeight: FontWeight.w800, fontSize: 20))
   );
  }

  Widget dot(BuildContext context, String hj){
    return DottedBorder(
      color: Colors.red,
      strokeWidth: 3, radius: Radius.circular(10),
      child: InkWell(
        onTap: () async {
          lk.Uint8List? file = await pickImage(ImageSource.gallery);
          if ( file != null ){
            String photoUrl =  await StorageMethods().uploadImageToStorage('Users', file  , true);
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({
              hj : photoUrl,
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Profile Pic Uploaded"),
              ),
            );
          }

        },
        child: Container(
            color : Colors.grey.shade50,
            height: 170, width: MediaQuery.of(context).size.width / 3 - 20, child: Icon(Icons.add, color: Colors.green,)),
      ),
    );
  }

  Widget dott(BuildContext context, String hj, String hl){
    return DottedBorder(
      color: Colors.red,
      strokeWidth: 1, radius: Radius.circular(10),
      child: InkWell(
        onTap: () async {
          lk.Uint8List? file = await pickImage(ImageSource.gallery);
          if ( file != null ){
            String photoUrl =  await StorageMethods().uploadImageToStorage('Users', file  , true);
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({
              hl : photoUrl,
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Profile Pic Uploaded"),
              ),
            );
          }

        },
        child: Container(
            height: 170, width: MediaQuery.of(context).size.width / 3 - 20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(hj),
              fit: BoxFit.cover
            )
          ),
        ),
      ),
    );
  }
}
