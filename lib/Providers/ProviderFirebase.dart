import 'dart:developer';

import 'package:background_locator_example/Models/CarSpeed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProviderFirebase {
  // When you click on stop, upload?
  // Upload every 60 seconds
  static Future<UserCredential> login(String user, String pass) {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: '$user@gmail.com', password: pass);
  }

  static Future<void> logout() {
    return FirebaseAuth.instance.signOut();
  }

  static Stream<QuerySnapshot> listenToDevice(String deviceID) {
    return FirebaseFirestore.instance.collection(deviceID).snapshots();
  }

  static autologin() {
    if (FirebaseAuth.instance.currentUser == null) {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: 'tracker@gmail.com', password: 'tracker')
          .then((value) {
        log("logged in");
      }).catchError((onError) {
        log("error loging in");
      });
    } else {
      log("logged in");
    }
  }

  static uploadToFirebase(List<CarSpeed> data, String deviceID) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(deviceID)
        .add({'list': data.map((e) => e.toMap()).toList()});
  }
}
