import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceData {
  final String servicename;
  final String serviceprice;
  final String waittime;
  final String servicedesc;

  ServiceData({
    required this.servicename,
    required this.serviceprice,
    required this.waittime,
    required this.servicedesc,
  });

  factory ServiceData.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return ServiceData(
      servicename: data['servicename'],
      serviceprice: data['serviceprice'],
      waittime: data['waittime'],
      servicedesc: data['servicedesc'],
    );
  }
}
