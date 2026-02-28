import 'package:contacts_app/app/core/error/exceptions.dart';
import 'package:contacts_app/app/features/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class AuthRemoteDataSource {
  User? get currentSession;
  Future<UserModel> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  User? get currentSession => firebaseAuth.currentUser;

  @override
  Future<UserModel> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw ServerException('User is null');
      }

      // Save additional user data in Firestore
      await firestore.collection('users').doc(user.uid).set({
        'id': user.uid,
        'name': name,
        'email': email,
      });

      return UserModel(id: user.uid, name: name, email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Signup failed');
    }
  }

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw ServerException('User is null');
      }

      final userDoc = await firestore.collection('users').doc(user.uid).get();

      return UserModel.fromJson(userDoc.data()!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Login failed');
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      final user = firebaseAuth.currentUser;

      if (user == null) return null;

      final userDoc = await firestore.collection('users').doc(user.uid).get();

      return UserModel.fromJson(userDoc.data()!);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
