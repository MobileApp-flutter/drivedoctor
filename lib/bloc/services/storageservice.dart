import 'dart:io';

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
      await storage.ref('$uid/user/$fileName').putFile(file);
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
    //get current user uid
    String uid = auth.currentUser!.uid;

    try {
      for (int i = 0; i < selectedImages.length; i++) {
        await storage
            .ref('$uid/shop/services/$serviceId/image_$i.jpg')
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
    //get current user uid
    String uid = auth.currentUser!.uid;

    List<String> downloadURL = await storage
        .ref('$uid/shop/services/$serviceId')
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
  ) async {
    //get current user uid
    String uid = auth.currentUser!.uid;

    File file = File(filePath);

    try {
      await storage.ref('$uid/shop/$fileName').putFile(file);
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
        .ref('$uid/user/$imageName')
        .getDownloadURL()
        .then((value) => value.toString());

    return downloadURL;
  }

  //fetch shop profile picture
  Future<String> fetchShopProfilePicture(String imageName) async {
    //get current user uid
    String uid = auth.currentUser!.uid;

    String downloadURL = await storage
        .ref('$uid/shop/$imageName')
        .getDownloadURL()
        .then((value) => value.toString());

    return downloadURL;
  }

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult results = await storage.ref('test').listAll();

    results.items.forEach((firebase_storage.Reference ref) {
      print('Found files: $ref');
    });

    return results;
  }
}
