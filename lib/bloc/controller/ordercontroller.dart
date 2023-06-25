import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivedoctor/bloc/controller/auth.dart';
import 'package:drivedoctor/bloc/models/order.dart';
import 'package:drivedoctor/bloc/models/product.dart';
import 'package:drivedoctor/bloc/models/services.dart';
import 'package:flutter/foundation.dart';

class OrderController {
  final CollectionReference orderCollection =
      FirebaseFirestore.instance.collection("orders");

  //get all orders by UserID
  Future<List<OrderData>> getOrdersByUserID() async {
    try {
      final QuerySnapshot snapshot =
          await orderCollection.where('userId', isEqualTo: Auth.uid).get();

      final List<OrderData> orders = [];

      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        if (data.containsKey('service')) {
          final List<dynamic> serviceDataList =
              data['service'] as List<dynamic>;
          final List<ServiceData> service = serviceDataList
              .map((e) => ServiceData.fromJson(e as Map<String, dynamic>))
              .toList();

          final order = OrderData.fromSnapshotService(doc, service);
          orders.add(order);
        } else if (data.containsKey('product')) {
          final List<dynamic> productDataList =
              data['product'] as List<dynamic>;
          final List<ProductData> product = productDataList
              .map((e) => ProductData.fromJson(e as Map<String, dynamic>))
              .toList();

          final order = OrderData.fromSnapshotProduct(doc, product);
          orders.add(order);
        }
      }

      return orders;
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching orders: $error');
      }
      return [];
    }
  }

  //get all pending order
  Future<List<OrderData>> getOrdersByShopID(String shopId) async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('shopId', isEqualTo: shopId)
          .where('orderStatus', isEqualTo: 'pending')
          .get();

      List<OrderData> orders = [];

      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        if (data.containsKey('service')) {
          final List<dynamic> serviceDataList =
              data['service'] as List<dynamic>;
          final List<ServiceData> service = serviceDataList
              .map((e) => ServiceData.fromJson(e as Map<String, dynamic>))
              .toList();

          final order = OrderData.fromSnapshotService(doc, service);
          orders.add(order);
        } else if (data.containsKey('product')) {
          final List<dynamic> productDataList =
              data['product'] as List<dynamic>;
          final List<ProductData> product = productDataList
              .map((e) => ProductData.fromJson(e as Map<String, dynamic>))
              .toList();

          final order = OrderData.fromSnapshotProduct(doc, product);
          orders.add(order);
        }
      }

      return orders;
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching orders: $error');
      }
      return [];
    }
  }

  //get all completed order by shopId
  Future<List<OrderData>> getCompleteOrdersByShopID(String shopId) async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('shopId', isEqualTo: shopId)
          .where('orderStatus', isEqualTo: 'complete')
          .get();

      List<OrderData> orders = [];

      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        if (data.containsKey('service')) {
          final List<dynamic> serviceDataList =
              data['service'] as List<dynamic>;
          final List<ServiceData> service = serviceDataList
              .map((e) => ServiceData.fromJson(e as Map<String, dynamic>))
              .toList();

          final order = OrderData.fromSnapshotService(doc, service);
          orders.add(order);
        } else if (data.containsKey('product')) {
          final List<dynamic> productDataList =
              data['product'] as List<dynamic>;
          final List<ProductData> product = productDataList
              .map((e) => ProductData.fromJson(e as Map<String, dynamic>))
              .toList();

          final order = OrderData.fromSnapshotProduct(doc, product);
          orders.add(order);
        }
      }

      return orders;
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching orders: $error');
      }
      return [];
    }
  }
}
