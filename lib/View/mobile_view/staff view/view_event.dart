import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_qiu_guidance/Controller/fetch_controller.dart';
import 'package:e_qiu_guidance/Model/events.dart';
import 'package:e_qiu_guidance/Model/speaker.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/tile_text.dart';

class ViewEvent extends StatelessWidget {
  final String id;
  const ViewEvent({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<FetchController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 106, 166),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: controller.fetchEvent(documentId: id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          Event? event = snapshot.data!;
          String startDate = controller.formatDateTime(event.startdate);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 60,
              ),
              Center(
                child: Text(
                  event.title,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTile(
                label: "Venue:",
                value: event.venue,
              ),
              CustomTile(label: "Date and Time:", value: startDate),
              CustomTile(label: "Duration:", value: event.duration),

              const CustomText(value: "Event Description:"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Wrap(
                  children: [
                    Text(
                      event.description,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              const CustomText(value: "Speaker(s)"),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: controller.fetchRelatedSpeakers(event.id),
                  builder: (context, speakersSnapshot) {
                    if (speakersSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: Text("Loading...."),
                      );
                    }

                    if (speakersSnapshot.hasError) {
                      return Text('Error: ${speakersSnapshot.error}');
                    }

                    List<Speaker>? speakersData = speakersSnapshot.data!;

                    return ListView.builder(
                      itemCount: speakersData.length,
                      itemBuilder: (context, index) {
                        Speaker speaker = speakersData[index];
                        return ListTile(
                          title: Text(speaker.name),
                          subtitle: Text(speaker.description),
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
