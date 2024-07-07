
import 'dart:typed_data' as lk ;
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:current_location/model/location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:matrinomy/main_page/main_page.dart';
import 'package:current_location/current_location.dart';
import 'package:geocoding/geocoding.dart' as geocoding ;
import 'package:matrinomy/model/usermodel.dart';
import 'package:matrinomy/provider/storage.dart';


class Step1 extends StatefulWidget {
  String phone ;
   Step1({super.key, required this.phone});

  @override
  State<Step1> createState() => _Step1State();
}

class _Step1State extends State<Step1> {

  List l5 = [];
  String drinkk = " ", smoke = " ", goall = "Male", gen = "Male" , looki = "Male", pic = "";

 int activeStep = 0; // Initial step set to 5.
 int upperBound = 6; // upperBound MUST BE total number of icons minus 1.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Your Details'), automaticallyImplyLeading: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                IconStepper(
                  icons: [
                    Icon(Icons.face, color : activeStep == 0 ? Colors.white : Colors.black),
                    Icon(Icons.work, color : activeStep == 1 ? Colors.white : Colors.black),
                    Icon(Icons.monitor_weight, color : activeStep == 2 ? Colors.white : Colors.black),
                    Icon(Icons.cake, color : activeStep == 3 ? Colors.white : Colors.black),
                    Icon(Icons.volunteer_activism, color : activeStep == 4 ? Colors.white : Colors.black),
                    Icon(Icons.local_drink, color : activeStep == 5 ? Colors.white : Colors.black),
                    Icon(Icons.gpp_good, color : activeStep == 6 ? Colors.white : Colors.black),
                  ],
                  activeStep: activeStep,stepColor: Colors.grey.shade200, activeStepColor: Color(0xffE9075B),
                  onStepReached: (index) {
                    setState(() {
                      activeStep = index;
                    });
                  },
                ),
                header(),
                s(context),
            
              ],
            ),
          ),
        ),
        persistentFooterButtons: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              previousButton(),
              nextButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget s(BuildContext context){
    switch (activeStep) {
      case 1:
        return r2(context);

      case 2:
        return r3(context);

      case 3:
        return r4(context);

      case 4:
        return r5(context);

      case 5:
        return r6(context);

      case 6:
        return r7(context);

      default:
        return r1(context);
    }
  }

  Widget sd (TextEditingController cg,  BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width : MediaQuery.of(context).size.width  , height : 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade100, // Background color of the container
          borderRadius: BorderRadius.circular(15.0), // Rounded corners
        ),
        child: Padding(
            padding: const EdgeInsets.only( left :10, right : 18.0, top : 5, bottom: 5),
            child: Center(
              child: TextFormField(
                controller: cg,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none, // No border
                  counterText: '',
                ),
              ),
            )
        ),
      ),
    );
  }
  Widget sd1 (TextEditingController cg,  BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width : MediaQuery.of(context).size.width  , height : 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade100, // Background color of the container
          borderRadius: BorderRadius.circular(15.0), // Rounded corners
        ),
        child: Padding(
            padding: const EdgeInsets.only( left :10, right : 18.0, top : 5, bottom: 5),
            child: Center(
              child: TextFormField(
                controller: cg,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none, // No border
                  counterText: '',
                ),
              ),
            )
        ),
      ),
    );
  }
  /// Returns the next button
  bool going = false ;

  bool checkin(){
    return name.text.isNotEmpty && pic.isNotEmpty ;
  }

  Widget nextButton() {
    return InkWell(
      onTap: ()  async {
        setState((){
          going = true ;
        });
        // Increment activeStep, when the next button is tapped. However, check for upper bound.
        if (activeStep < upperBound) {
          setState(() {
            activeStep ++ ;
          });
        }
        else if (checkin()){
          CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');
          String h = FirebaseAuth.instance.currentUser!.uid ;
          print("No");
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
              print("uawe");
              String t = DateTime.now().toString();
              UserModel hj = UserModel(Email: " ", Name: name.text, token : "",
                  uid: h, smoke: smoke, bday: _singleDatePickerValueWithDefaultValue[0].toString(), premium : false , phone : widget.phone,
                  weight: weight.text, height: height.text, follower: [], following: [],
                  education: education.text, drink: drinkk, gender: gen,lastp:"2024-06-27 16:48:31.164244",
                  hobbies: l5, looking: looki, online : true, lastlogin : "2024-06-27 16:48:31.164244",
                  s1 : " ", s2 : " ", s3 : " " , s4 : " ", s5 : " ", age1 : 18.0, age2 : 35.0, distance : 500,
                  relationship: goall, work: work.text, address: address, country: country, lat: lat!, lon: lon!, state: state, pic: pic);
              await usersCollection.doc(h).set(hj.toJson());
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ),
              );
            }else{
              print("uawe");
              String t = DateTime.now().toString();
              UserModel hj = UserModel(Email: " ", Name: name.text, token : "",
                  uid: h, smoke: smoke, bday: _singleDatePickerValueWithDefaultValue[0].toString(), premium : false , phone : widget.phone,
                  weight: weight.text, height: height.text, follower: [], following: [],
                  education: education.text, drink: drinkk, gender: gen,lastp:"",
                  hobbies: l5, looking: looki, online : true, lastlogin : t,
                  s1 : " ", s2 : " ", s3 : " " , s4 : " ", s5 : " ", age1 : 18.0, age2 : 35.0, distance : 500,
                  relationship: goall, work: work.text, address: address, country: country, lat: lat!, lon: lon!, state: state, pic: pic);
              await usersCollection.doc(h).set(hj.toJson());
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ),
              );
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
          setState((){
            going = false ;
          });
        } else{
          ScaffoldMessenger.of(context)
              .showSnackBar(
            SnackBar(
              content: Text('Name & Picture is Required !'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Container(
              width : MediaQuery.of(context).size.width - 100, height : 60,
              decoration: BoxDecoration(
                color: Color(0xffE9075B), // Background color of the container
                borderRadius: BorderRadius.circular(15.0), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1), // Shadow color
                    spreadRadius: 5, // Spread radius
                    blurRadius: 7, // Blur radius
                    offset: Offset(0, 3), // Shadow position
                  ),
                ],
              ),
              child : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text("Continue  ", style : TextStyle( color : Colors.white)),
                  Icon(Icons.arrow_forward,  color : Colors.white),
                ],
              )
          ),
        ),
      ),
    );
  }

  /// Returns the previous button.
  Widget previousButton() {
    return InkWell(
      onTap: () {
        // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
        if (activeStep > 0) {
          setState(() {
            activeStep--;
          });
        }
      },
      child: Center(
        child: CircleAvatar(
          radius: 25,
          backgroundColor: Color(0xffE9075B),
          child: Icon(Icons.arrow_back, color : Colors.white),
        ),
      ),
    );
  }

  /// Returns the header wrapping the header text.
  Widget header() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        headerText(),
        style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.w200,
          fontSize: 20,
        ),
      ),
    );
  }

  // Returns the header text based on the activeStep.
  String headerText() {
    switch (activeStep) {
      case 1:
        return 'Your Work / Qualification';

      case 2:
        return 'Your BMI';

      case 3:
        return 'Your Birthday';

      case 4:
        return 'Hobbies';

      case 5:
        return 'Smoking / Drinking';

      case 6:
        return 'Your Goal';

      default:
        return 'Personal Information';
    }
  }
  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Image Selected');
  }
  bool send1 = false ;
  Widget r1(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          t1("What's your Name"),
          SizedBox(height : 7),
          t2("We need your Name so Everyone could find you, and have Identity"),
          SizedBox(height : 18),
          sd(name, context),
          t1("Your Picture"),
          t2("Your Profile Picture for Display. You could add 5 more Later !"),
          SizedBox(height : 7),
          send1 ? Center(child: CircularProgressIndicator()) :InkWell(
            onTap: () async {
              setState((){
                send1 = true ;
              });
              lk.Uint8List? file = await pickImage(ImageSource.gallery);
              if ( file != null ){
                String photoUrl =  await StorageMethods().uploadImageToStorage('Users', file  , true);
                setState(() {
                  pic = photoUrl ;
                });
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Profile Pic Uploaded"),
                ),
              );
              setState((){
                send1 = false ;
              });
            },
            child: pic == ""? Container(
              height:  170, width:  140,
              color : Colors.grey.shade300,
              child : Icon(Icons.camera_alt,color:Colors.black)
            ) :  Container(
                height:  170, width:  140,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(pic),
                    fit: BoxFit.cover,
                  )
                ),
            ),
          ),
        ],
      ),
    );
  }

  _buildCalendarDialogButton() {
    const dayTextStyle =  TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    final weekendTextStyle =
    TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
    final anniversaryTextStyle = TextStyle(
      color: Colors.red[400] ,
      fontWeight: FontWeight.w700 ,
      decoration: TextDecoration.underline ,
    );
    final config = CalendarDatePicker2WithActionButtonsConfig(
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.single,
      selectedDayHighlightColor: Colors.purple[800],
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }
        if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
          textStyle = anniversaryTextStyle ;
        }
        return textStyle;
      },
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatDecimal(date.day),
                    style: textStyle ,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isSelected == true
                            ? Colors.white
                            : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              final values = await showCalendarDatePicker2Dialog(
                context: context,
                config: config,
                dialogSize: const Size(325, 400),
                borderRadius: BorderRadius.circular(15),
                value: _singleDatePickerValueWithDefaultValue ,
                dialogBackgroundColor: Colors.white,
              );
              if (values != null) {
                // ignore: avoid_print
                print(_getValueText(
                  config.calendarType,
                  values,
                ));
                // Format the DateTime in the desired format (DD/MM/YYYY)
                setState(() {
                  _singleDatePickerValueWithDefaultValue  = values;
                  DateTime? date = _singleDatePickerValueWithDefaultValue.first ;
                  String dateTimeString = date.toString(); // Replace with your DateTime string

                  // Convert DateTime string to DateTime
                  DateTime dateTime = DateTime.parse(dateTimeString);

                  // Format the DateTime in the desired format (DD/MM/YYYY)
                  String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
                  bday = TextEditingController(text: formattedDate);
                });
              }
            },
            child: const Text('Choose Date of Birth'),
          ),
        ],
      ),
    );
  }

 Widget r2(BuildContext context){
   return Padding(
     padding: const EdgeInsets.all(10.0),
     child: Column(
       mainAxisAlignment: MainAxisAlignment.start,
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         t1("What's your Highest Qualification?"),
         SizedBox(height : 7),
         t2("Help you Known your Schooling ?"),
         SizedBox(height : 18),
         sd(education, context),
         SizedBox(height : 18),
         t1("What's your Work"),
         SizedBox(height : 7),
         t2("Help you Known your Cuurent Proffesion ?"),
         SizedBox(height : 18),
         sd(work, context),
       ],
     ),
   );
 }
 Widget r3(BuildContext context){
   return Padding(
     padding: const EdgeInsets.all(10.0),
     child: Column(
       mainAxisAlignment: MainAxisAlignment.start,
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         t1("What's your Height (cm) ?"),
         SizedBox(height : 10),
         sd1(height, context),
         SizedBox(height : 25),
         t1("What's your Weight (kg) ?"),
         SizedBox(height : 10),
         sd1(weight, context),
       ],
     ),
   );
 }
 Widget r4(BuildContext context){
   return Padding(
     padding: const EdgeInsets.all(10.0),
     child: Column(
       mainAxisAlignment: MainAxisAlignment.start,
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         t1("When's your Birthday?"),
         SizedBox(height : 7),
         t2("We will only determine your Age ! Your Birthdate will not be public"),
         SizedBox(height : 18),
         _buildCalendarDialogButton(),
         SizedBox(height : 10),
         t1("Your Gender ?"),
         SizedBox(height : 4),
         Row(
           children: [
             rtn("Male", 3), rtn("Female", 3), rtn ("TransGender", 3)
           ],
         ),
         SizedBox(height : 10),
         t1("Your are looking for ?"),
         SizedBox(height : 4),
         Row(
           children: [
             rtn("Male", 4), rtn("Female", 4), rtn ("Everyone", 4)
           ],
         ),
       ],
     ),
   );
 }

 Widget r5(BuildContext context){
   return Padding(
     padding: const EdgeInsets.all(10.0),
     child: Column(
       mainAxisAlignment: MainAxisAlignment.start,
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         t1("What's your Hobbies?"),
         SizedBox(height : 7),
         t2("Help you Known your Schooling ?"),
         SizedBox(height : 18),
         Row(
           children: [
             rt("Travel"), rt("Foodie"),rt("Fitness"),
           ],
         ),
         Row(
           children: [
             rt("Music"), rt("Bookworm"),rt("Adventure"),
           ],
         ),
         Row(
           children: [
             rt("Gamer"), rt("Animal Lover"),rt("Nature")
           ],
         ),
         Row(
           children: [
             rt("Arts and Creativity"), rt("Tech"),
           ],
         ),
         Row(
           children: [
             rt("Sports"), rt("Fashionist"),rt("Movie"),
           ],
         ),
         Row(
           children: [
             rt("Wellness"), rt("History"),rt("Photography"),
           ],
         ),
         Row(
           children: [
             rt("DIY"), rt("Craft"),rt("History"),
           ],
         ),
       ],
     ),
   );
 }
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now(),
  ];

 Widget rt(String jh){
    return InkWell(
      onTap : (){
        if(l5.contains(jh)){
          setState(() {
            l5.remove(jh);
          });
          print(l5);
        }else{
          setState(() {
            l5 = l5 + [jh];
          });
          print(l5);
        }
      }, child : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
        decoration: BoxDecoration(
          color: l5.contains(jh) ? Color(0xffE9075B) : Colors.grey.shade100, // Background color of the container
          borderRadius: BorderRadius.circular(15.0), // Rounded corners
        ),
        child : Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(jh, style : TextStyle(fontSize: 15, color : l5.contains(jh) ? Colors.white : Colors.black )),
        )
            ),
      )
    );
 }

  Widget r6(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          t1("Do you Smoke ?"),
          SizedBox(height : 7),
          t2("Help us known your Smoking Habit ? "),
          SizedBox(height : 18),
          Row(
            children: [
              rtn("Frequently", 0), rtn("Sometimes", 0), rtn("Everyday", 0),
            ],
          ),
          Row(
            children: [
              rtn("Never", 0), rtn("Occasionly", 0),
            ],
          ),
          SizedBox(height : 28),
          t1("Do you Drink ?"),
          SizedBox(height : 7),
          t2("Help us known your Drinking Habit ? "),
          SizedBox(height : 18),
          Row(
            children: [
              rtn("Frequently", 1), rtn("Sometimes", 1), rtn("Everyday", 1),
            ],
          ),
          Row(
            children: [
              rtn("Never", 1), rtn("Occasionly", 1),
            ],
          )
        ],
      ),
    );
  }

  Widget r7(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          t1("What's your Relationship Goal ?"),
          SizedBox(height : 7),
          t2("Help us known what's your Primary Motive for this App "),
          SizedBox(height : 18),
          Row(
            children: [
              rtn("Just Looking", 2), rtn("Relationship ", 2),
            ],
          ),
          Row(
            children: [
              rtn("Dating", 2), rtn("Marrying", 2),
            ],
          ),
          Row(
            children: [
              rtn("Friends", 2),
            ],
          ),
        ],
      ),
    );
  }
  Widget rtn(String jh, int i ){
    if ( i == 0 ){
      return InkWell(
          onTap : (){
            setState(() {
              smoke = jh ;
            });
          }, child : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
              color: smoke == jh ? Color(0xffE9075B) : Colors.grey.shade100, // Background color of the container
              borderRadius: BorderRadius.circular(15.0), // Rounded corners
            ),
            child : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(jh, style : TextStyle(fontSize: 15, color : smoke == jh ? Colors.white : Colors.black )),
            )
        ),
      )
      );
    }else if ( i == 1 ){
      return InkWell(
          onTap : (){
            setState(() {
             drinkk = jh ;
            });
          }, child : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
              color: drinkk == jh ? Color(0xffE9075B) : Colors.grey.shade100, // Background color of the container
              borderRadius: BorderRadius.circular(15.0), // Rounded corners
            ),
            child : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(jh, style : TextStyle(fontSize: 15, color : drinkk == jh ? Colors.white : Colors.black )),
            )
        ),
      )
      );
    }else if ( i == 2){
      return InkWell(
          onTap : (){
            setState(() {
             goall = jh ;
            });
          }, child : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
              color: goall == jh ? Color(0xffE9075B) : Colors.grey.shade100, // Background color of the container
              borderRadius: BorderRadius.circular(15.0), // Rounded corners
            ),
            child : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(jh, style : TextStyle(fontSize: 15, color : goall == jh ? Colors.white : Colors.black )),
            )
        ),
      )
      );
    }else if ( i == 3 ){
      return InkWell(
          onTap : (){
            setState(() {
              gen = jh ;
            });
          }, child : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
              color: gen == jh ? Color(0xffE9075B) : Colors.grey.shade100, // Background color of the container
              borderRadius: BorderRadius.circular(15.0), // Rounded corners
            ),
            child : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(jh, style : TextStyle(fontSize: 15, color : gen == jh ? Colors.white : Colors.black )),
            )
        ),
      )
      );
    }else{
      return InkWell(
          onTap : (){
            setState(() {
              looki = jh ;
            });
          }, child : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
              color: looki == jh ? Color(0xffE9075B) : Colors.grey.shade100, // Background color of the container
              borderRadius: BorderRadius.circular(15.0), // Rounded corners
            ),
            child : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(jh, style : TextStyle(fontSize: 15, color : looki == jh ? Colors.white : Colors.black )),
            )
        ),
      )
      );
    }

  }
 TextEditingController name = TextEditingController();
 TextEditingController bday = TextEditingController();
 TextEditingController gender = TextEditingController();
 TextEditingController inte = TextEditingController();
 TextEditingController goal = TextEditingController();
 TextEditingController height = TextEditingController();
 TextEditingController weight = TextEditingController();
 TextEditingController hobbies = TextEditingController();
 TextEditingController drink = TextEditingController();
 TextEditingController smooking = TextEditingController();
 TextEditingController education = TextEditingController();
 TextEditingController work = TextEditingController();

  Widget t1(String g){
    return Text(g, style : TextStyle(fontSize: 25, fontWeight: FontWeight.w700));
  }
 Widget t2(String g){
   return Text(g, style : TextStyle(fontSize: 16, fontWeight: FontWeight.w300));
 }

  String _getValueText(
      CalendarDatePicker2Type datePickerType,
      List<DateTime?> values,
      ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
          .map((v) => v.toString().replaceAll('00:00:00.000', ''))
          .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }
}
