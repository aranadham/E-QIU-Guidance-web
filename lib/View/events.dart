import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qiu_digital_guidance/Controller/fetch_controller.dart';
import 'package:qiu_digital_guidance/Controller/search_controller.dart';
import 'package:qiu_digital_guidance/Model/events.dart';
import 'package:qiu_digital_guidance/View/view_event.dart';

class Events extends StatelessWidget {
  const Events({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<FetchController>(context);
    final search = Provider.of<EventSearchController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 106, 166),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: TextField(
              onChanged: (query) {
                search.updateQuery(query);
              },
              decoration: InputDecoration(
                labelText: 'Search by event name',
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12,horizontal: 15),
                isCollapsed: true,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: controller.fetchEvents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
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
                            builder: (context) => ViewPublicEvents(
                              id: event.id,
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
                                builder: (context) => ViewPublicEvents(
                                  id: event.id,
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
