import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivedoctor/bloc/models/product.dart';
import 'package:drivedoctor/bloc/models/services.dart';

class OrderData {
  final String orderId;
  final String orderType;
  String? orderStatus;
  final Timestamp orderDateCreate;
  final Timestamp orderDateUpdate;

  //list of product
  final List<ProductData>? product;

  //list of service
  final List<ServiceData>? service;

  //userid
  final String userId;

  OrderData({
    required this.orderId,
    required this.orderType,
    this.orderStatus,
    required this.orderDateCreate,
    required this.orderDateUpdate,
    this.product,
    this.service,
    required this.userId,
  });

  //factory snapshot only on service list
  factory OrderData.fromSnapshotService(
      DocumentSnapshot snapshot, List<ServiceData> service) {
    final data = snapshot.data() as Map<String, dynamic>;

    return OrderData(
      orderId: snapshot.id,
      orderType: data['orderType'],
      orderStatus: data['orderStatus'],
      orderDateCreate: data['orderdatecreate'],
      orderDateUpdate: data['orderdateupdate'],
      service: service,
      userId: data['userId'],
    );
  }

  //factory snapshot only on product list
  factory OrderData.fromSnapshotProduct(
      DocumentSnapshot snapshot, List<ProductData> product) {
    final data = snapshot.data() as Map<String, dynamic>;

    return OrderData(
      orderId: snapshot.id,
      orderType: data['orderType'],
      // orderStatus: data['orderStatus'],
      orderDateCreate: data['orderdatecreate'],
      orderDateUpdate: data['orderdateupdate'],
      product: product,
      userId: data['userId'],
    );
  }
}
