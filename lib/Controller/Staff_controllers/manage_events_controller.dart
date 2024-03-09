// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qiu_digital_guidance/Model/events.dart';

class ManageEventsController extends ChangeNotifier {
  Stream<List<Event>> fetchEvents() {
    return FirebaseFirestore.instance
        .collection("Events")
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((doc) {
        String documentId = doc.id;
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Event.fromMap(documentId, data);
      }).toList();
    });
  }

  String formatDateTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat("dd/MM/yyyy HH:mm").format(dateTime);
  }

  String formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat("dd/MM/yyyy").format(dateTime);
  }

  String formatTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat("HH:mm").format(dateTime);
  }

  Future<void> deleteEvent({
  required BuildContext context,
  required String documentId,
}) async {
  try {
    // Step 1: Delete the event from the "Events" collection
    await FirebaseFirestore.instance.collection("Events").doc(documentId).delete();

    // Step 2: Retrieve the list of speakers referencing the deleted event
    QuerySnapshot speakersSnapshot = await FirebaseFirestore.instance
        .collection("Speakers")
        .where("eventRefs", arrayContains: documentId)
        .get();

    // Step 3: Update each speaker document to remove the deleted event reference
    for (QueryDocumentSnapshot speakerDoc in speakersSnapshot.docs) {
      List<String> eventRefs = List<String>.from(speakerDoc["eventRefs"]);
      eventRefs.remove(documentId);

      // Update the speaker document
      await FirebaseFirestore.instance
          .collection("Speakers")
          .doc(speakerDoc.id)
          .update({"eventRefs": eventRefs});
    }

  } catch (error) {
    // Handle errors, e.g., display an error message to the user
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Error deleting event: $error"),
    ));
  }
}
}
