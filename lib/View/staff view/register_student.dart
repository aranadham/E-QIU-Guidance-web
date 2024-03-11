import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qiu_digital_guidance/Controller/Staff_controllers/register_controller.dart';
import 'package:qiu_digital_guidance/Widgets/button.dart';
import 'package:qiu_digital_guidance/Widgets/drawer.dart';
import 'package:qiu_digital_guidance/Widgets/textfield.dart';

class RegisterStudent extends StatefulWidget {
  const RegisterStudent({super.key});

  @override
  State<RegisterStudent> createState() => _RegisterStudentState();
}

class _RegisterStudentState extends State<RegisterStudent> {
  final GlobalKey<FormState> registerStudentKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Register>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Student"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 106, 166),
        foregroundColor: Colors.white,
      ),
      drawer: const StaffDrawer(),
      body: SingleChildScrollView(
        child: Form(
          key: registerStudentKey,
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                hint: "Email",
                validator: controller.validateEmail,
                onChanged: (value) => controller.setEmail(value),
              ),
              CustomTextField(
                hint: "Password",
                validator: controller.validatePassword,
                onChanged: (value) => controller.setPassword(value),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Btn(
                text: "Register Student",
                onPressed: () {
                  if (registerStudentKey.currentState?.validate() ?? false) {
                    controller.registerStudent(context);
                  }
                },
                isDisabled: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
