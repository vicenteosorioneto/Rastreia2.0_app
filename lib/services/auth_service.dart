import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' show Platform;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // Simulate successful login for web platforms
        throw UnimplementedError(
            'Firebase Auth is not available on web platforms yet');
      }
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
    String document,
    String userType,
  ) async {
    try {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // Simulate successful registration for web platforms
        throw UnimplementedError(
            'Firebase Auth is not available on web platforms yet');
      }

      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add user data to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'document': document,
        'userType': userType,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // Simulate successful logout for web platforms
        return;
      }
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // Return mock data for web platforms
        return null;
      }
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(currentUser?.uid).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      rethrow;
    }
  }
}
