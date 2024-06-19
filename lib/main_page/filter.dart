import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:matrinomy/main.dart';
import 'package:provider/provider.dart';

import '../provider/declare.dart';

class Filters extends StatefulWidget {
   Filters({super.key, required this.d1, required this.a1, required this.a2, required this.str});
   double d1 , a1, a2 ;
   String str ;
  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  late double i , k , l;
  void initState(){
    super.initState();
    i = widget.d1 ; j = widget.d1 ;
    k = widget.a1;
    l = widget.a2;
    print(i);
    print(k);
    setState((){
      i = widget.d1 ; j = widget.d1 ;
      k = widget.a1;
      l = widget.a2;
    });
  }
  double j = 100 ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Preferences"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
              child : Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children : [
                    SizedBox(height : 8),
                    Row(
                      children: [
                        SizedBox(width : 10),
                        t("Maximum Distance"),
                        Spacer(),
                        t(t5(i) + " km"),
                        SizedBox(width : 10),
                      ],
                    ),
                    FlutterSlider(
                      values: [i, j],
                      max: 10000,
                      min: 100,
                      onDragging: (handlerIndex, lowerValue, upperValue) {
                        i = lowerValue;
                        j = upperValue;
                        setState(() {

                        });
                      },
                    ),
                    SizedBox(height : 10),
                  ]
                ),
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                ),
                child : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children : [
                        SizedBox(height : 8),
                        t("  Show Me"),
                        SizedBox(height : 8),
                        InkWell(
                          onTap :() {
                            po(context);
                            },
                          child: Row(
                            children: [
                              SizedBox(width : 10),
                              t1(widget.str),
                              Spacer(),
                              Icon(Icons.arrow_forward_ios_outlined, color : Color(0xffE9075B)),
                              SizedBox(width : 10),
                            ],
                          ),
                        ),
                        SizedBox(height : 10),
                      ]
                  ),
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                ),
                child : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                      children : [
                        SizedBox(height : 8),
                        Row(
                          children: [
                            SizedBox(width : 10),
                            t("Age Range"),
                            Spacer(),
                            t1(t5(k) + " - " + t5(l)),
                            SizedBox(width : 10),
                          ],
                        ),
                        FlutterSlider(
                          values: [k, l],
                          max: 70,
                          min: 18,
                          rangeSlider: true,
                          onDragging: (handlerIndex, lowerValue, upperValue) {
                            k = lowerValue;
                            l = upperValue;
                            setState(() {

                            });
                          },
                        ),
                        SizedBox(height : 10),
                      ]
                  ),
                )
            ),
          ),
          Center(child: Text("Dil se Dil Tak will use this Filters to support Matches"))
        ],
      ),
      persistentFooterButtons: [
        Center(
          child: Container(
              width : MediaQuery.of(context).size.width , height : 50,
              decoration: BoxDecoration(
                color: Color(0xffE9075B), // Background color of the container
                borderRadius: BorderRadius.circular(15.0), // Rounded corners
              ),
              child : InkWell(
                onTap : () async {
                  String st = FirebaseAuth.instance.currentUser!.uid ;
      await FirebaseFirestore.instance.collection("Users").doc(st).update({
        "age1" : k,
        "age2" : l,
        "dis" : i,
        "looking" : widget.str ,
      });
                  UserProvider _userprovider = Provider.of(context, listen: false);
                  await _userprovider.refreshuser();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyApp(),
                    ),
                  );
    },
                child: Padding(
                    padding: const EdgeInsets.all(17.0),
                    child:Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Icon(Icons.save, color : Colors.white),
                        Text("Save Preferences", style : TextStyle(color : Colors.white)),
                      ],
                    )
                ),
              )
          ),
        )
      ],
    );
  }
  Widget t(String ti){
    return Text(ti, style : TextStyle(fontWeight: FontWeight.w600, fontSize: 22));
  }

  Widget t1(String ti){
    return Text(ti, style : TextStyle(fontWeight: FontWeight.w400, fontSize: 19));
  }
  String t5(double j){
    int h = j.toInt();
    return h.toString();
  }
  void po(BuildContext context){
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 330,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:  <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color : Colors.blue,
                      ),
                      height : 9, width : 40,
                    )
                  ),
                ),
                SizedBox(height : 25),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (){
                      setState((){
                        widget.str = "Everyone";
                      });
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        SizedBox(width : 10),
                        t1("Everyone"),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined, color : Color(0xffE9075B)),
                        SizedBox(width : 10),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (){
                      setState((){
                        widget.str = "Male";
                      });
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        SizedBox(width : 10),
                        t1("Male"),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined, color : Color(0xffE9075B)),
                        SizedBox(width : 10),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (){
                      setState((){
                        widget.str = "Female";
                      });
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        SizedBox(width : 10),
                        t1("Women"),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined, color : Color(0xffE9075B)),
                        SizedBox(width : 10),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Divider(),
                ),
                Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
