// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:e_qiu_guidance/View/staff%20view/edit_event.dart';
class EditEventsController extends ChangeNotifier {
  String id = "";
  String title = "";
  String description = "";
  String type = "";
  String selectedRadio = "";
  String venue = "";
  DateTime selectedStartDateTime = DateTime.now();
  DateTime selectedEndDateTime = DateTime.now();

  void navigateToEdit({
    required BuildContext context,
    required String id,
    required String title,
    required String description,
    required String type,
    required String radio,
    required String venue,
    required DateTime startDateTime,
    required DateTime endDateTime,
  }) {
    this.id = id;
    this.title = title;
    this.description = description;
    this.type = type;
    selectedRadio = radio;
    this.venue = venue;
    selectedStartDateTime = startDateTime;
    selectedEndDateTime = endDateTime;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditEvent(),
      ),
    );
  }

  void setTitle(String value) {
    title = value;
    notifyListeners();
  }

  void setDescription(String value) {
    description = value;
    notifyListeners();
  }

  void setType(String value) {
    type = value;
    notifyListeners();
  }

  void setSelectedRadio(String value) {
    selectedRadio = value;
    notifyListeners();
  }

  void setVenue(String value) {
    venue = value;
    notifyListeners();
  }

  void pickStartTime(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then(
      (value) {
        if (value != null) {
          if (selectedStartDateTime != null) {
            selectedStartDateTime = DateTime(
              selectedStartDateTime.year,
              selectedStartDateTime.month,
              selectedStartDateTime.day,
              value.hour,
              value.minute,
            );
          } else {
            // Handle case where pickDate hasn't been called yet
            selectedStartDateTime = DateTime.now();
          }

          notifyListeners();
        }
      },
    );
  }

  void pickStartDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    ).then(
      (value) {
        if (value != null) {
          // Combine date and time
          if (selectedStartDateTime != null) {
            selectedStartDateTime = DateTime(
              value.year,
              value.month,
              value.day,
              selectedStartDateTime.hour,
              selectedStartDateTime.minute,
            );
          } else {
            // Handle case where pickTime hasn't been called yet
            selectedStartDateTime = value;
          }

          notifyListeners();
        }
      },
    );
  }

  void pickEndTime(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then(
      (value) {
        if (value != null) {
          if (selectedEndDateTime != null) {
            selectedEndDateTime = DateTime(
              selectedEndDateTime.year,
              selectedEndDateTime.month,
              selectedEndDateTime.day,
              value.hour,
              value.minute,
            );
          } else {
            // Handle case where pickDate hasn't been called yet
            selectedEndDateTime = DateTime.now();
          }

          notifyListeners();
        }
      },
    );
  }

  void pickEndDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    ).then(
      (value) {
        if (value != null) {
          // Combine date and time
          if (selectedEndDateTime != null) {
            selectedEndDateTime = DateTime(
              value.year,
              value.month,
              value.day,
              selectedEndDateTime.hour,
              selectedEndDateTime.minute,
            );
          } else {
            // Handle case where pickTime hasn't been called yet
            selectedEndDateTime = value;
          }

          notifyListeners();
        }
      },
    );
  }

  String calculateEventDuration() {
    final Duration duration =
        selectedEndDateTime.difference(selectedStartDateTime);
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);

    return "$hours hour(s) $minutes minutes";
  }

  String? validateEventTitle(String? value) {
    if (value!.isEmpty) {
      return 'Please enter the event title';
    } else if (value.length < 6 || value.length > 30) {
      return 'Event title should be between 6 and 30 characters';
    }
    return null;
  }

  String? validateEventDescription(String? value) {
    if (value!.isEmpty) {
      return 'Please enter the event description';
    } else if (value.length < 11 || value.length > 100) {
      return 'Event description should be between 11 and 100 characters';
    }
    return null;
  }

  String? validateEventType(String? value) {
    if (value!.isEmpty) {
      return 'Please enter the event type';
    } else if (value.length < 5 || value.length > 20) {
      return 'Event type should be between 5 and 20 characters';
    }
    return null;
  }

  String? validateEventVenue(String? value) {
    if (value!.isEmpty) {
      return 'Please enter the event venue';
    } else if (value.length < 2 || value.length > 6) {
      return 'Event venue should be between 2 and 6 characters';
    }
    return null;
  }

  Future<void> updateEvent(BuildContext context) async {
    try {
      if (selectedStartDateTime != null && selectedEndDateTime != null) {
        Timestamp startdate = Timestamp.fromDate(selectedStartDateTime);
        Timestamp enddate = Timestamp.fromDate(selectedEndDateTime);
        await FirebaseFirestore.instance.collection("Events").doc(id).update(
          {
            'title': title,
            'description': description,
            'type': type,
            'visibility': selectedRadio,
            'venue': venue,
            'Start Date': startdate,
            'End Date': enddate,
            'Duration': calculateEventDuration(),
          },
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Event updated successfully!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } on FirebaseException {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('some thing went wrong'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
