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
      String id, //service or product id
      bool isService) async {
    try {
      String folderName = isService ? 'services' : 'products';

      for (int i = 0; i < selectedImages.length; i++) {
        await storage
            .ref('shops/$folderName/$id/image_$i.jpg')
            .putFile(selectedImages[i]);
      }
    } on firebase_core.FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  //fetch multiple images (services and products)
  Future<List<String>> fetchImages(String id, bool isService) async {
    String folderName = isService ? 'services' : 'products';

    List<String> downloadURL = await storage
        .ref('shops/$folderName/$id')
        .listAll()
        .then((value) => value.items)
        .then((value) => value.map((e) => e.getDownloadURL()))
        .then((value) => Future.wait(value))
        .then((value) => value.map((e) => e.toString()).toList());

    return downloadURL;
  }

  //delete images on give index array (services and products)
  Future<void> deleteImage(String id, bool isService, int index) async {
    // Fetch the list of images
    List<String> imageUrls = await fetchImages(id, isService);

    if (index >= 0 && index < imageUrls.length) {
      String imageUrl = imageUrls[index];

      // Delete the image from storage
      await storage.refFromURL(imageUrl).delete();
    }
  }

  //delete all images
  Future<void> deleteAllImages(String id, bool isService) async {
    // Fetch the list of images
    List<String> imageUrls = await fetchImages(id, isService);

    for (int i = 0; i < imageUrls.length; i++) {
      String imageUrl = imageUrls[i];

      // Delete the image from storage
      await storage.refFromURL(imageUrl).delete();
    }
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
}
