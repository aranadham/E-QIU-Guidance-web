import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qiu_digital_guidance/Controller/fetch_controller.dart';
import 'package:qiu_digital_guidance/Model/events.dart';
import 'package:qiu_digital_guidance/Model/speaker.dart';
import 'package:qiu_digital_guidance/View/view_event.dart';
import 'package:qiu_digital_guidance/Widgets/tile_text.dart';

class ViewSpeaker extends StatelessWidget {
  final String id;
  const ViewSpeaker({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<FetchController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Speaker"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 106, 166),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: controller.fetchSpeaker(documentId: id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            const Center(
              child: Text("Speaker Not Found"),
            );
          }

          Speaker? speaker = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 60,
              ),
              CustomText(value: speaker.name),
              CustomText(value: speaker.description),
              const SizedBox(
                height: 40,
              ),
              const CustomText(value: "Related Sessions"),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: controller.fetchRelatedEvents(speaker.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: Text("Loading...."),
                      );
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    List<Event> events = snapshot.data ?? [];

                    return ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        Event event = events[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ViewPublicEvents(id: event.id),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(
                              event.title,
                            ),
                            subtitle: Text(
                              event.venue,
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.arrow_forward_ios),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ViewPublicEvents(id: event.id),
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
          );
        },
      ),
    );
  }
}