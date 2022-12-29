import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ihvan_kardesler/models/kullanici.dart';
import '../components/utils.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChange => auth.authStateChanges();

  Future<void> signinUser(String email, String password, BuildContext context) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseException catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signupUser(String name, String email, String password, BuildContext context) async {
    try {
      UserCredential userCred =
          await auth.createUserWithEmailAndPassword(email: email, password: password);
      Kullanici kullanici = Kullanici(
        uid: userCred.user!.uid,
        name: name,
        email: email,
        password: password,
        group: '',
        isAdmin: false,
      );
      firestore.collection('kullanicilar').doc(userCred.user!.uid).set(kullanici.toMap());
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signoutUser() async {
    await auth.signOut();
  }
}
