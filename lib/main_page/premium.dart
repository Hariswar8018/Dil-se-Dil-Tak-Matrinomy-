import 'package:flutter/material.dart';
import 'package:glassfy_flutter/glassfy_flutter.dart';
import 'package:glassfy_flutter/models.dart';

class Premium extends StatefulWidget {
  Premium({super.key});

  @override
  State<Premium> createState() => _PremiumState();
}

class _PremiumState extends State<Premium> {
  bool rou = false ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Buy Premium "),
      ),
      body: Column(
        children: [
          Image.network("https://img.freepik.com/premium-vector/happy-family-couple-with-shopping-man-woman-with-bags-big-sale-illustration_165429-519.jpg"),
          Text("Opps ! You need Premium", style : TextStyle( fontSize: 20, fontWeight: FontWeight.w700) ),
          Text("Unlock now to get Premium Services", style : TextStyle( fontSize: 17, fontWeight: FontWeight.w400) ),
          SizedBox(height : 10),
          t("Unlimited Chats"),
          t("See Full Profile"),
          t("Call / Video Call"),
          t("No Ads"),
          SizedBox(height : 20),
          Center(
            child: InkWell(
              onTap : () async {
                setState(() {
                  rou = true ;
                });
                purchaseFirstOffering( context);
              },
              child: Container(
                  width : MediaQuery.of(context).size.width - 50, height : 60,
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
                  child : Padding(
                      padding: const EdgeInsets.all(17.0),
                      child: rou ? Center(child: CircularProgressIndicator()) : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Icon(Icons.payments, color : Colors.white),
                          SizedBox(width : 20),
                          Text("Buy at ₹99 / Month", style : TextStyle(color : Colors.white, fontSize : 20)),
                        ],
                      )
                  )
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget t(String st){
    return ListTile(
        leading: Icon(Icons.verified, color : Colors.green),
        title : Text(st)
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
          print("Purchase failed");setState(() {
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
                  width: 80, height: 10,
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
                        leading: Icon(Icons.credit_card,color : Colors.red),
                        title: Text(offer.offeringId.toString()),
                        subtitle: Text(offer.skus!.join(", ")), // Assuming `offer.skus` is a list of strings
                        onTap: () {
                          onClickedSku(offer.skus!.first); // Handle SKU clicked
                        },trailing: Container(
                        width : MediaQuery.of(context).size.width/3 - 20, height : 30,
                        decoration: BoxDecoration(
                            color: Colors.white70, // Background color of the container
                            borderRadius: BorderRadius.circular(10.0), // Rounded corners
                            border: Border.all(color: Color(0xffE9075B), width: 2
                            )
                        ),
                        child : Padding(
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

