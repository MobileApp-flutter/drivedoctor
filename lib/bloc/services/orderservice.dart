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
    required String? shopId,
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
      'shopId': shopId,
      'service': service.map((e) => e.toJson()).toList(),
    };

    await orderDoc.set(orderData);
  }

  //create order only with product
  Future createOrderProduct({
    required String orderType,
    required String? userId,
    required List<ProductData> product,
    required double totalPrice,
  }) async {
    final orderDoc = FirebaseFirestore.instance.collection('orders').doc();
    final orderId = orderDoc.id;

    final orderData = {
      'orderId': orderId,
      'orderType': orderType,
      'orderdatecreate': Timestamp.fromDate(orderdatecreate),
      'orderdateupdate': Timestamp.fromDate(orderdateupdate),
      'userId': userId,
      'product': product.map((e) => e.toJson()).toList(),
      'totalPrice': totalPrice,
    };

    await orderDoc.set(orderData);
  }

  //update order service status
  Future<void> updateOrder({
    String? orderId,
    String? orderStatus,
  }) async {
    final docOrder = FirebaseFirestore.instance
        .collection('orders')
        .where('orderId', isEqualTo: orderId);

    final dataToUpdate = <String, dynamic>{};

    if (orderStatus != null && orderStatus.isNotEmpty) {
      dataToUpdate['orderStatus'] = orderStatus;
    }

    //retreive the first matching document and then update it with new data
    await docOrder.get().then((value) {
      value.docs.first.reference.update(dataToUpdate);
    });
  }

  //update order product status
  Future<void> updateOrderProduct({
    String? productId,
    String? productStatus,
  }) async {
    final docOrder = FirebaseFirestore.instance
        .collection('orders')
        .where('product.productStatus', isEqualTo: productStatus);

    final dataToUpdate = <String, dynamic>{};

    if (productStatus != null && productStatus.isNotEmpty) {
      dataToUpdate['orderStatus'] = productStatus;
    }

    //retreive the first matching document and then update it with new data
    await docOrder.get().then((value) {
      value.docs.first.reference.update(dataToUpdate);
    });
  }
}
