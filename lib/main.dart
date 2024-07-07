import 'package:matrinomy/provider/declare.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' ;
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:matrinomy/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:matrinomy/first/login.dart';
import 'package:matrinomy/main_page/main_page.dart';
import 'package:matrinomy/provider/declare.dart' ;
import 'package:glassfy_flutter/glassfy_flutter.dart' ;
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:matrinomy/ads.dart' ;

import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Glassfy.initialize('ef3556dfa53840739475484c1bb48d23',watcherMode: false);
  } catch (e) {
   print(e);
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
      MyApp()
  );
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  User? user = FirebaseAuth.instance.currentUser ;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
          title: 'Dil se Dil Tak', debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true ,
          ),
          home : FutureBuilder(
              future: Future.delayed(Duration(seconds: 3)),
              builder: (ctx, timer) =>
              timer.connectionState == ConnectionState.done
                  ? ( user == null ? Home1() : Home() ) //Screen to navigate to once the splashScreen is done.
                  : Container(
                color: Colors.white ,
                width: MediaQuery.of(context).size.width,
                child: Image(
                  image: AssetImage('assets/IMG-20240526-WA0032.jpg'),
                ),
              ),
          ),
      ),
    );
  }
}

class Home1 extends StatelessWidget {
  const Home1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffD3DFEB),
      body : Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children : [
          Container(
           width : MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/IMG-20240526-WA0031.jpg"),
                fit: BoxFit.cover
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: InkWell(
              onTap : (){
                Navigator.push(
                    context, PageTransition(
                    child: LoginScreen(), type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 300)
                ));
              },
              child: Center(
                child: Container(
                  width : MediaQuery.of(context).size.width - 70, height : 60,
                  decoration: BoxDecoration(
                    color: Colors.white70, // Background color of the container
                    borderRadius: BorderRadius.circular(15.0), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
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
                      Icon(Icons.phone_iphone),
                      Text("Login with Mobile Number"),
                    ],
                  )
                ),
              ),
            ),
          )
        ]
      )
    );
  }
}
