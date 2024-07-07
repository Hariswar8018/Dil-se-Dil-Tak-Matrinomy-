import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_cloud_messaging_flutter/firebase_cloud_messaging_flutter.dart';
import 'package:flutter/material.dart';

class Send{
  static Future<void> sendNotificationsToTokens(String name, String desc,String tokens) async {
    var server = FirebaseCloudMessagingServer(
      serviceAccountFileContent,
    );

    var result = await server.send(
      FirebaseSend(
        validateOnly: false,
        message: FirebaseMessage(
          notification: FirebaseNotification(
            title: name,
            body: desc,
          ),
          android: FirebaseAndroidConfig(
            ttl: '3s', // Optional TTL for notification
            /// Add Delay in String. If you want to add 1 minute delay then add it like "60s"
            notification: FirebaseAndroidNotification(
              icon: 'ic_notification', // Optional icon
              color: '#009999', // Optional color
            ),
          ),
          token: tokens, // Send notification to specific user's token
        ),
      ),
    );

    // Print request response
    print(result.toString());
  }
  static void message(BuildContext context,String str, bool green) async{
    await Flushbar(
      titleColor: Colors.white,
      message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.linear,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: green?Colors.green:Colors.red,
      boxShadows: [BoxShadow(color: Colors.blue, offset: Offset(0.0, 2.0), blurRadius: 3.0)],
      backgroundGradient: green?LinearGradient(colors: [Colors.green, Colors.green.shade400]):LinearGradient(colors: [Colors.red, Colors.redAccent.shade400]),
      isDismissible: false,
      duration: Duration(seconds: 3),
      icon: green? Icon(
        Icons.verified,
        color: Colors.white,
      ): Icon(
        Icons.warning,
        color: Colors.white,
      ),
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.white,
      messageText: Text(
        str,
        style: TextStyle(fontSize: 16.0, color: Colors.white, fontFamily: "ShadowsIntoLightTwo"),
      ),
    ).show(context);
  }

  static final serviceAccountFileContent = <String, String>{
    'type': "service_account",
    'project_id':"adeota-94588",
    'private_key_id': "95c2bc237deeac02ec5a0dfc56aaa71c3212a15e",
    'private_key':"-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQClM9KfR9VjB4co\nqLzvWJa174Mw0PaFIiPGe92QYv6aavahx85lGbpqeL7YOdiHxZYHPnXwAAr8YfGU\nwRmUyVVqYclw8ga/nM/xqhVnmHRM3pM2IKyRhq8o8idIkXEW13MitCkVnw4Xcfgm\nJxNnn8aGCQ90V3INC7M6BK21/HBr+kYuG/W2u5og1kkJL6L09a2dJ21y1nItuOAb\ndVaAQY4/7WGSlsKbSFMRiYu0tx5LIngf7OeBz8KiDGSr3G7L31d1DFxPNw5lJ5xf\nQcJROAj4K2qNkk8S1S/xgrQN7PFL4SL6PCukQNv3bEOpL9QLj0rHjkrKwWi2btR+\ncrmHGxNLAgMBAAECggEAAndwHR2y82wQ2gwO6hnuAiBl2ow8Kge09gkyaS35NDAF\np6u2iq7kKCPOYacXcwuBrnEBzMgLYfJKa5ioe5637kMwgUWz0ReTyT1rXWUa02z9\nULETMocKxXc8G+rD//3Og8Wh2WdLDBGRDWzG7uSlT6oB95A4rTYwAl1AhLeUrCAF\n0qe+v5/kHGkXvaOsP7Z0gAwtJKPUIIEvhU5u3ibkgJUk4SUDpm7rsuwBUGsBnMWu\nDpeN7o9LxWqOHAmflDHKYH10Inmn53xs/KonsnYu3JeCeV1TqMecZF3itInl6ZR6\nWQZV8/gtM9AmMn7Ejev6clFvY8P0PEDoeLS2zGaWvQKBgQC70LlGl/Pri4p7MqWo\nz7VGjM1w2LjGh2m++lKQh8bw/8ZKhdIT2mrxZgh5nAUYGwTsQpswCypd18G5VPHH\nM5PU83YKJZtgZRyvR5hgaNnZw+fcA66AW3dxR1wcicXkkfqw7rzm6Hw7LOQjmfVB\ny78aY/uOqz9hHCnuOR6o6l+8dQKBgQDhLX2Gmjr/NzBLOfqiyvAHLXn8Y3GVEA36\naTnAMVBzyh8e0rchwFKvi2bYsJ2cBrPDhP3cD6MVVN4WlNxdmkqTTr7XFiv/VBGa\nyakGs2uSz7PoTxOMPFTvdqs3hQqLnrhJn4diepbt+SPKE/J7C73HZlnoaoEdIeJW\nvV2c8aiYvwKBgD7uDdZofbNTux/SdY1do0izTvbbtvXWU4lJCLcit3byzLcVpbE/\nQwwFext8Ony8OOcM3kC3zQdKjr+Rhb2QO51jwg5eUXR4DKdyXs0W9L+xk5O1rBeY\nDipnlaZ+R09x1kTIiYT5Kv8M6JhBMttL8IlgLN695GueazJF80730QItAoGAcY14\nJJ24LKWPFBB75QZDvsrfHjijuZDsC6BuwA3eTVXbFbcbJMkQqXe5+IIwKNN0aZ+y\nSPwVuJcgm/CbpBQ/kUN/l4WV0F97tTwGodtu3w0g44ClEe4Gwu9r7kaIB9qVgoMR\nSccaP42Iz8n5WLWWEWz63+p9i8xfkHBUOeXfqI8CgYEAp5poiXFc+TaY6inmeqZn\n1Y/nxniaGvfNMShPeg4jO5YdA2V/e45oAfe2J3qh2KwWM4hWpxtnV+wDlEApjZ//\nHCjkagPVMi8RPjTfdSiUiGfUlYmEJLJWibggHpc5aHjopmRlr4BHOrQEog+1y6Uh\nRNAbkswHHAfcIVkR7pO7tQs=\n-----END PRIVATE KEY-----\n",
    'client_email':"firebase-adminsdk-qz832@adeota-94588.iam.gserviceaccount.com",
    'client_id':"103197212188148621752",
    'auth_uri':  "https://accounts.google.com/o/oauth2/auth",
    'token_uri':  "https://oauth2.googleapis.com/token",
    'auth_provider_x509_cert_url': "https://www.googleapis.com/oauth2/v1/certs",
    'client_x509_cert_url': "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-qz832%40adeota-94588.iam.gserviceaccount.com",
  };
}