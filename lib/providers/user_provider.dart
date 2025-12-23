import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';

class UserProvider extends ChangeNotifier {
  AppUser? _user;

  AppUser? get user => _user;

  bool get isLoaded => _user != null;

  Future<void> loadUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    if (!doc.exists) return;

    _user = AppUser.fromMap(
      uid: firebaseUser.uid,
      data: doc.data()!,
    );

    notifyListeners();
  }

  void clear() {
    _user = null;
    notifyListeners();
  }
}
