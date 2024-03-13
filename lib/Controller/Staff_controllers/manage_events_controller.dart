// ignore_for_file: use_build_context_synchronously, avoid_print

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
      await FirebaseFirestore.instance
          .collection("Events")
          .doc(documentId)
          .delete();

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

        if (eventRefs.isEmpty) {
          await FirebaseFirestore.instance
              .collection("Speakers")
              .doc(speakerDoc.id)
              .delete();
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error deleting event: $error"),
      ));
    }
  }

  // Future<void> deleteReservations(String eventId) async {
  //   print("function invoked");
  //   try {
  //     print("event Id : $eventId");

  //     // Step 1: Retrieve all docs in the "reservations" collection
  //     QuerySnapshot reservationsSnapshot =
  //         await FirebaseFirestore.instance.collection("reservations").get();

  //     print("retrieved all docs : $reservationsSnapshot");

  //     // Step 2: For each doc in the "reservations" collection
  //     for (int i = 0; i < reservationsSnapshot.docs.length; i++) {
  //       QueryDocumentSnapshot reservationDoc = reservationsSnapshot.docs[i];
  //       print("doc id: ${reservationDoc.id}");

  //       // Step 3: Access sub-collection named "reservations"
  //       CollectionReference eventCollection = FirebaseFirestore.instance
  //           .collection("reservations")
  //           .doc(reservationDoc.id)
  //           .collection("reservations");

  //       print("accessing : ${eventCollection.path}");

  //       // Check if a document with eventId exists in the sub-collection
  //       DocumentSnapshot eventDoc = await eventCollection.doc(eventId).get();
  //       if (eventDoc.exists) {
  //         print("deleting $eventId");
  //         await eventCollection.doc(eventId).delete();
  //         print("deleted");
  //       } else {
  //         print("No document found with eventId: $eventId in sub-collection");
  //       }
  //     }
  //   } catch (error) {
  //     print("Error deleting reservations: $error");
  //   }
  // }
}
