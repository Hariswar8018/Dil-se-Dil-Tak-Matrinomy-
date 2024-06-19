import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    required this.Email,
    required this.Name,
    required this.uid ,
    required this.smoke,
  required this.bday,
  required this.weight,
  required this.height,
  required this.education,
  required this.drink,
  required this.gender,
  required this.hobbies,
  required this.looking,
  required this.relationship,
  required this.work,
  required this.address,
  required this.country,
  required this.lat,
  required this.lon,
  required this.state,
    required this.pic,
  required this.s1,
  required this.s2,
  required this.s3,
  required this.s4,
  required this.s5,
    required this.lastlogin,
    required this.online,
    required this.follower,
    required this.following,
    required this.premium, required this.distance, required this.age1, required this.age2,
    required this.phone,
  });
  late final String lastlogin ;
  late final bool online ;
  late final List follower  ;
  late final List following ;
  late final String pic ;
  late final String Email;
  late final bool premium ;
  late final String Name;
  late final String uid;
  late final String education ;
  late final String work ;
  late final String height ;
  late final String weight ;
  late final String bday ;
  late final String gender ;
  late final String looking ;
  late final List hobbies ;
  late final String smoke ;
  late final String drink ;
  late final String relationship ;
  late final double lat ;
  late final double lon ;
  late final String country ;
  late final String state ;
  late final String address ;
  late final String s1 ;
  late final String s2 ;
  late final String s3 ;
  late final String s4 ;
  late final String s5 ;
  late final String phone ;
  late  double distance ;
  late  double age1 ;
  late  double age2 ;

  UserModel.fromJson(Map<String, dynamic> json) {
    phone = json['phone'] ?? "7978097489";
    distance  = json['dis'] ?? 170.0 ;
    age1 = json['age1'] ?? 18.0;
    age2 = json['age2'] ?? 35.0;
    s1 = json['s1'] ?? " ";
    s2 = json['s2'] ?? " ";
    s3 = json['s3'] ?? " ";
    s4 = json['s4'] ?? " ";
    s5 = json['s5'] ?? " ";
    lastlogin = json['last'] ?? "2024-06-01 19:14:41.231388";
    online = json['online'] ?? false ;
    lat = json['lat'] ?? 26.907524;
    lon = json['lon'] ?? 75.739639 ;
    country = json['country'] ?? 'IN';
    state = json['state'] ?? 'Odisha';
    address = json['address'] ?? '45+ WT, Kolkata,  Odisha ';
    pic = json['pic'] ?? "";
    Email = json['Email'] ?? 'haiswar@gmail.com';
    Name = json['name'] ?? 'Nijono Yume';
    uid = json['uid'] ?? '';
    education = json['education'] ?? '+2 Science';
    work = json['work'] ?? 'Engineer';
    height = json['height'] ?? '145';
    weight = json['weight'] ?? '65';
    bday = json['bday'] ?? '';
    gender = json['gender'] ?? 'Male';
    premium = json['p'] ?? false ;
    looking = json['looking'] ?? 'Long Term Relationship';
    hobbies = json['hobbies'] ?? [];
    smoke = json['smoke'] ?? 'Never';
    drink = json['drink'] ?? 'Never';
    relationship = json['relationship'] ?? "Single";
    follower = json['Followers'] ?? [];
    following = json['Following'] ?? [];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['p'] = premium ;
    data['phone'] = phone ;
    data['Followers']  = follower ;
    data['following'] = following ;
    data['lat'] = lat ;
    data['lon']= lon  ;
     data['country'] = country ;
     data['state']  = state ;
    data['address'] = address;
    data['email'] = Email;
    data['name'] = Name;
    data['uid'] = uid;
    data['education'] = education;
    data['work'] = work;
    data['height'] = height;
    data['weight'] = weight;
    data['bday'] = bday;
    data['gender'] = gender;
    data['looking'] = looking;
    data['hobbies'] = hobbies;
    data['smoke'] = smoke;
    data['pic'] = pic ;
    data['online'] = online ;
    data['last'] = lastlogin ;
    data['drink'] = drink;
    data['relationship'] = relationship;
    data['s1'] = s1 ;
    data['s2'] = s2 ;
    data['s3'] = s3 ;
    data['s4'] = s4 ;
    data['dis'] = distance ;
    data['age1'] = age1 ;
    data['age2'] = age2 ;
    data['s5'] = s5 ;
    return data;
  }


  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel.fromJson(snapshot);
  }
}