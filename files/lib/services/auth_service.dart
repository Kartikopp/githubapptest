import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  // Sign Up with Email and Password
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel user = UserModel(
        id: userCredential.user!.uid,
        email: email,
        name: name,
        phone: phone,
        createdAt: DateTime.now(),
        isAdmin: false,
      );

      await _firestore.collection('users').doc(user.id).set(user.toMap());

      return user;
    } on FirebaseAuthException catch (e) {
      throw _getAuthErrorMessage(e.code);
    }
  }

  // Login with Email and Password
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
      
      return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
    } on FirebaseAuthException catch (e) {
      throw _getAuthErrorMessage(e.code);
    }
  }

  // Google Sign In
  Future<UserModel?> googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
      
      if (!userDoc.exists) {
        UserModel newUser = UserModel(
          id: userCredential.user!.uid,
          email: googleUser.email,
          name: googleUser.displayName ?? 'User',
          phone: '',
          profilePhotoUrl: googleUser.photoUrl,
          createdAt: DateTime.now(),
        );
        await _firestore.collection('users').doc(newUser.id).set(newUser.toMap());
        return newUser;
      }

      return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
    } catch (e) {
      throw 'Google Sign In failed: $e';
    }
  }

  // Forgot Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _getAuthErrorMessage(e.code);
    }
  }

  // Logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  // Get Current User
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Check if user is logged in
  bool isUserLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }

  String _getAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'User not found. Please check your email.';
      case 'wrong-password':
        return 'Wrong password. Please try again.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'invalid-email':
        return 'Invalid email address.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}