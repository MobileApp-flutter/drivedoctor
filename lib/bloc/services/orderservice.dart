import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivedoctor/bloc/models/product.dart';
import 'package:drivedoctor/bloc/models/services.dart';

class OrderService {
  //create and update date
  final DateTime orderdatecreate = DateTime.now();
  final DateTime orderdateupdate = DateTime.now();

  //create order only with service
  Future createOrderService({
    required String orderType,
    required String orderStatus,
    required String? userId,
    required List<ServiceData> service,
  }) async {
    final orderDoc = FirebaseFirestore.instance.collection('orders').doc();
    final orderId = orderDoc.id;

    final orderData = {
      'orderId': orderId,
      'orderType': orderType,
      'orderStatus': orderStatus,
      'orderdatecreate': Timestamp.fromDate(orderdatecreate),
      'orderdateupdate': Timestamp.fromDate(orderdateupdate),
      'userId': userId,
      'service': service.map((e) => e.toJson()).toList(),
    };

    await orderDoc.set(orderData);
  }

  //create order only with product
  Future createOrderProduct({
    required String orderType,
    required String orderStatus,
    required String email,
    required String shopId,
    required String userId,
    required List<ProductData> product,
  }) async {
    final orderDoc = FirebaseFirestore.instance.collection('orders').doc();
    final orderId = orderDoc.id;

    final orderData = {
      'orderId': orderId,
      'orderType': orderType,
      'orderStatus': orderStatus,
      'orderdatecreate': Timestamp.fromDate(orderdatecreate),
      'orderdateupdate': Timestamp.fromDate(orderdateupdate),
      'userId': userId,
      'product': product.map((e) => e.toJson()).toList(),
    };

    await orderDoc.set(orderData);
  }
}
