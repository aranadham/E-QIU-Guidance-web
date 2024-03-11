import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qiu_digital_guidance/Controller/Staff_controllers/add_events_controller.dart';
import 'package:qiu_digital_guidance/Widgets/button.dart';
import 'package:qiu_digital_guidance/Widgets/drawer.dart';
import 'package:qiu_digital_guidance/Widgets/outlined_button.dart';
import 'package:qiu_digital_guidance/Widgets/textfield.dart';

class AddEvents extends StatefulWidget {
  const AddEvents({super.key});

  @override
  State<AddEvents> createState() => _AddEventsState();
}

class _AddEventsState extends State<AddEvents> {
  final GlobalKey<FormState> addEventKey = GlobalKey<FormState>();

  @override
  void dispose() {
    addEventKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AddEventController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Events"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 106, 166),
        foregroundColor: Colors.white,
      ),
      drawer: const StaffDrawer(),
      body: SingleChildScrollView(
        controller: controller.scrollController,
        child: Form(
          key: addEventKey,
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                hint: "Event Title",
                onChanged: (value) => controller.setTitle(value),
                validator: controller.validateEventTitle,
              ),
              CustomTextField(
                hint: "Event Description",
                onChanged: (value) => controller.setDescription(value),
                validator: controller.validateEventDescription,
                maxLine: 3,
                maxLength: 100,
              ),
              CustomTextField(
                hint: "Event Type",
                onChanged: (value) => controller.setType(value),
                validator: controller.validateEventType,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: RadioListTile(
                  title: const Text('Public'),
                  activeColor: const Color.fromARGB(255, 0, 174, 239),
                  value: 1,
                  groupValue: controller.selectedRadio,
                  onChanged: (value) {
                    controller.setSelectedRadio(value!);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: RadioListTile(
                  title: const Text('Private'),
                  activeColor: const Color.fromARGB(255, 0, 174, 239),
                  value: 2,
                  groupValue: controller.selectedRadio,
                  onChanged: (value) {
                    controller.setSelectedRadio(value!);
                  },
                ),
              ),
              CustomTextField(
                hint: "Event Venue",
                onChanged: (value) => controller.setVenue(value),
                validator: controller.validateEventVenue,
              ),
              const SizedBox(
                height: 10,
              ),
              const ListTile(
                title: Text("Event Start Date:"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "${controller.selectedStartDateTime}",
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              OutlinedBtn(
                text: "Select Time",
                onPressed: () {
                  controller.pickStartTime(context);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              OutlinedBtn(
                text: "Select Date",
                onPressed: () {
                  controller.pickStartDate(context);
                },
              ),
              const ListTile(
                title: Text("Event End Date:"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "${controller.selectedEndDateTime}",
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              OutlinedBtn(
                text: "Select Time",
                onPressed: () {
                  controller.pickEndTime(context);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              OutlinedBtn(
                text: "Select Date",
                onPressed: () {
                  controller.pickEndDate(context);
                },
              ),
              ListTile(
                title: Text("Duration: ${controller.calculateEventDuration()}"),
              ),
              ListTile(
                title: Text(
                    "Number of Speaker: ${controller.speakersData.length}"),
                trailing: Column(
                  children: [
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          controller.incrementNumberOfFields();
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          controller.decrementNumberOfFields();
                        },
                        icon: const Icon(Icons.remove),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              for (int index = 0;
                  index < controller.speakersData.length;
                  index++)
                Column(
                  children: [
                    CustomTextField(
                      hint: controller.speakersData[index]['Speaker'],
                      onChanged: (value) {
                        controller.setSpeaker(index, value);
                      },
                      validator: controller.validateEventSpeaker,
                    ),
                    CustomTextField(
                      hint: controller.speakersData[index]['Description'],
                      onChanged: (value) {
                        controller.setSpeakerDescription(index, value);
                      },
                      validator: controller.validateEventSpeakerDescription,
                      maxLength: 50,
                      maxLine: 3,
                    ),
                  ],
                ),
              CustomTextField(
                hint: "Available seats",
                keyboard: TextInputType.number,
                onChanged: (value) =>
                    controller.setAvailableSeats(int.parse(value)),
              ),
              CustomTextField(
                hint: "Reserved Seats",
                keyboard: TextInputType.number,
                onChanged: (value) =>
                    controller.setReservedSeats(int.parse(value)),
              ),
              const SizedBox(
                height: 20,
              ),
              Btn(
                text: "Add Event",
                fontsize: 18,
                onPressed: () {
                  if (addEventKey.currentState?.validate() ?? false) {
                    controller.addEvent(context);
                  }
                },
                isDisabled: false,
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
