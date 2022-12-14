import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tree_boddy/resources/storage_methods.dart';
import 'package:tree_boddy/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    //required Uint8List file,
  }) async {
    String res = "Some error occoured";

    try {
      if (email.isNotEmpty ||
              password.isNotEmpty ||
              username.isNotEmpty ||
              bio.isNotEmpty
          // ignore: unnecessary_null_comparison
          ) {
        //resiter user
        UserCredential userCre = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(userCre.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', /*file,*/ false);

        model.User user = model.User(
          username: username,
          uid: userCre.user!.uid,
          // photoUrl: photoUrl,
          email: email,
          bio: bio,
          followers: [],
          following: [],
        );
        //add user to dastore
        await _firestore
            .collection("users")
            .doc(userCre.user!.uid)
            .set(user.toJson());

        return 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }
}
