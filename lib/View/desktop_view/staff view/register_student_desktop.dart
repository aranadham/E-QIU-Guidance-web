import 'package:e_qiu_guidance/Widgets/desktop_widgets/navbar.dart';
import 'package:e_qiu_guidance/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_qiu_guidance/Controller/Staff_controllers/register_controller.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/button.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/drawer.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/textfield.dart';

class RegisterStudentDesktop extends StatefulWidget {
  const RegisterStudentDesktop({super.key});

  @override
  State<RegisterStudentDesktop> createState() => _RegisterStudentDesktopState();
}

class _RegisterStudentDesktopState extends State<RegisterStudentDesktop> {
  final GlobalKey<FormState> registerStudentKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Register>(context);

    return Scaffold(
      appBar: AppBar(
        title: NavBar(),
        backgroundColor: blue,
      ),
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
