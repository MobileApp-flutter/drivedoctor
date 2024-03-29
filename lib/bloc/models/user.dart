import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String? id;
  late final String username;
  late final String fullname;
  late final int contact;
  String status;

  UserData({
    this.id,
    required this.username,
    required this.fullname,
    required this.contact,
    String? status,
  }): status = status ?? "regular";

  factory UserData.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return UserData(
      id: snapshot.id,
      contact: data['contact'],
      fullname: data['fullname'],
      username: data['username'],
      status: data['status'] ?? "regular",
    );
  }
}
