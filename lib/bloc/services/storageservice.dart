import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/foundation.dart';

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
