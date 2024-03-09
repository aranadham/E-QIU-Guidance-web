import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qiu_digital_guidance/Controller/Staff_controllers/add_events_controller.dart';
import 'package:qiu_digital_guidance/Controller/Staff_controllers/drawer_controller.dart';
import 'package:qiu_digital_guidance/Controller/Staff_controllers/register_controller.dart';
import 'package:qiu_digital_guidance/Controller/calendar_controller.dart';
import 'package:qiu_digital_guidance/Controller/fetch_controller.dart';
import 'package:qiu_digital_guidance/Controller/login_controller.dart';
import 'package:qiu_digital_guidance/Controller/Staff_controllers/manage_events_controller.dart';
import 'package:qiu_digital_guidance/Controller/seat_controller.dart';
import 'package:qiu_digital_guidance/View/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginController(),
        ),
        ChangeNotifierProvider(
          create: (_) => StaffDrawerController(),
        ),
        ChangeNotifierProvider(
          create: (_) => AddEventController(),
        ),
        ChangeNotifierProvider(
          create: (_) => ManageEventsController(),
        ),
        ChangeNotifierProvider(
          create: (_) => FetchController(),
        ),
        ChangeNotifierProvider(
          create: (_) => Register(),
        ),
        ChangeNotifierProvider(
          create: (_) => SeatController(),
        ),
        ChangeNotifierProvider(
          create: (_) => CalendarController(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Electronic Qiu Guidance',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const Login(),
      ),
    );
  }
}
