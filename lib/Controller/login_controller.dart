// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qiu_digital_guidance/View/guest_home.dart';
import 'package:qiu_digital_guidance/View/staff%20view/add_events.dart';
import 'package:qiu_digital_guidance/View/student_home.dart';

class LoginController extends ChangeNotifier {
  String email = '';
  String password = '';
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  String? validateEmail(String? value) {
    if (value == null || !value.contains('@')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null ||
        value.length < 6 ||
        value.length > 10 ||
        !value.contains(RegExp(r'[0-9]')) ||
        !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'must be 6-10 also contain symbols and numbers';
    }
    return null;
  }

  //function to login using email and password
  Future<void> login({
    required BuildContext context,
  }) async {
    try {
      // Sign in with email and password
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Get the currently signed-in user
      User? user = FirebaseAuth.instance.currentUser;

      // Check if the user is not null
      if (user != null) {
        // Access the Firestore collection 'staff' and check the user's role
        DocumentSnapshot staffDoc = await FirebaseFirestore.instance
            .collection('Staff')
            .doc(user.uid)
            .get();
        if (staffDoc.exists) {
          String role = staffDoc['role'];

          // Check if the user's role is 'staff'
          if (role == 'Staff') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AddEvents(),
              ),
            );
            return;
          }
        }

        // If the user is not a staff member, navigate to the default home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const StudentHomePage(),
          ),
        );
      }
    } on FirebaseAuthException {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Invalid Email or Password'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> signInAnonymously(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const GuestHomePage(),
        ),
      );
    } catch (e) {
      debugPrint("Error signing in anonymously: $e");
    }
  }
}
