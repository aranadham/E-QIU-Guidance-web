import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_qiu_guidance/Controller/fetch_controller.dart';

class ViewSeat extends StatelessWidget {
  final String userId;
  final String eventId;
  const ViewSeat({
    super.key,
    required this.userId,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<FetchController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Seat"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 106, 166),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display reserved seat values
            FutureBuilder<int>(
              future: controller.getReservedSeats(userId, eventId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  int reservedSeat = snapshot.data ?? 0;

                  return Center(
                    child: Column(
                      children: [
                        const Text(
                          "Your Seat Number",
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          reservedSeat.toString(),
                          style: const TextStyle(fontSize: 40),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
