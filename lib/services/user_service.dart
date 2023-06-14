import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivedoctor/bloc/models/user.dart';

class UserService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<UserData> getUser(String userId) async {
    try {
      final DocumentSnapshot userSnapshot =
          await _usersCollection.doc(userId).get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        return UserData(
          id: userId,
          username: userData['username'],
          fullname: userData['fullname'],
          contact: userData['contact'],
        );
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }

  Future<String> getUserFullName(String userId) async {
    try {
      final UserData user = await getUser(userId);
      return user.fullname;
    } catch (e) {
      throw Exception('Failed to fetch user full name: $e');
    }
  }

  Future<UserData?> getUserDataById(String userId) async {
    try {
      final DocumentSnapshot userSnapshot =
          await _usersCollection.doc(userId).get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        return UserData(
          id: userId,
          username: userData['username'],
          fullname: userData['fullname'],
          contact: userData['contact'],
        );
      } else {
        return null; // User not found
      }
    } catch (e) {
      throw Exception('Failed to fetch user data: $e');
    }
  }
}
