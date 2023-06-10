import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  //get current user uid
  final FirebaseAuth auth = FirebaseAuth.instance;

  //profile picture
  Future<void> uploadProfilePicture(
    String filePath,
    String fileName,
  ) async {
    //get current user uid
    String uid = auth.currentUser!.uid;

    File file = File(filePath);

    try {
      await storage.ref('users/$uid/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  //select multiple images (services and products)
  Future<void> selectImages(List<File> selectedImages) async {
    final List<XFile> selectedFiles = await ImagePicker().pickMultiImage();
    selectedImages.addAll(selectedFiles.map((e) => File(e.path)));
  }

  //upload multiple images (services and products)
  Future<void> uploadImages(
    List<File> selectedImages,
    String serviceId, //serviceid
  ) async {
    try {
      for (int i = 0; i < selectedImages.length; i++) {
        await storage
            .ref('shops/services/$serviceId/image_$i.jpg')
            .putFile(selectedImages[i]);
      }
    } on firebase_core.FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  //fetch multiple images (services and products)
  Future<List<String>> fetchImages(String serviceId) async {
    List<String> downloadURL = await storage
        .ref('shops/services/$serviceId')
        .listAll()
        .then((value) => value.items)
        .then((value) => value.map((e) => e.getDownloadURL()))
        .then((value) => Future.wait(value))
        .then((value) => value.map((e) => e.toString()).toList());

    return downloadURL;
  }

  //upload shop picture
  Future<void> uploadShopProfilePic(
    String filePath,
    String fileName,
    String shopId,
  ) async {
    File file = File(filePath);

    try {
      await storage.ref('shops/$shopId/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  //fetch profile picture
  Future<String> fetchProfilePicture(String imageName) async {
    //get current user uid
    String uid = auth.currentUser!.uid;

    String downloadURL = await storage
        .ref('users/$uid/$imageName')
        .getDownloadURL()
        .then((value) => value.toString());

    return downloadURL;
  }

  //fetch shop profile picture
  Future<String> fetchShopProfilePicture(
      String shopId, String imageName) async {
    String downloadURL = await storage
        .ref('shops/$shopId/$imageName')
        .getDownloadURL()
        .then((value) => value.toString());

    return downloadURL;
  }

  //get download url
  Future<String> getDownloadURL(String path) async {
    String downloadURL = await storage
        .ref(path)
        .getDownloadURL()
        .then((value) => value.toString());

    return downloadURL;
  }

  //fetch shop image based on matching shopId on storage path and document
  //NOTE: I CAN'T WORK ON THE LOGIC. SO I WON'T USE THIS METHOD FIRST
  Future<String> fetchShopImage(String imageName) async {
    // Get array of shopIds from Cloud Firestore
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('shops').get();

    // Get shopId from array of shopIds
    String shopId = snapshot.docs.map((doc) => doc['shopId']).single;

    // Map if the shopId matches any shopId in Firebase Storage path
    String matchingShopId = snapshot.docs
        .map((doc) => doc['shopId'])
        .firstWhere((shopId) => shopId == shopId, orElse: () => null);

    if (matchingShopId == null) {
      // ShopId not found, handle the error or return a default image URL
      return 'DEFAULT_IMAGE_URL';
    }

    // Get shop image from the storage path
    String downloadURL = await storage
        .ref('shops/$matchingShopId/$imageName')
        .getDownloadURL()
        .then((value) => value.toString());

    return downloadURL;
  }

  // Future<firebase_storage.ListResult> listFiles() async {
  //   firebase_storage.ListResult results = await storage.ref('test').listAll();

  //   results.items.forEach((firebase_storage.Reference ref) {
  //     print('Found files: $ref');
  //   });

  //   return results;
  // }
}
