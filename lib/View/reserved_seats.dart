import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_qiu_guidance/Controller/event_search_controller.dart';
import 'package:e_qiu_guidance/Controller/fetch_controller.dart';
import 'package:e_qiu_guidance/Model/events.dart';
import 'package:e_qiu_guidance/View/view_seat.dart';
import 'package:e_qiu_guidance/Widgets/search_field.dart';

class Seats extends StatelessWidget {
  final String userId;
  const Seats({super.key, required this.userId});

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
      body: Column(
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
                    String startDate = controller.formatDateTime(event.startdate);
            
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewSeat(
                              userId: userId,
                              eventId: event.id,
                            ),
                          ),
                        );
                      },
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
                                builder: (context) => ViewSeat(
                                  userId: userId,
                                  eventId: event.id,
                                ),
                              ),
                            );
                          },
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
    );
  }
}
