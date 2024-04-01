// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_qiu_guidance/Controller/seat_controller.dart';
import 'package:e_qiu_guidance/Model/events.dart';
import 'package:e_qiu_guidance/Model/speaker.dart';
import 'package:e_qiu_guidance/View/mobile_view/view_speaker.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/button.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/tile_text.dart';
import 'package:e_qiu_guidance/Controller/fetch_controller.dart';

class ViewPublicEvents extends StatefulWidget {
  final String id;
  const ViewPublicEvents({
    super.key,
    required this.id,
  });

  @override
  State<ViewPublicEvents> createState() => _ViewPublicEventsState();
}

class _ViewPublicEventsState extends State<ViewPublicEvents> {
  @override
  void initState() {
    super.initState();

    SeatController seatController =
        Provider.of<SeatController>(context, listen: false);

    seatController.checkReservationStatus(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<FetchController>(context);
    final seat = Provider.of<SeatController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 106, 166),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: controller.fetchEvent(documentId: widget.id),
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
                label: "Venue",
                value: event.venue,
              ),
              CustomTile(label: "Date and Time:", value: startDate),
              CustomTile(label: "Duration:", value: event.duration),
              const CustomText(value: "Event Description"),
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
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ViewSpeaker(id: speaker.id),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(speaker.name),
                            subtitle: Text(speaker.description),
                            trailing: IconButton(
                              icon: const Icon(Icons.arrow_forward_ios),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ViewSpeaker(id: speaker.id),
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
              Center(
                child: Btn(
                  text: "Attend",
                  onPressed: () async {
                    if (event.seatCount < event.availableSeats) {
                      await seat.reserveSeat(context, event.id);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: const Text("Sorry All Seats Are Taken!"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("OK"),
                              )
                            ],
                          );
                        },
                      );
                    }
                  },
                  isDisabled: seat.isReserved,
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          );
        },
      ),
    );
  }
}
