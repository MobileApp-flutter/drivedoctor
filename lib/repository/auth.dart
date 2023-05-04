import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static User? get currentUser => auth.currentUser;
  static String get email => currentUser?.email ?? 'Guest';
}
