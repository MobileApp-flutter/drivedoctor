import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivedoctor/bloc/models/services.dart';

class ServiceController {
  final CollectionReference serviceCollection =
      FirebaseFirestore.instance.collection('services');

  //get all services
  Future<List<ServiceData>> getServices() async {
    try {
      final QuerySnapshot snapshot = await serviceCollection.get();

      return snapshot.docs.map((doc) => ServiceData.fromSnapshot(doc)).toList();
    } catch (error) {
      print('Error fetching services: $error');
      return [];
    }
  }

  //get services by shopId
  Future<List<ServiceData>> getServicesByShopId(String shopId) async {
    try {
      final QuerySnapshot snapshot =
          await serviceCollection.where('shopId', isEqualTo: shopId).get();

      return snapshot.docs.map((doc) => ServiceData.fromSnapshot(doc)).toList();
    } catch (error) {
      print('Error fetching services: $error');
      return [];
    }
  }

  //get service by id
  Future<ServiceData?> getServiceById(String serviceId) async {
    try {
      final DocumentSnapshot snapshot =
          await serviceCollection.doc(serviceId).get();

      if (snapshot.exists) {
        return ServiceData.fromSnapshot(snapshot);
      } else {
        print('Service not found');
        return null;
      }
    } catch (error) {
      print('Error fetching service: $error');
      return null;
    }
  }
}
