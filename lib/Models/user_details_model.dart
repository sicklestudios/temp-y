import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailsModel {
  String? name;
  String? email;
  String? uid;
  String? phone;
  String? image;
  String? d_o_b;
  String? userType;
  Timestamp? createdAt;
  List<dynamic>? interest;
  String? gender;
  String? token;

  UserDetailsModel(
      {this.name,
      this.email,
      this.uid,
      this.phone,
      this.image,
      this.d_o_b,
      this.userType,
      this.createdAt,
      this.interest,
      this.gender,
      this.token});

  factory UserDetailsModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    return UserDetailsModel(
      name: documentSnapshot.get("name"),
      email: documentSnapshot.get("email"),
      uid: documentSnapshot.get("user_id").toString(),
      phone: documentSnapshot.get("phone"),
      image: documentSnapshot.get("image"),
      d_o_b: documentSnapshot.get("d_o_b"),
      userType: documentSnapshot.get("user_type"),
      createdAt: documentSnapshot.get("created_at"),
      interest: documentSnapshot.get("interest"),
      gender: documentSnapshot.get('gender'),
      token: documentSnapshot.get('token') ?? null,
    );
  }
}
