import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String? id;
  final String username;
  final String fullname;
  final int contact;

  UserData({
    this.id,
    required this.username,
    required this.fullname,
    required this.contact,
  });

  factory UserData.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return UserData(
      id: snapshot.id,
      contact: data['contact'],
      fullname: data['fullname'],
      username: data['username'],
    );
  }
}
