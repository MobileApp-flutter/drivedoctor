import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceData {
  final String serviceId;
  final String servicename;
  final String serviceprice;
  final String waittime;
  final String servicedesc;
  final String shopId;

  ServiceData({
    required this.serviceId,
    required this.servicename,
    required this.serviceprice,
    required this.waittime,
    required this.servicedesc,
    required this.shopId,
  });

  factory ServiceData.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    // final images = (data['images'] as List<dynamic>)
    //     .map((imageUrl) => imageUrl as String)
    //     .toList();

    return ServiceData(
      serviceId: snapshot.id,
      servicename: data['servicename'],
      serviceprice: data['serviceprice'],
      waittime: data['waittime'],
      servicedesc: data['servicedesc'],
      shopId: data['shopId'],
    );
  }
}
