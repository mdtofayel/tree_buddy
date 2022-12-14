import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tree_boddy/models/user.dart' as model;

import '../providers/user_provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  String username = "";
  @override
  void initState() {
    super.initState();
    getUser();
    // addData();
  }

  void getUser() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    // setState(() {
    //   username = (snap.data() as Map<String, dynamic>)['username'].toString();
    // });
    print(
      "Mta testing " + snap.data().toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // model.User user = Provider.of<UserProvider>(context).getUser;
    // print(user.toString());
    return const Scaffold(
      //   body: Center(
      //     child: Text(
      //       user.email,
      //       style: const TextStyle(
      //         color: Color.fromARGB(255, 73, 113, 169),
      //       ),
      //     ),
      //   ),
      body: Center(
        child: Text('Hi mta you are failed'),
      ),
    );
  }
}
