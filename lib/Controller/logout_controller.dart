// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_qiu_guidance/Controller/login_controller.dart';
import 'package:e_qiu_guidance/View/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutController extends ChangeNotifier {
  void logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(LoginController.isLoggedInKey, false);
    prefs.remove('userRole');
    try {
      FirebaseAuth.instance.signOut();
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Failed"),
            content: Text("Unable To logout $e"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );
    }
  }
}
