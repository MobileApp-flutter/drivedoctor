import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceData {
  final String servicename;
  final String serviceprice;
  final String waittime;

  ServiceData({
    required this.servicename,
    required this.serviceprice,
    required this.waittime,
  });

  factory ServiceData.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return ServiceData(
      servicename: data['servicename'],
      serviceprice: data['serviceprice'],
      waittime: data['waittime'],
    );
  }
}
