import 'package:e_qiu_guidance/View/desktop_view/view_seat_desktop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_qiu_guidance/Controller/event_search_controller.dart';
import 'package:e_qiu_guidance/Controller/fetch_controller.dart';
import 'package:e_qiu_guidance/Model/events.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/search_field.dart';

class SeatsDesktop extends StatelessWidget {
  final String userId;
  const SeatsDesktop({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<FetchController>(context);
    final search = Provider.of<EventSearchController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reserved Seats"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 106, 166),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/QIU wallpaper2.jpg"),
              fit: BoxFit.cover),
        ),
        child: Container(
          color: Colors.grey.withOpacity(0.9),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 100, horizontal: 280),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white, // Adjust opacity as needed
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              children: [
                SearchField(
                  label: "Search by event name",
                  onChanged: (query) {
                    search.updateQuery(query);
                  },
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: controller.fetchReservations(userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (!snapshot.hasData) {
                        const Center(
                          child: Text("Your reservations will appear here"),
                        );
                      }

                      List<Event> events = snapshot.data ?? [];
                      List<Event> filteredEvents =
                          search.filterEvents(events, search.query);

                      return ListView.builder(
                        itemCount: filteredEvents.length,
                        itemBuilder: (context, index) {
                          Event event = filteredEvents[index];
                          String startDate =
                              controller.formatDateTime(event.startdate);

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewSeatDesktop(
                                    userId: userId,
                                    eventId: event.id,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: ListTile(
                                title: Text(event.title),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(startDate),
                                    Text(event.venue),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.arrow_forward_ios),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewSeatDesktop(
                                          userId: userId,
                                          eventId: event.id,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}