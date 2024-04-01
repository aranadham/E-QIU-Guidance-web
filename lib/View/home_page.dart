import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_qiu_guidance/Controller/logout_controller.dart';
import 'package:e_qiu_guidance/Controller/seat_controller.dart';
import 'package:e_qiu_guidance/View/view_calendar.dart';
import 'package:e_qiu_guidance/View/events.dart';
import 'package:e_qiu_guidance/View/view_map.dart';
import 'package:e_qiu_guidance/View/speakers.dart';
import 'package:e_qiu_guidance/Widgets/box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SeatController>(context);
    final logoutcontroller = Provider.of<LogoutController>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Home"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 106, 166),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              logoutcontroller.logout(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/uni2.jpg"), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  Box(
                    icon: Icons.map,
                    text: "Campus Map",
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ViewMap(),
                        ),
                      );
                    },
                  ),
                  Box(
                    icon: Icons.event,
                    text: "Events",
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Events(),
                        ),
                      );
                    },
                  ),
                  Box(
                    icon: Icons.person,
                    text: "Speakers",
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Speakers(),
                        ),
                      );
                    },
                  ),
                  Box(
                    icon: Icons.chair,
                    text: "Seat",
                    ontap: () {
                      controller.navigateToSeats(context);
                    },
                  ),
                  Box(
                    icon: Icons.calendar_today,
                    text: "Calendar",
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ViewCalendar(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
