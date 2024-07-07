import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glassfy_flutter/glassfy_flutter.dart';
import 'package:glassfy_flutter/models.dart';
import 'package:matrinomy/ads.dart';
import 'package:matrinomy/main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:matrinomy/model/usermodel.dart';
import 'package:matrinomy/provider/declare.dart';
import 'package:provider/provider.dart';

class Premium extends StatefulWidget {
  Premium({super.key});

  @override
  State<Premium> createState() => _PremiumState();
}

class _PremiumState extends State<Premium> {
  bool rou = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Buy Premium"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network("https://img.freepik.com/premium-vector/happy-family-couple-with-shopping-man-woman-with-bags-big-sale-illustration_165429-519.jpg"),
            Text("Opps ! You need Premium", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            Text("Unlock now to get Premium Services", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
            SizedBox(height: 10),
            t("Unlimited Chats"),
            t("See Full Profile"),
            t("Call / Video Call"),
            t("No Ads"),
            SizedBox(height: 20),
            Text(check(), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.red)),
            SizedBox(height: 10),
            Center(
              child: InkWell(
                onTap: () async {
                  if(check1()){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Wait for the Premium to expire"),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }else{
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Uhc()),
                    );
                  }

                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 50,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent, // Background color of the container
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
                  child: Padding(
                    padding: const EdgeInsets.all(17.0),
                    child: rou
                        ? Center(child: CircularProgressIndicator())
                        : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.ad_units_rounded, color: Colors.white),
                        SizedBox(width: 20),
                        Text("View Ad to Unlock / 30 Min", style: TextStyle(color: Colors.white, fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: InkWell(
                onTap: () async {
                  setState(() {
                    rou = true;
                  });
                  purchaseFirstOffering(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 50,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xffE9075B), // Background color of the container
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
                  child: Padding(
                    padding: const EdgeInsets.all(17.0),
                    child: rou
                        ? Center(child: CircularProgressIndicator())
                        : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.payments, color: Colors.white),
                        SizedBox(width: 20),
                        Text("Buy at ₹99 / Month", style: TextStyle(color: Colors.white, fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget t(String st) {
    return ListTile(
      leading: Icon(Icons.verified, color: Colors.green),
      title: Text(st),
    );
  }

  Future<List<GlassfyOffering>> fetch() async {
    try {
      final offerings = await Glassfy.offerings();
      return offerings.all ?? [];
    } catch (e) {
      print('Error fetching offerings: $e');
      return [];
    }
  }

  Future<void> purchaseFirstOffering(BuildContext context) async {
    final offerings = await fetch();
    if (offerings.isNotEmpty && offerings.first.skus!.isNotEmpty) {
      final sku = offerings.first.skus!.first;
      try {
        var transaction = await Glassfy.purchaseSku(sku);
        var p = transaction.permissions?.all?.singleWhere((permission) => permission.permissionId == 'premium');
        if (p?.isValid == true) {
          print("Purchase successful");
          setState(() {
            rou = false;
          });
        } else {
          print("Purchase failed");
          setState(() {
            rou = false;
          });
        }
      } catch (e) {
        print('Error during purchase: $e');
        setState(() {
          rou = false;
        });
      }
    } else {
      setState(() {
        rou = false;
      });
      print('No offerings available');
    }
  }

  vq() async {
    UserProvider _userprovider = Provider.of(context, listen: false);
    await _userprovider.refreshuser();
  }


  void initState() {
    vq();
    super.initState();
    vq();
  }

  bool check1(){
    UserModel? _user = Provider.of<UserProvider>(context, listen: false).getUser;
    if(_user!.premium){
      return true;
    }else{
      DateTime storedDateTime = DateTime.parse(_user!.lastp);
      DateTime currentDateTime = DateTime.now();
      print("$storedDateTime $currentDateTime");
      Duration difference = currentDateTime.difference(storedDateTime);
      return difference.inMinutes <= 30;
    }
  }
  String check() {
    UserModel? _user = Provider.of<UserProvider>(context, listen: false).getUser;
    if (_user != null && _user.premium) {
      return "You are Premium Subscriber Now !";
    } else if (_user != null) {
      DateTime storedDateTime = DateTime.parse(_user.lastp);
      DateTime currentDateTime = DateTime.now();
      print("$storedDateTime $currentDateTime");
      Duration difference = currentDateTime.difference(storedDateTime);
      if (difference.inMinutes <= 30) {
        return "You will be Premium for ${30 - difference.inMinutes} / 30 min";
      } else {
        return "Premium expired";
      }
    }
    return "";
  }

  void showSheet(BuildContext context, List<GlassfyOffering> offerings, ValueChanged<GlassfySku> onClickedSku) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 430,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 15),
                Container(
                  width: 80,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "BuyPremium ▶️",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
                SizedBox(height: 9),
                Expanded(
                  child: ListView.builder(
                    itemCount: offerings.length,
                    itemBuilder: (context, index) {
                      final offer = offerings[index];
                      return ListTile(
                        leading: Icon(Icons.credit_card, color: Colors.red),
                        title: Text(offer.offeringId.toString()),
                        subtitle: Text(offer.skus!.join(", ")), // Assuming offer.skus is a list of strings
                        onTap: () {
                          onClickedSku(offer.skus!.first); // Handle SKU clicked
                        },
                        trailing: Container(
                          width: MediaQuery.of(context).size.width / 3 - 20,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white70, // Background color of the container
                            borderRadius: BorderRadius.circular(10.0), // Rounded corners
                            border: Border.all(color: Color(0xffE9075B), width: 2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Center(child: Text("Buy Now")),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Uhc extends StatefulWidget {
  const Uhc({super.key});

  @override
  State<Uhc> createState() => _UhcState();
}

class _UhcState extends State<Uhc> {
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    _loadRewardedAd();
    super.initState();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          print('Rewarded ad loaded');
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              print('Ad dismissed');
              ad.dispose();
            },

          );

          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }
  bool rou = false ;
  int i = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Ad Loading",style:TextStyle(color:Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xffE9075B),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height:7),
          Text("Please wait for Ad to Load !",style:TextStyle(color:Colors.red,fontSize:20)),
          SizedBox(height:10),
          Center(
            child: InkWell(
              onTap: () async {
                DateTime now = DateTime.now();
                String ud = FirebaseAuth.instance.currentUser!.uid;
                setState(() {
                  rou = true;
                });
                if (_rewardedAd != null) {
                  _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
                    print('User earned reward: ${reward.amount}');
                    await FirebaseFirestore.instance.collection("Users").doc(ud).update({
                      "LastP": now.toString(),
                    });
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyApp(),
                      ),
                    );
                    setState(() {
                      rou = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Reward Granted ! You are premium for 30 Minutes'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  });
                } else {
                  print('Rewarded ad is not ready yet');
                  setState(() {
                    rou = false;
                    i=i+1;
                  });
                  if(i-4 <= 4){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("No Ads ! Try pressing " + (4-i).toString() +" times and Reloadng"),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }else{
                    setState(() {
                      i=0;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Looks like there's no Ads for Now ! Try again after 1 min"),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }

                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width - 50,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent, // Background color of the container
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
                child: Padding(
                  padding: const EdgeInsets.all(17.0),
                  child: rou
                      ? Center(child: CircularProgressIndicator())
                      : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.ad_units_rounded, color: Colors.white),
                      SizedBox(width: 20),
                      Text("Click to refresh Ad", style: TextStyle(color: Colors.white, fontSize: 20)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
