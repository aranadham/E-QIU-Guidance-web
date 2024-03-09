import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qiu_digital_guidance/Controller/seat_controller.dart';
import 'package:qiu_digital_guidance/View/view_calendar.dart';
import 'package:qiu_digital_guidance/View/events.dart';
import 'package:qiu_digital_guidance/View/view_map.dart';
import 'package:qiu_digital_guidance/View/speakers.dart';
import 'package:qiu_digital_guidance/Widgets/box.dart';

class GuestHomePage extends StatelessWidget {
  const GuestHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SeatController>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Guest"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 106, 166),
        foregroundColor: Colors.white,
      ),
      body: Column(
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
    );
  }
}
