import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_qiu_guidance/Controller/Staff_controllers/edit_event_controller.dart';
import 'package:e_qiu_guidance/Widgets/button.dart';
import 'package:e_qiu_guidance/Widgets/outlined_button.dart';
import 'package:e_qiu_guidance/Widgets/textfield.dart';

class EditEvent extends StatefulWidget {
  const EditEvent({super.key});

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  late final EditEventsController controller;
  bool controllerInitialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!controllerInitialized) {
      controller = Provider.of<EditEventsController>(context);

      controllerInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Event"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 106, 166),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              initialValue: controller.title,
              hint: "Event Title",
              onChanged: (value) => controller.setTitle(value),
            ),
            CustomTextField(
              initialValue: controller.description,
              hint: "Event Description",
              onChanged: (value) => controller.setDescription(value),
              maxLine: 3,
              maxLength: 100,
            ),
            CustomTextField(
              initialValue: controller.type,
              hint: "Event Type",
              onChanged: (value) => controller.setType(value),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: RadioListTile(
                title: const Text('Public'),
                activeColor: const Color.fromARGB(255, 0, 174, 239),
                value: "Public",
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
                value: "Private",
                groupValue: controller.selectedRadio,
                onChanged: (value) {
                  controller.setSelectedRadio(value!);
                },
              ),
            ),
            CustomTextField(
              initialValue: controller.venue,
              hint: "Event venue",
              onChanged: (value) => controller.setVenue(value),
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
            const SizedBox(
              height: 20,
            ),
            Btn(
              text: "Update",
              onPressed: () async{
                await controller.updateEvent(context);
              },
              isDisabled: false,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.title = "";
    controller.description = "";
    controller.type = "";
    controller.selectedRadio = "";
    controller.venue = "";
    controller.selectedStartDateTime = DateTime.now();
    controller.selectedEndDateTime = DateTime.now();
    super.dispose();
  }
}
