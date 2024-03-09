import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qiu_digital_guidance/Controller/login_controller.dart';
import 'package:qiu_digital_guidance/Widgets/button.dart';
import 'package:qiu_digital_guidance/Widgets/outlined_button.dart';
import 'package:qiu_digital_guidance/Widgets/textfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LoginController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 106, 166),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Image.asset("assets/qiu2.png"),
              const SizedBox(
                height: 50,
              ),
              CustomTextField(
                hint: "Email",
                onChanged: (value) => controller.setEmail(value),
                validator: controller.validateEmail,
              ),
              CustomTextField(
                hint: "Password",
                onChanged: (value) => controller.setPassword(value),
                obscureText: true,
                validator: controller.validatePassword,
              ),
              const SizedBox(
                height: 20,
              ),
              Btn(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        content: Container(
                          padding: const EdgeInsets.all(16),
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text(
                                "Logging in...",
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                  if (controller.formKey.currentState?.validate() ?? false) {
                    await controller.login(context: context);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                text: "Login",
                fontsize: 20,
                isDisabled: false,
              ),
              const SizedBox(
                height: 10,
              ),
              OutlinedBtn(
                text: "Guest",
                fontsize: 20,
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        content: Container(
                          padding: const EdgeInsets.all(16),
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text(
                                "Loading...",
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                  await controller.signInAnonymously(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
