import 'package:e_qiu_guidance/Widgets/desktop_widgets/navbar.dart';
import 'package:e_qiu_guidance/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_qiu_guidance/Controller/Staff_controllers/register_controller.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/button.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/drawer.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/textfield.dart';

class RegisterStaffDesktop extends StatefulWidget {
  const RegisterStaffDesktop({super.key});

  @override
  State<RegisterStaffDesktop> createState() => _RegisterStaffDesktopState();
}

class _RegisterStaffDesktopState extends State<RegisterStaffDesktop> {
  final GlobalKey<FormState> registerStaffKey = GlobalKey<FormState>();

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
          key: registerStaffKey,
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                hint: "Staff Name",
                validator: controller.validateUserName,
                onChanged: (value) => controller.setUserName(value),
              ),
              CustomTextField(
                hint: "Email",
                keyboard: TextInputType.emailAddress,
                onChanged: (value) => controller.setEmail(value),
                validator: controller.validateEmail,
              ),
              CustomTextField(
                hint: "Password",
                obscureText: true,
                onChanged: (value) => controller.setPassword(value),
                validator: controller.validatePassword,
              ),
              const SizedBox(height: 20),
              Btn(
                text: "Register Staff",
                onPressed: () {
                  if (registerStaffKey.currentState?.validate() ?? false) {
                    controller.registerStaff(context);
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
