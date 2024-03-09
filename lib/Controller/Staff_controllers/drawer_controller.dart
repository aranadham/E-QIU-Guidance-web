import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qiu_digital_guidance/View/login.dart';
import 'package:qiu_digital_guidance/View/staff%20view/add_events.dart';
import 'package:qiu_digital_guidance/View/staff%20view/manage_events.dart';
import 'package:qiu_digital_guidance/View/staff%20view/register_staff.dart';
import 'package:qiu_digital_guidance/View/staff%20view/register_student.dart';

class StaffDrawerController extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setIndex(int index, BuildContext context) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();

      switch (index) {
        case 0:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEvents(),
            ),
          );
          break;
        case 1:
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ManageEvents()),
          );
          break;
        case 2:
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const RegisterStaff()),
          );
          break;
        case 3:
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const RegisterStudent()),
          );
          break;
        case 4:
          Navigator.pop(context);
          try {
            FirebaseAuth.instance.signOut();
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
          break;
        default:
          break;
      }
    } else {
      Navigator.pop(context);
    }
  }
}
