/*
ll

Color(0xffE9075B)

kk*/


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> saveToken(String userId) async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      await _firestore.collection('Users').doc(userId).update({
        'token': token,
      });
    }
  }
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
  }
}