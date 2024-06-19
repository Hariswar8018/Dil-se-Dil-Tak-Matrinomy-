
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matrinomy/model/usermodel.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get getUser => _user;

  Future<void> refreshuser() async {
    UserModel user = await GetUser();
    _user = user;
    notifyListeners();
  }

  Future<UserModel> GetUser() async {
    String hhj = FirebaseAuth.instance.currentUser!.uid  ;
    print(hhj);
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('Users')
        .doc(hhj)
        .get();

    return UserModel.fromSnap(snap);
  }
}