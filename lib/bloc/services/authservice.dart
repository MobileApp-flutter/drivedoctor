import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivedoctor/bloc/models/user.dart';
import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthService {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static Stream<UserData?> get userDataStream {
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid);
    return userDoc.snapshots().map(
        (snapshot) => snapshot.exists ? UserData.fromSnapshot(snapshot) : null);
  }
}

//password recovery
Future<void> resetPassword({
  required String email,
  required BuildContext context,
}) async {
  try {
    await AuthService.auth.sendPasswordResetEmail(email: email);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password reset email sent'),
      ),
    );
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.message ?? 'An error occurred'),
      ),
    );
  }
}

//sign out
Future<void> signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, login);
  } catch (e) {
    if (kDebugMode) {
      print('Error signing out: $e');
    }
  }
}
